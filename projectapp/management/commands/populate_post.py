from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from django.core.files import File
from django.conf import settings
from projectapp.models import Post, Tag
import random
import os

class Command(BaseCommand):
    help = 'Populate at least 20 posts in Puerto Princesa with existing tags and placeholder images'

    PLACEHOLDER_PATH = os.path.join(settings.BASE_DIR, 'projectapp\static', 'images', 'default.png')  # make sure this file exists

    def handle(self, *args, **kwargs):
        tags = list(Tag.objects.all())
        if not tags:
            self.stdout.write(self.style.ERROR("No tags found. Add tags first."))
            return

        user = User.objects.first()
        if not user:
            self.stdout.write(self.style.ERROR("No user found. Create a user first."))
            return

        locations = ['Beach', 'Park', 'Market', 'Restaurant', 'Cafe', 'Trail', 'River', 'Island', 'Garden', 'Street Food', 'Viewpoint', 'Museum']
        adjectives = ['Beautiful', 'Amazing', 'Delicious', 'Stunning', 'Hidden', 'Popular', 'Scenic']
        foods = ['seafood', 'tamilok', 'local delicacies', 'grilled fish', 'tropical fruits']

        NUM_POSTS = 20

        def random_lat_lng():
            base_lat = 9.7400
            base_lng = 118.7350
            lat = base_lat + random.uniform(-0.02, 0.02)
            lng = base_lng + random.uniform(-0.02, 0.02)
            return round(lat, 6), round(lng, 6)

        for i in range(NUM_POSTS):
            category = random.choice(['tourist', 'food'])
            if category == 'tourist':
                title = f"{random.choice(adjectives)} {random.choice(locations)}"
                content = f"Experience the {random.choice(adjectives).lower()} {random.choice(locations).lower()} in Puerto Princesa."
                estimated_price = random.randint(50, 500)
            else:
                title = f"{random.choice(adjectives)} {random.choice(foods)}"
                content = f"Try the {random.choice(adjectives).lower()} {random.choice(foods)} at local spots in Puerto Princesa."
                estimated_price = random.randint(100, 800)

            lat, lng = random_lat_lng()
            post = Post.objects.create(
                user=user,
                title=title,
                content=content,
                category=category,
                latitude=lat,
                longitude=lng,
                estimated_price=estimated_price
            )

            # Assign random 1–3 tags
            post.tags.set(random.sample(tags, k=random.randint(1, min(3, len(tags)))))

            # Save placeholder image
            with open(self.PLACEHOLDER_PATH, 'rb') as f:
                post.image.save(f'placeholder_{i+1}.jpg', File(f), save=True)

            self.stdout.write(self.style.SUCCESS(f"Created post: {title} | Price: {estimated_price} PHP | Lat/Lng: {lat}, {lng} | Image: placeholder_{i+1}.jpg"))

        self.stdout.write(self.style.SUCCESS(f"Finished populating {NUM_POSTS} posts with placeholder images!"))
