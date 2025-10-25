from django import template
from django.template.defaultfilters import stringfilter

register = template.Library()

@register.filter
def intdiv(value, divisor):
    try:
        return int(value) // int(divisor)
    except (ValueError, ZeroDivisionError):
        return 0

@register.filter(is_safe=False)
@stringfilter
def endswith(value, suffix):
    return value.endswith(suffix)


@register.filter
def is_media(value, media_type):
    """
    Check if a file URL ends with certain media extensions.
    Usage: {{ file_url|is_media:"video" }}
    media_type can be: "video", "audio", "image"
    """
    value = value.lower()
    if media_type == "video":
        return value.endswith((".mp4", ".webm", ".ogg"))
    elif media_type == "audio":
        return value.endswith((".mp3", ".wav", ".ogg"))
    elif media_type == "image":
        return value.endswith((".jpg", ".jpeg", ".png", ".gif"))
    return False

@register.filter
def is_selected(value, arg):
    """
    Returns 'selected' if value == arg, else returns empty string.
    Usage: {{ value|is_selected:"option_value" }}
    Works for filter_by and sort_by dropdowns.
    """
    return "selected" if str(value) == str(arg) else ""


@property
def likes_count(self):
    return self.likes.count()