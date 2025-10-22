from django.contrib import admin
from .models import Tag, UserProfile, Post, Rating, Collection

# Admin for Tag
@admin.register(Tag)
class TagAdmin(admin.ModelAdmin):
    list_display = ('name',)
    search_fields = ('name',)
    ordering = ('name',)

# Admin for UserProfile
@admin.register(UserProfile)
class UserProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'email', 'first_name', 'last_name', 'first_login')
    search_fields = ('user__username', 'email', 'first_name', 'last_name')
    list_filter = ('first_login',)
    ordering = ('user',)

# Admin for Post
@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    list_display = ('title', 'user', 'category', 'created_at', 'updated_at', 'rating')
    search_fields = ('title', 'user__username', 'category')
    list_filter = ('category', 'created_at', 'updated_at')
    ordering = ('-created_at',)
    filter_horizontal = ('tags',)  # Allows easy management of tags for a post
    list_editable = ('rating',)  # Makes the rating editable directly from the list view

# Admin for Rating
@admin.register(Rating)
class RatingAdmin(admin.ModelAdmin):
    list_display = ('user', 'post', 'value', 'created_at')
    search_fields = ('user__username', 'post__title')
    list_filter = ('value', 'created_at')
    ordering = ('-created_at',)

# Admin for Collection
@admin.register(Collection)
class CollectionAdmin(admin.ModelAdmin):
    list_display = ('name', 'user', 'created_at')
    search_fields = ('name', 'user__username')
    list_filter = ('created_at',)
    ordering = ('-created_at',)
    filter_horizontal = ('posts',)  # Allows easy management of posts in a collection

