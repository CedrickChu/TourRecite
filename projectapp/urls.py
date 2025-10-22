from django.urls import path
from django.contrib.auth.views import LoginView
from . import views


urlpatterns = [
    path('', views.login_view, name='login'),
    path('logout/', views.CustomLogoutView.as_view(next_page='/'), name='logout'),
    path('register/', views.register_view, name='register'),
    path('/home', views.index_view, name='index_view'),
    path('post/<int:post_id>/', views.post_detail, name='post_detail'),
    path('get-started', views.get_started, name='get_started'),
    path('get-started/profile', views.create_profile, name='create_profile'),
    path('create_post/', views.create_post, name='create_post'),
    path('post/<int:post_id>/', views.post_detail, name='post_detail'),
    path('users/<str:username>/', views.user_profile, name='user_profile'),
    path('toggle_collection/<int:post_id>/', views.toggle_collection, name='toggle_collection'),
    path('remove_collection/<int:post_id>/', views.remove_from_collection, name='remove_collection'),
    path('post/<int:pk>/add_review/', views.add_review, name='add_review'),
    path('post/<int:post_id>/', views.post_detail, name='post_detail'),
    path('post/<int:post_id>/rate/', views.post_rating, name='post_rating'),





]