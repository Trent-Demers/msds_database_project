from django.urls import path
from . import views
from django.views.generic.base import TemplateView

urlpatterns = [
    path('', views.home, name="home"),
    path('add_exercise/', views.add_exercise, name="add_exercise"),
    
    #new added that log workout and progress tracking url
    path('signup/', views.signup, name="signup"),
    path('log_workout/', views.log_workout, name="log_workout"),
    path('create_session/', views.create_workout_session, name="create_session"),
    path('session/<int:session_id>/add_exercises/', views.add_exercises_to_session, name="add_exercises_to_session"),
    path('session/<int:session_id>/add_exercise/', views.add_exercise_to_session, name="add_exercise_to_session"),
    path('log_set/<int:session_exercise_id>/', views.log_set, name="log_set"),
    path('progress/', views.view_progress, name="progress"),
]