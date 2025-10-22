# ---------- Imports ----------
from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth import login, authenticate
from django.contrib.auth.decorators import login_required
from django.http import Http404, JsonResponse
from django.db.models import Avg, Count, Q
from django.contrib.auth.forms import AuthenticationForm
from django.contrib import messages
from django.urls import reverse_lazy
from django.contrib.auth.views import LogoutView
from django.contrib.auth.models import User
from functools import wraps
from django.core.paginator import Paginator
import json

import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity

from .models import UserProfile, Post, Rating, Collection
from .forms import CustomUserCreationForm, PostForm, UserPreferenceForm, ProfileCreationForm, ReviewForm

# ---------- Login View ----------
def login_view(request):
    if request.method == 'POST':
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)
            profile, _ = UserProfile.objects.get_or_create(user=user)
            if profile.first_login:
                return redirect('create_profile')
            return redirect('index_view')
    else:
        form = AuthenticationForm()
    return render(request, 'login.html', {'form': form})

# ---------- Register View ----------
def register_view(request):
    if request.method == 'POST':
        form = CustomUserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()

            # Get or create profile properly
            profile, created = UserProfile.objects.get_or_create(user=user)
            profile.email = user.email
            profile.save()  # save the updated email

            login(request, user)
            return redirect('create_profile')
    else:
        form = CustomUserCreationForm()

    return render(request, 'register.html', {'form': form})

# ---------- Ensure User Profile Decorator ----------
def ensure_user_profile(view_func):
    @wraps(view_func)
    def _wrapped_view(request, *args, **kwargs):
        if request.user.is_authenticated:
            if not UserProfile.objects.filter(user=request.user).exists():
                return redirect('create_profile')
        return view_func(request, *args, **kwargs)
    return _wrapped_view

# ---------- Create Profile ----------
def create_profile(request):
    if not request.user.is_authenticated:
        return redirect('login')

    user_profile, _ = UserProfile.objects.get_or_create(user=request.user)

    if request.method == "POST":
        form = ProfileCreationForm(request.POST, request.FILES, instance=user_profile)
        if form.is_valid():
            form.save()
            return redirect('get_started')
    else:
        form = ProfileCreationForm(instance=user_profile)
    return render(request, "create_profile.html", {"form": form})

# ---------- Get Started (User Preferences) ----------
@login_required
@ensure_user_profile
def get_started(request):
    profile = request.user.userprofile
    if request.method == 'POST':
        form = UserPreferenceForm(request.POST, instance=profile)
        if form.is_valid():
            form.save()
            profile.first_login = False
            profile.save()
            return redirect('index_view')
    else:
        form = UserPreferenceForm(instance=profile)
    return render(request, 'get_started.html', {'form': form})

# ---------- Index View (Main Page) ----------
@login_required
def index_view(request):
    query = request.GET.get('q', '')
    posts = Post.objects.all()
    top_rated_posts = Post.objects.filter(rating__gte=4).order_by('-rating', '-created_at')
    paginator = Paginator(top_rated_posts, 6)
    page_number = request.GET.get('page')
    travelers_page = paginator.get_page(page_number)

    if query:
        posts = posts.filter(
            Q(title__icontains=query) |
            Q(content__icontains=query) |
            Q(tags__name__icontains=query)
        ).distinct()

    recommended_posts = get_recommendations_for_user(request.user, top_n=6)

    travelers_choice = Post.objects.order_by('-rating', '-created_at').first()

    if not recommended_posts.exists():
        user_profile = UserProfile.objects.filter(user=request.user).first()
        if user_profile and user_profile.tags.exists():
            recommended_posts = (
                Post.objects.filter(tags__in=user_profile.tags.all())
                .distinct()
                .annotate(tag_match=Count('tags'))
                .order_by('-tag_match', '-created_at')[:6]
            )
        else:
            recommended_posts = Post.objects.order_by('-created_at')[:6]

    collection, _ = Collection.objects.get_or_create(user=request.user)
    saved_posts = collection.posts.values_list('id', flat=True)

    context = {
        'posts': posts,
        'recommended_posts': recommended_posts,
        'travelers_choice': travelers_choice,
        'saved_posts': saved_posts,
        'travelers_page': travelers_page,

    }
    return render(request, 'index.html', context)

# ---------- Admin-Only Post Creation ----------
@login_required
def create_post(request):
    if not request.user.is_staff:
        return redirect('index_view')

    if request.method == 'POST':
        form = PostForm(request.POST, request.FILES)
        if form.is_valid():
            post = form.save(commit=False)
            post.author = request.user.userprofile
            post.save()
            form.save_m2m()
            return redirect('post_detail', post_id=post.pk)
    else:
        form = PostForm()
    return render(request, 'create_post.html', {'form': form})

# ---------- Post Detail ----------
@login_required
def post_detail(request, post_id):
    post = get_object_or_404(Post, id=post_id)
    reviews = post.reviews.order_by('-created_at')
    collection, _ = Collection.objects.get_or_create(user=request.user)
    saved_posts = collection.posts.values_list('id', flat=True)
    
    # Average rating
    average_rating = Rating.objects.filter(post=post).aggregate(Avg('value'))['value__avg']    
    # User's rating for this post
    try:
        user_rating = Rating.objects.get(user=request.user, post=post).value
    except Rating.DoesNotExist:
        user_rating = 0

    context = {
        'post': post,
        'is_saved': post.id in saved_posts,
        'average_rating': average_rating,
        'user_rating': user_rating,   # send this to template
        'reviews': reviews,
    }
    return render(request, 'post_detail.html', context)

# ---------- User Profile ----------
def user_profile(request, username=None):
    if not username:
        raise Http404("User not found")
    user = get_object_or_404(User, username=username)
    return render(request, 'user_profile.html', {'profile_user': user})

# ---------- Logout View ----------
class CustomLogoutView(LogoutView):
    next_page = reverse_lazy('/')

    def post(self, request, *args, **kwargs):
        response = super().post(request, *args, **kwargs)
        return redirect(self.get_next_page())

    def get_next_page(self):
        return self.request.POST.get('next', self.next_page)

# ---------- Toggle Collection (Save/Unsave) ----------
@login_required
def toggle_collection(request, post_id):
    post = get_object_or_404(Post, id=post_id)
    collection, _ = Collection.objects.get_or_create(user=request.user)
    if post in collection.posts.all():
        collection.posts.remove(post)
        added = False
    else:
        collection.posts.add(post)
        added = True
    return JsonResponse({'added': added})

@login_required
def remove_from_collection(request, post_id):
    post = get_object_or_404(Post, id=post_id)
    collection, _ = Collection.objects.get_or_create(user=request.user)
    if post in collection.posts.all():
        collection.posts.remove(post)
        removed = True
    else:
        removed = False
    return JsonResponse({'removed': removed})

# ---------- Similar Posts ----------
def get_similar_posts(post_id, n=5):
    matrix = build_user_post_matrix()
    if matrix.empty or post_id not in matrix.columns:
        return Post.objects.none()

    post_similarity = cosine_similarity(matrix.T)
    post_similarity_df = pd.DataFrame(post_similarity, index=matrix.columns, columns=matrix.columns)

    similar_scores = post_similarity_df[post_id].sort_values(ascending=False)[1:n+1]
    similar_posts = Post.objects.filter(id__in=similar_scores.index)
    return similar_posts

# ---------- Build User-Post Matrix ----------
def build_user_post_matrix():
    data = []
    for collection in Collection.objects.prefetch_related('posts', 'user'):
        for post in collection.posts.all():
            data.append({'user_id': collection.user.id, 'post_id': post.id, 'value': 1})

    if not data:
        return pd.DataFrame()

    df = pd.DataFrame(data)
    matrix = df.pivot_table(index='user_id', columns='post_id', values='value', fill_value=0)
    return matrix

# ---------- Get Recommendations for a User ----------
def get_recommendations_for_user(user, top_n=5):
    matrix = build_user_post_matrix()

    if matrix.empty or user.id not in matrix.index:
        return Post.objects.none()

    user_sim = cosine_similarity(matrix)
    user_sim_df = pd.DataFrame(user_sim, index=matrix.index, columns=matrix.index)

    similar_users = user_sim_df[user.id].drop(user.id).sort_values(ascending=False)
    if similar_users.empty:
        return Post.objects.none()

    user_collections = set(Collection.objects.get(user=user).posts.values_list('id', flat=True))
    scores = matrix.T.dot(similar_users.reindex(matrix.index).fillna(0))

    recommended_post_ids = (
        scores[~scores.index.isin(user_collections)]
        .sort_values(ascending=False)
        .head(top_n)
        .index
    )

    recommended_posts = Post.objects.filter(id__in=recommended_post_ids)
    return recommended_posts 

def add_review(request, post_id):
    post = get_object_or_404(Post, pk=post_id)

    if request.method == 'POST':
        form = ReviewForm(request.POST, request.FILES)
        if form.is_valid():
            review = form.save(commit=False)
            review.user = request.user
            review.post = post
            review.save()
            return redirect('post_detail', post_id=post.pk)
    else:
        form = ReviewForm()

    return render(request, 'post_detail.html', {'post': post, 'form': form})

@login_required
def post_rating(request, post_id):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)  # parse JSON body
            rating_value = data.get('rating_value')
        except (json.JSONDecodeError, KeyError):
            return JsonResponse({'success': False, 'error_message': 'Invalid JSON data'})

        if rating_value is not None and isinstance(rating_value, int) and 1 <= rating_value <= 5:
            user = request.user
            post = get_object_or_404(Post, id=post_id)

            rating_obj, created = Rating.objects.get_or_create(user=user, post=post)
            rating_obj.value = rating_value
            rating_obj.save()

            average_rating = Rating.objects.filter(post=post).aggregate(Avg('value'))['value__avg'] or 0

            return JsonResponse({'success': True, 'average_rating': average_rating})

        return JsonResponse({'success': False, 'error_message': 'Invalid rating value'})

    return JsonResponse({'success': False, 'error_message': 'Invalid request method'})