# ---------- Imports ----------
from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth import login, authenticate
from django.contrib.auth.decorators import login_required
from django.http import Http404, JsonResponse
from django.db.models import Avg, Count, Q, Max, Subquery,  OuterRef
from django.contrib.auth.forms import AuthenticationForm
from django.contrib import messages
from django.urls import reverse_lazy
from django.contrib.auth.views import LogoutView
from django.contrib.auth.models import User
from functools import wraps
from django.core.paginator import Paginator, PageNotAnInteger, EmptyPage
import json
from django.views.decorators.http import require_POST
from django.template.loader import render_to_string
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity

from .models import UserProfile, Post, Rating, Collection, ReviewImage, ReviewLike, Review, Tag
from .forms import CustomUserCreationForm, PostForm, UserPreferenceForm, ProfileCreationForm, ReviewForm

# ---------- Login View ----------
def login_view(request):
    if request.user.is_authenticated:
        return redirect('index_view')

    if request.method == 'POST':
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)

            request.session.set_expiry(1209600)

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

@login_required
def index_view(request):
    # Main posts pagination (for infinite scroll)
    page_num = request.GET.get('page', 1)
    
    # Traveler's choice pagination
    travelers_page_num = request.GET.get('travelers_page', 1)
    
    query = request.GET.get('q', '')
    
    print("=== DEBUG: View started ===")
    
    # SIMPLE QUERY for infinite scroll (ALL POSTS)
    all_posts = Post.objects.all().order_by('-created_at')
    
    # Search functionality
    if query:
        all_posts = all_posts.filter(
            Q(title__icontains=query) |
            Q(content__icontains=query) |
            Q(tags__name__icontains=query)
        ).distinct()

    # Pagination for infinite scroll (main posts)
    paginator = Paginator(all_posts, 6)
    try:
        page_num = int(page_num)
        all_posts_page = paginator.page(page_num)
    except (PageNotAnInteger, ValueError):
        all_posts_page = paginator.page(1)
    except EmptyPage:
        all_posts_page = paginator.page(paginator.num_pages)

    # Get saved posts
    try:
        collection, created = Collection.objects.get_or_create(user=request.user)
        saved_posts = list(collection.posts.values_list('id', flat=True))
        print(f"DEBUG: User has {len(saved_posts)} saved posts")
    except Exception as e:
        print(f"DEBUG: Collection error: {e}")
        saved_posts = []

    # ENHANCED TAG-BASED RECOMMENDATIONS
    print("=== DEBUG: Getting enhanced tag-based recommendations ===")
    recommended_posts = get_enhanced_tag_recommendations(request.user)
    print(f"DEBUG: Final recommended posts count: {recommended_posts.count()}")

    # TOP-RATED POSTS for Traveler's Choice (with separate pagination)
    top_rated_posts = Post.objects.annotate(
        avg_rating=Avg('ratings__value')
    ).filter(avg_rating__gte=4).order_by('-avg_rating', '-created_at')
    
    # Pagination for top-rated posts (traveler's choice)
    travelers_paginator = Paginator(top_rated_posts, 3)  # 3 posts per page for sidebar
    try:
        travelers_page_num = int(travelers_page_num)
        travelers_page = travelers_paginator.page(travelers_page_num)
    except (PageNotAnInteger, ValueError):
        travelers_page = travelers_paginator.page(1)
    except EmptyPage:
        travelers_page = travelers_paginator.page(travelers_paginator.num_pages)

    print(f"DEBUG: Traveler's Choice - Page {travelers_page_num} of {travelers_paginator.num_pages}")

    # Top tags
    top_tags = Tag.objects.annotate(post_count=Count('posts')).order_by('-post_count')[:6]

    # Handle AJAX requests for infinite scroll
    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        print(f"DEBUG: AJAX request - page {page_num}, has_next: {all_posts_page.has_next()}")
        posts_html = render_to_string('partials/post_list.html', {
            'posts': all_posts_page.object_list,
            'saved_posts': saved_posts,
        })
        return JsonResponse({
            'posts_html': posts_html,
            'has_next': all_posts_page.has_next()
        })

    context = {
        'all_posts_page': all_posts_page,
        'saved_posts': saved_posts,
        'recommended_posts': recommended_posts,
        'travelers_page': travelers_page,
        'top_tags': top_tags,
        'query': query,
        'request': request,
    }

    return render(request, 'index.html', context)

def get_enhanced_tag_recommendations(user, limit=6):
    """
    Fixed recommendation system using the correct field names
    """
    try:
        print("=== DEBUG: Starting enhanced recommendations ===")
        
        # Get all relevant tags from both sources
        all_relevant_tags = get_all_relevant_tags(user)
        
        print(f"DEBUG: Found {len(all_relevant_tags)} relevant tags total")
        if all_relevant_tags:
            for tag in all_relevant_tags:
                print(f"  - {tag.name}")
        
        if all_relevant_tags:
            # Get posts that match these tags (excluding already saved posts)
            saved_post_ids = get_saved_post_ids(user)
            print(f"DEBUG: Excluding {len(saved_post_ids)} saved posts")
            
            # Find posts with matching tags
            recommended = Post.objects.filter(
                tags__in=all_relevant_tags
            ).exclude(
                id__in=saved_post_ids
            ).distinct().annotate(
                matching_tags_count=Count('tags', filter=Q(tags__in=all_relevant_tags))
            ).order_by('-matching_tags_count', '-created_at')[:limit]
            
            print(f"DEBUG: Found {recommended.count()} recommended posts")
            
            # Detailed debug for each recommended post
            for post in recommended:
                post_tags = list(post.tags.all().values_list('name', flat=True))
                relevant_tag_names = [tag.name for tag in all_relevant_tags]
                matching_tags = set(post_tags) & set(relevant_tag_names)
                print(f"DEBUG: '{post.title}' matches {len(matching_tags)} tags: {list(matching_tags)}")
            
            if recommended.exists():
                return recommended
        
        # FALLBACK: If no recommendations found
        print("DEBUG: No tag-based recommendations found, using fallback")
        saved_post_ids = get_saved_post_ids(user)
        return get_popular_posts_fallback(limit, saved_post_ids)
        
    except Exception as e:
        print(f"DEBUG: Enhanced recommendation error: {e}")
        import traceback
        traceback.print_exc()
        return Post.objects.all().order_by('-created_at')[:limit]


def get_all_relevant_tags(user):
    """
    Get all tags that are relevant to the user from both sources
    """
    relevant_tags = set()
    
    # 1. Get preferred tags from UserProfile (using 'tags' field)
    try:
        user_profile = UserProfile.objects.get(user=user)
        preferred_tags = user_profile.tags.all()  
        
        print(f"DEBUG: UserProfile found with {preferred_tags.count()} preferred tags")
        for tag in preferred_tags:
            print(f"  - Preferred: {tag.name}")
        
        relevant_tags.update(preferred_tags)
        
    except UserProfile.DoesNotExist:
        print("DEBUG: UserProfile does not exist")
    except Exception as e:
        print(f"DEBUG: Error getting preferred tags: {e}")
    
    # 2. Get tags from saved posts
    try:
        collection, created = Collection.objects.get_or_create(user=user)
        saved_posts = collection.posts.all()
        
        print(f"DEBUG: User has {saved_posts.count()} saved posts")
        
        if saved_posts.exists():
            # Get all unique tags from saved posts
            saved_tags = Tag.objects.filter(posts__in=saved_posts).distinct()
            
            print(f"DEBUG: Found {saved_tags.count()} tags from saved posts")
            for tag in saved_tags:
                # Count how many saved posts have this tag
                count = saved_posts.filter(tags=tag).count()
                print(f"  - From saved posts: {tag.name} (in {count} posts)")
            
            relevant_tags.update(saved_tags)
            
    except Exception as e:
        print(f"DEBUG: Error getting saved post tags: {e}")
    
    # Convert set to list
    result = list(relevant_tags)
    print(f"DEBUG: Total relevant tags: {len(result)}")
    
    return result


def get_saved_post_ids(user):
    """
    Get list of post IDs that user has already saved
    """
    try:
        collection, created = Collection.objects.get_or_create(user=user)
        saved_ids = list(collection.posts.values_list('id', flat=True))
        print(f"DEBUG: User has {len(saved_ids)} saved posts to exclude")
        return saved_ids
    except Exception as e:
        print(f"DEBUG: Error getting saved post IDs: {e}")
        return []


def get_popular_posts_fallback(limit, exclude_post_ids=None):
    """
    Fallback to popular posts when no tag-based recommendations
    """
    if exclude_post_ids is None:
        exclude_post_ids = []
    
    print("DEBUG: Using popular posts fallback")
    popular_posts = Post.objects.exclude(
        id__in=exclude_post_ids
    ).annotate(
        save_count=Count('collection'),
        rating_count=Count('ratings')
    ).order_by('-save_count', '-rating_count', '-created_at')[:limit]
    
    print(f"DEBUG: Fallback found {popular_posts.count()} popular posts")
    return popular_posts

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


@login_required
def post_detail(request, post_id):
    post = get_object_or_404(Post, id=post_id)

    # Base queryset
    reviews = post.reviews.select_related('user').all()

    # --- FILTER ---
    filter_by = request.GET.get('filter', 'all')
    if filter_by == 'with_photos':
        reviews = reviews.filter(images__isnull=False).distinct()

    # --- SORT ---
    sort_by = request.GET.get('sort', 'new')

    # Annotate rating and likes
    reviews = reviews.annotate(
        rating_value=Subquery(
            Rating.objects.filter(user=OuterRef('user_id'), post=post)
            .values('value')[:1]
        ),
        total_likes=Count('likes')
    )

    # Apply sorting
    if sort_by == 'new':
        reviews = reviews.order_by('-created_at')
    elif sort_by == 'highest':
        reviews = reviews.order_by('-rating_value', '-created_at')
    elif sort_by == 'lowest':
        reviews = reviews.order_by('rating_value', '-created_at')
    elif sort_by == 'most_likes':
        reviews = reviews.order_by('-total_likes', '-created_at')
    elif sort_by == 'least_likes':
        reviews = reviews.order_by('total_likes', '-created_at')

    # Likes for current user
    user_liked_review_ids = ReviewLike.objects.filter(
        user=request.user, review__in=reviews
    ).values_list('review_id', flat=True)

    # Average rating
    rating_stats = Rating.objects.filter(post=post).aggregate(
        average=Avg('value'),
        count=Count('id')
    )

    # Review form
    review_form = ReviewForm()

    context = {
        'post': post,
        'reviews': reviews,
        'review_form': review_form,
        'user_liked_review_ids': list(user_liked_review_ids),
        'average_rating': rating_stats['average'],
        'rating_count': rating_stats['count'],
        'filter_by': filter_by,
        'sort_by': sort_by,
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
    if request.method == 'POST':
        try:
            post = Post.objects.get(id=post_id)
            collection, created = Collection.objects.get_or_create(user=request.user)
            
            if post in collection.posts.all():
                # Remove from collection
                collection.posts.remove(post)
                added = False
            else:
                # Add to collection
                collection.posts.add(post)
                added = True
            
            # Get updated count
            total_saved = collection.posts.count()
            
            return JsonResponse({
                'added': added,
                'total_saved': total_saved,
                'post_id': post_id,
                'post_title': post.title, 
                'success': True
            })
            
        except Post.DoesNotExist:
            return JsonResponse({
                'error': 'Post not found',
                'success': False
            }, status=404)
        except Exception as e:
            return JsonResponse({
                'error': str(e),
                'success': False
            }, status=500)
    
    return JsonResponse({'error': 'Invalid method'}, status=405)

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

@login_required
def add_review(request, post_id):
    """
    Handle posting a new review/comment on a post.
    Supports normal form submission and AJAX.
    """
    post = get_object_or_404(Post, id=post_id)

    if request.method == 'POST':
        form = ReviewForm(request.POST, request.FILES)
        if form.is_valid():
            review = form.save(commit=False)
            review.user = request.user
            review.post = post
            review.save()

            for image in request.FILES.getlist('images'):
                ReviewImage.objects.create(review=review, image=image)

            if request.headers.get('x-requested-with') == 'XMLHttpRequest':
                return JsonResponse({
                    "success": True,
                    "user": review.user.username,
                    "comment": review.comment,
                    "created_at": review.created_at.strftime("%b %d, %Y %I:%M %p"),
                })
            return redirect('post_detail', post_id=post.id)
        else:
            if request.headers.get('x-requested-with') == 'XMLHttpRequest':
                return JsonResponse({"success": False, "errors": form.errors}, status=400)

    return redirect('post_detail', post_id=post.id)

@require_POST
@login_required
def post_rating(request, post_id):
    try:
        data = json.loads(request.body) 
        rating_value = data.get('rating_value')
    except json.JSONDecodeError:
        return JsonResponse({'success': False, 'error_message': 'Invalid JSON'})

    if rating_value is not None and isinstance(rating_value, int):
        value = rating_value
        post = get_object_or_404(Post, id=post_id)

        rating, created = Rating.objects.update_or_create(
            user=request.user,
            post=post,
            defaults={'value': value}
        )

        average_rating = Rating.objects.filter(post=post).aggregate(Avg('value'))['value__avg']

        return JsonResponse({'success': True, 'average_rating': average_rating})

    return JsonResponse({'success': False, 'error_message': 'Invalid rating value'})

@login_required
def toggle_like_review(request, review_id):
    review = get_object_or_404(Review, id=review_id)
    like, created = ReviewLike.objects.get_or_create(review=review, user=request.user)

    if not created:  # Already liked → remove like
        like.delete()
        liked = False
    else:
        liked = True

    return JsonResponse({
        'success': True,
        'liked': liked,
        'likes_count': review.likes_count,
    })
    
@login_required
def tag_posts_view(request, tag_name):
    # Get the tag or 404
    tag = get_object_or_404(Tag, name=tag_name)
    
    # Get all posts that include this tag
    posts = (
        Post.objects.filter(tags=tag)
        .annotate(avg_rating=Avg('ratings__value'))
        .order_by('-created_at')
    )

    # Saved posts for the current user (for your heart/save logic)
    collection, _ = Collection.objects.get_or_create(user=request.user)
    saved_posts = collection.posts.values_list('id', flat=True)

    context = {
        'tag': tag,
        'posts': posts,
        'saved_posts': saved_posts,
    }

    return render(request, 'tag_posts.html', context)