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