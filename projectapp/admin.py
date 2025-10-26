from django.contrib import admin
from .models import Tag, UserProfile, Post, Rating, Collection, Review, ReviewImage, ReviewLike, PostImage

# Admin for Tag
@admin.register(Tag)
class TagAdmin(admin.ModelAdmin):
    list_display = ('name', 'post_count')
    search_fields = ('name',)
    ordering = ('name',)
    
    def post_count(self, obj):
        return obj.posts.count()
    post_count.short_description = 'Posts Count'

# Admin for UserProfile
@admin.register(UserProfile)
class UserProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'email', 'first_name', 'last_name', 'first_login', 'tag_count')
    search_fields = ('user__username', 'email', 'first_name', 'last_name')
    list_filter = ('first_login', 'tags')
    ordering = ('user',)
    filter_horizontal = ('tags',)
    
    def tag_count(self, obj):
        return obj.tags.count()
    tag_count.short_description = 'Tags Count'

class PostImageInline(admin.TabularInline):
    model = PostImage
    extra = 3 
    max_num = 10 
    fields = ['image', 'image_preview']
    readonly_fields = ['image_preview']
    
    def image_preview(self, obj):
        if obj.image:
            return f'<img src="{obj.image.url}" style="width: 100px; height: 100px; object-fit: cover;" />'
        return "No image"
    image_preview.short_description = 'Preview'
    image_preview.allow_tags = True

@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    list_display = ('title', 'user', 'category', 'created_at', 'updated_at', 'rating', 'review_count', 'tag_list', 'total_images_count')
    search_fields = ('title', 'user__username', 'category', 'content')
    list_filter = ('category', 'created_at', 'updated_at', 'tags')
    ordering = ('-created_at',)
    filter_horizontal = ('tags',)
    list_editable = ('rating',)
    readonly_fields = ('created_at', 'updated_at')
    inlines = [PostImageInline]
    
    def get_form(self, request, obj=None, **kwargs):
        form = super().get_form(request, obj, **kwargs)
        form.base_fields['image'].label = 'Thumbnail Image'
        return form
    
    def get_queryset(self, request):
        return super().get_queryset(request).prefetch_related('tags')
    
    def tag_list(self, obj):
        return ", ".join(tag.name for tag in obj.tags.all()[:3])
    tag_list.short_description = 'Tags'
    
    def review_count(self, obj):
        return obj.reviews.count()
    review_count.short_description = 'Reviews'
    
    def total_images_count(self, obj):
        try:
            count = obj.images.count()
            if obj.image:  
                count += 1
            return count
        except AttributeError:
            return 1 if obj.image else 0
    total_images_count.short_description = 'Total Images'

# Admin for Rating
@admin.register(Rating)
class RatingAdmin(admin.ModelAdmin):
    list_display = ('user', 'post', 'value', 'created_at')
    search_fields = ('user__username', 'post__title')
    list_filter = ('value', 'created_at')
    ordering = ('-created_at',)
    readonly_fields = ('created_at',)

# Admin for Collection
@admin.register(Collection)
class CollectionAdmin(admin.ModelAdmin):
    list_display = ('name', 'user', 'post_count', 'created_at')
    search_fields = ('name', 'user__username')
    list_filter = ('created_at',)
    ordering = ('-created_at',)
    filter_horizontal = ('posts',)
    
    def post_count(self, obj):
        return obj.posts.count()
    post_count.short_description = 'Posts Count'

# Inline for Review Images
class ReviewImageInlineAdmin(admin.TabularInline):
    model = ReviewImage
    extra = 1
    readonly_fields = ('image_preview',)
    
    def image_preview(self, obj):
        if obj.image:
            return f'<img src="{obj.image.url}" style="max-height: 50px; max-width: 50px;" />'
        return "No image"
    image_preview.allow_tags = True
    image_preview.short_description = 'Preview'

# Admin for Review - UPDATED WITH INLINE
@admin.register(Review)
class ReviewAdmin(admin.ModelAdmin):
    list_display = ('user', 'post', 'comment_preview', 'likes_count', 'image_count', 'created_at')
    search_fields = ('user__username', 'post__title', 'comment')
    list_filter = ('created_at', 'post__category')
    ordering = ('-created_at',)
    readonly_fields = ('created_at', 'likes_count_display')
    inlines = [ReviewImageInlineAdmin]  # KEEP THIS INLINE
    
    def comment_preview(self, obj):
        return obj.comment[:50] + "..." if len(obj.comment) > 50 else obj.comment
    comment_preview.short_description = 'Comment'
    
    def likes_count(self, obj):
        return obj.likes_count
    likes_count.short_description = 'Likes'
    
    def image_count(self, obj):
        return obj.images.count()
    image_count.short_description = 'Images'
    
    def likes_count_display(self, obj):
        return obj.likes_count
    likes_count_display.short_description = 'Total Likes'

# Standalone Admin for ReviewImage (optional)
@admin.register(ReviewImage)
class ReviewImageAdmin(admin.ModelAdmin):
    list_display = ('review', 'image_preview', 'created_at')
    search_fields = ('review__user__username', 'review__post__title')
    list_filter = ('created_at',)
    ordering = ('-created_at',)
    readonly_fields = ('created_at', 'image_preview_large')
    
    def image_preview(self, obj):
        if obj.image:
            return f'<img src="{obj.image.url}" style="max-height: 50px; max-width: 50px;" />'
        return "No image"
    image_preview.allow_tags = True
    image_preview.short_description = 'Preview'
    
    def image_preview_large(self, obj):
        if obj.image:
            return f'<img src="{obj.image.url}" style="max-height: 300px; max-width: 300px;" />'
        return "No image"
    image_preview_large.allow_tags = True
    image_preview_large.short_description = 'Large Preview'

# Admin for ReviewLike
@admin.register(ReviewLike)
class ReviewLikeAdmin(admin.ModelAdmin):
    list_display = ('user', 'review_preview', 'created_at')
    search_fields = ('user__username', 'review__user__username', 'review__post__title')
    list_filter = ('created_at',)
    ordering = ('-created_at',)
    readonly_fields = ('created_at',)
    
    def review_preview(self, obj):
        comment = obj.review.comment[:30] + "..." if len(obj.review.comment) > 30 else obj.review.comment
        return f"{obj.review.user.username} on '{obj.review.post.title}': {comment}"
    review_preview.short_description = 'Review'

# Standalone Admin for PostImage (optional - for direct management)
@admin.register(PostImage)
class PostImageAdmin(admin.ModelAdmin):
    list_display = ['post', 'image_preview', 'created_at']
    list_filter = ['created_at', 'post']  # Fixed the filter
    readonly_fields = ['image_preview', 'created_at']
    
    def image_preview(self, obj):
        if obj.image:
            return f'<img src="{obj.image.url}" style="width: 50px; height: 50px; object-fit: cover;" />'
        return "No Image"
    image_preview.short_description = 'Preview'
    image_preview.allow_tags = True