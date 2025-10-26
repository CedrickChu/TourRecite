import os
import random
from django.core.management.base import BaseCommand
from django.conf import settings
from projectapp.models import Post, PostImage
from django.core.files import File

class Command(BaseCommand):
    help = 'Populate all posts with 3-5 random placeholder images'

    def handle(self, *args, **options):
        # Define placeholder image path
        PLACEHOLDER_PATH = os.path.join(settings.BASE_DIR, 'projectapp', 'static', 'images', 'placeholder.png')
        
        # Check if placeholder file exists
        if not os.path.exists(PLACEHOLDER_PATH):
            self.stdout.write(
                self.style.ERROR(f'Placeholder image not found at: {PLACEHOLDER_PATH}')
            )
            self.stdout.write(
                self.style.WARNING('Please make sure the placeholder.png file exists in projectapp/static/images/')
            )
            return

        # Get all posts
        posts = Post.objects.all()
        
        if not posts.exists():
            self.stdout.write(self.style.WARNING('No posts found in the database.'))
            return

        total_images_created = 0
        posts_processed = 0

        for post in posts:
            # Skip if post already has images
            if post.images.exists():
                self.stdout.write(
                    self.style.WARNING(f'Post "{post.title}" already has {post.images.count()} images. Skipping.')
                )
                continue

            # Determine random number of images (3-5)
            num_images = random.randint(3, 5)
            
            self.stdout.write(
                f'Adding {num_images} placeholder images to post: "{post.title}"'
            )

            for i in range(num_images):
                try:
                    # Create PostImage instance
                    with open(PLACEHOLDER_PATH, 'rb') as img_file:
                        post_image = PostImage(post=post)
                        
                        # Generate unique filename for each image
                        filename = f'placeholder_{post.id}_{i+1}.png'
                        post_image.image.save(filename, File(img_file), save=True)
                        
                        total_images_created += 1
                        
                        self.stdout.write(
                            f'  - Added image {i+1}/{num_images}'
                        )
                        
                except Exception as e:
                    self.stdout.write(
                        self.style.ERROR(f'Error adding image {i+1} to post {post.id}: {str(e)}')
                    )

            posts_processed += 1

        self.stdout.write(
            self.style.SUCCESS(
                f'Successfully populated {posts_processed} posts with {total_images_created} placeholder images.'
            )
        )