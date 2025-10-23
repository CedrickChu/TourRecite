from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.core.validators import RegexValidator
from django.utils import timezone
from django.utils.translation import gettext as _
from django.urls import reverse
from django.contrib.auth.models import User  

class Tag(models.Model):
    """Optional tags for posts"""
    name = models.CharField(max_length=50, unique=True)

    def __str__(self):
        return self.name

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)
    email = models.EmailField(unique=True, blank=True, null=True)

    first_name = models.CharField(max_length=150, blank=True, null=True)
    last_name = models.CharField(max_length=150, blank=True, null=True)
    about_me = models.TextField(blank=True, null=True)
    profile_image = models.ImageField(upload_to='profile_images', blank=True, null=True)
    tags = models.ManyToManyField('Tag', blank=True)
    first_login = models.BooleanField(default=True) 
    def __str__(self):
        return self.user.username
    



class Post(models.Model):
    CATEGORY_CHOICES = [
        ('tourist', 'Tourist Spot'),
        ('food', 'Food'),
    ]    
    """A post about tourist spots or food"""
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    title = models.CharField(max_length=200)
    content = models.TextField()
    category = models.CharField(max_length=20, choices=CATEGORY_CHOICES)
    image = models.ImageField(upload_to='posts/', blank=True, null=True)
    latitude = models.DecimalField(max_digits=9, decimal_places=6, default=9.7400)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, default=118.7350)
    estimated_price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    tags = models.ManyToManyField(Tag, blank=True, related_name='posts')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    rating = models.DecimalField(max_digits=3, decimal_places=2, default=0.0)

    # likes = models.ManyToManyField(UserProfile, blank=True, related_name='liked_posts')
    
    def __str__(self):
        return f"{self.title}"
    
    def average_rating(self):
        ratings = self.ratings.all()
        if ratings:
            total_ratings = sum([rating.value for rating in ratings])
            return total_ratings / len(ratings)
        else:
            return 0.0
    class Meta:
        ordering = ['-created_at']

class Rating(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    post = models.ForeignKey(Post, on_delete=models.CASCADE, related_name='ratings')
    value = models.IntegerField(choices=[(i, i) for i in range(1, 6)])
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.post.title} - {self.value}"
    
class Collection(models.Model):
    """User’s personal saved posts list (e.g., My Travel List)"""
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='collections')
    name = models.CharField(max_length=100, default='My Travel List')
    description = models.TextField(blank=True, null=True)
    posts = models.ManyToManyField(Post, blank=True, related_name='collections')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('user', 'name')
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.name} ({self.user.username})"
    

class Review(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    post = models.ForeignKey(Post, on_delete=models.CASCADE, related_name='reviews')
    comment = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    
    @property
    def likes_count(self):
        return self.likes.count()


    
class ReviewImage(models.Model):
    review = models.ForeignKey(Review, on_delete=models.CASCADE, related_name='images')
    image = models.ImageField(upload_to='review_images/')

class ReviewLike(models.Model):
    review = models.ForeignKey(Review, on_delete=models.CASCADE, related_name='likes')
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('review', 'user')  

    def __str__(self):
        return f"{self.user.username} liked review {self.review.id}"