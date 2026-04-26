# Feature        : Role-Based Access Control (RBAC) — Django decorator and mixin
# Language       : Python 3.11
# Framework      : Django 5.0 + Django REST Framework 3.15
# Level          : Intermediate
# OWASP          : A01 — Broken Access Control
# Protects       : Route-level role enforcement for Django views and DRF API views
# Does NOT cover : Object-level permissions, row filtering
# Dependencies   : See requirements.txt in this folder
# Tested on      : Python 3.11.8, Django 5.0.6, DRF 3.15.2
# Last reviewed  : 2024-06-01

# Django handles basic user authentication natively.
# This snippet adds role-based restriction on top of it.
# Roles are stored as Django Groups — each user belongs to one or more groups.

from functools import wraps
from django.contrib.auth.decorators import login_required
from django.core.exceptions import PermissionDenied
from django.http import JsonResponse
from rest_framework.permissions import BasePermission
from rest_framework.views import APIView


# ── FUNCTION-BASED VIEW DECORATOR ─────────────────────────
def require_group(*group_names: str):
    """
    Restricts a Django view to users belonging to at least one of the named groups.
    Users must also be authenticated — combine with @login_required.

    Usage:
        @login_required
        @require_group("admin", "moderator")
        def manage_users(request):
            ...
    """
    def decorator(view_func):
        @wraps(view_func)
        def wrapper(request, *args, **kwargs):
            user_groups = set(request.user.groups.values_list("name", flat=True))
            if not user_groups.intersection(set(group_names)):
                raise PermissionDenied("Insufficient group membership")
            return view_func(request, *args, **kwargs)
        return wrapper
    return decorator


# ── DRF PERMISSION CLASS ───────────────────────────────────
class IsInGroup(BasePermission):
    """
    DRF permission class. Set required_groups on the view class.

    Usage:
        class MyView(APIView):
            permission_classes = [IsAuthenticated, IsInGroup]
            required_groups = ["editor", "admin"]
    """
    def has_permission(self, request, view):
        required = getattr(view, "required_groups", [])
        if not required:
            return True
        user_groups = set(request.user.groups.values_list("name", flat=True))
        return bool(user_groups.intersection(set(required)))


# ── CLASS-BASED VIEW MIXIN ─────────────────────────────────
class GroupRequiredMixin:
    """
    Mixin for Django class-based views. Set required_groups on the view.
    """
    required_groups: list[str] = []

    def dispatch(self, request, *args, **kwargs):
        if not request.user.is_authenticated:
            raise PermissionDenied("Authentication required")
        user_groups = set(request.user.groups.values_list("name", flat=True))
        if not user_groups.intersection(set(self.required_groups)):
            raise PermissionDenied("Insufficient group membership")
        return super().dispatch(request, *args, **kwargs)


# ── EXAMPLE DRF VIEW ──────────────────────────────────────
class AdminUserView(APIView):
    permission_classes = [IsInGroup]
    required_groups = ["admin"]

    def get(self, request):
        return JsonResponse({"message": "Admin-only endpoint"})
