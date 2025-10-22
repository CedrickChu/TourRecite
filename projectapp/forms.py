from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.forms import AuthenticationForm
from .models import User, UserProfile, Post, Tag
from .models import Review

class CustomUserCreationForm(UserCreationForm):
    email = forms.EmailField(required=True, widget=forms.EmailInput(attrs={'placeholder':'Email'}))

    class Meta:
        model = User
        fields = ['email', 'username', 'password1', 'password2']

    def __init__(self, *args, **kwargs):
        super(CustomUserCreationForm, self).__init__(*args, **kwargs)
        self.fields['email'].widget.attrs.update({'class': 'form-control'})
        self.fields['username'].widget.attrs.update({'class': 'form-control'})
        self.fields['password1'].widget.attrs.update({'class': 'form-control'})
        self.fields['password2'].widget.attrs.update({'class': 'form-control'})

class ProfileCreationForm(forms.ModelForm):
    class Meta:
        model = UserProfile
        fields = ('first_name', 'last_name', 'profile_image')

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.fields['first_name'].widget.attrs.update({
            'class': 'form-control',
            'placeholder': 'First Name'
        })
        self.fields['last_name'].widget.attrs.update({
            'class': 'form-control',
            'placeholder': 'Last Name'
        })
        self.fields['profile_image'].widget.attrs.update({
            'class': 'form-control',
            'accept': 'image/*'
        })
class LogoutForm(forms.Form):
    pass

class PostForm(forms.ModelForm):
    class Meta:
        model = Post
        fields = ['title', 'content', 'image', 'tags', 'latitude', 'longitude']
        widgets = {
            'tags': forms.CheckboxSelectMultiple(),
            'content': forms.Textarea(attrs={'rows': 4}),
            'title': forms.TextInput(attrs={'placeholder': 'Title of your post'}),
            'latitude': forms.NumberInput(attrs={'placeholder': 'Latitude', 'step': '0.000001'}),
            'longitude': forms.NumberInput(attrs={'placeholder': 'Longitude', 'step': '0.000001'}),
        }



class TagSelectionForm(forms.Form):
    tags = forms.ModelMultipleChoiceField(
        queryset=Tag.objects.all(),
        widget=forms.CheckboxSelectMultiple,
        required=True
    )

    def clean_tags(self):
        selected = self.cleaned_data.get('tags')
        if len(selected) < 3:
            raise forms.ValidationError("Please choose at least three tags.")
        return selected
    
    

class UserPreferenceForm(forms.ModelForm):
    tags = forms.ModelMultipleChoiceField(
        queryset=Tag.objects.all(),
        widget=forms.CheckboxSelectMultiple,
        required=True
    )

    class Meta:
        model = UserProfile
        fields = ['tags']

    def clean_tags(self):
        tags = self.cleaned_data.get('tags')
        if len(tags) < 3:
            raise forms.ValidationError("Please select at least 3 tags.")
        return tags
    
class ReviewForm(forms.ModelForm):
    class Meta:
        model = Review
        fields = ['comment', 'image']
        widgets = {
            'comment': forms.Textarea(attrs={'class': 'form-control', 'rows': 3}),
            'image': forms.ClearableFileInput(attrs={'class': 'form-control mt-2'}),
        }