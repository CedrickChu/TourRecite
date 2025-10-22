from django.core.management.base import BaseCommand
from projectapp.models import Tag

class Command(BaseCommand):
    help = 'Populate default tags for tourism and food'

    def handle(self, *args, **kwargs):
        tags = [
            'Beach', 'Mountain', 'Island', 'Lake', 'Waterfall', 'National Park', 'Historic Site', 'Museum', 
            'Temple', 'Church', 'Garden', 'Zoo', 'Adventure Park', 'Street Food', 'Fine Dining', 'Cafe', 
            'Bakery', 'Local Cuisine', 'Seafood', 'Vegetarian', 'Vegan', 'Fast Food', 'Dessert', 'Coffee', 
            'Tea', 'Bar', 'Hiking', 'Camping', 'Snorkeling', 'Diving', 'Surfing', 'Skiing', 'Cycling', 
            'Sightseeing', 'Road Trip', 'Photography', 'Festival', 'Nightlife', 'Shopping', 'Budget Travel', 
            'Luxury Travel', 'Family Friendly', 'Romantic', 'Pet Friendly', 'Hidden Gems', 'Food Tour', 
            'Cultural', 'Adventure', 'Weekend Getaway',
            # Additional food and tourism tags
            'Brunch', 'Wine Tasting', 'Cocktail Bar', 'Ice Cream', 'Smoothies', 'Juice Bar', 'Local Market',
            'Farm to Table', 'Gourmet', 'Chocolate', 'Cheese', 'Brewery', 'Distillery', 'Tea House', 
            'Seafood Market', 'Sushi', 'Barbecue', 'Street Snacks', 'Food Festival', 'Cooking Class', 
            'Wine & Dine', 'Traditional Food', 'Ethnic Cuisine', 'Coffee Tasting', 'Bakery Tour', 
            'Restaurant Hop', 'Sunset View', 'Scenic Hike', 'Boat Tour', 'Wildlife Safari', 'Cultural Show',
            'Music Festival', 'Paragliding', 'Hot Air Balloon', 'Eco Tourism', 'Island Hopping', 
            'Historical Walk', 'Art Gallery', 'Local Handicraft', 'Temple Festival', 'Mountain Climbing',
            'Underground Caves', 'Water Sports', 'Kayaking', 'Fishing', 'Snorkeling Spots', 'Photography Tour'
        ]

        for t in tags:
            Tag.objects.get_or_create(name=t)
