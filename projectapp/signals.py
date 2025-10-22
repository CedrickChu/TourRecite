from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import Collection
from django.contrib.auth.models import User

@receiver(post_save, sender=User)
def create_default_collection(sender, instance, created, **kwargs):
    if created and not instance.is_staff:
        Collection.objects.create(user=instance, name="My Travel List")
