from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.forms import AuthenticationForm
from .models import User, UserProfile, Post, Tag, ReviewImage
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
  

class MultipleFileInput(forms.ClearableFileInput):
    allow_multiple_selected = True

class MultipleFileField(forms.FileField):
    def __init__(self, *args, **kwargs):
        kwargs.setdefault("widget", MultipleFileInput(attrs={
            "multiple": True,
            "class": "form-control d-none",  
        }))
        super().__init__(*args, **kwargs)

    def clean(self, data, initial=None):
        single_file_clean = super().clean
        if isinstance(data, (list, tuple)):
            return [single_file_clean(d, initial) for d in data]
        return single_file_clean(data, initial)

class ReviewForm(forms.ModelForm):
    images = MultipleFileField(label='Attach images', required=False)

    class Meta:
        model = Review
        fields = ['comment', 'images']
        widgets = {
            'comment': forms.Textarea(attrs={
                'placeholder': 'What are you thinking?',
                'rows': 2,
                'class': 'form-control',
            }),
        }
        
class RatingForm(forms.Form):
    recipe_id = forms.IntegerField()
    rating_value = forms.IntegerField(min_value=1, max_value=5)