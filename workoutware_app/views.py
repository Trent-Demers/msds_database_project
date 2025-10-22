from django.shortcuts import render
from django.template import loader
from django.http import HttpResponse
from django.shortcuts import redirect
from django.contrib.auth.decorators import login_required
from django.views.generic import TemplateView
from .models import user_info
from .models import exercise



# Create your views here.

def home(request):
    if request.user.is_authenticated:
        if request.user.groups.filter(name='User').exists():
            return render(request, 'user_dashboard.html', {})
        # elif request.user.groups.filter(name='Admin').exists():
        #     template = loader.get_template('admin_dashboard/')
        #     return HttpResponse(template.render())
        else:
            exercises = exercise.objects.all().values()
            return render(request, 'admin_dashboard.html', {'exercises': exercises})
    else:
        return redirect('accounts/login')
    
def add_exercise(request):

    new_exercise = exercise(
        name=request.POST.get('exercise_name'),
        type=request.POST.get('exercise_type'),
        subtype=request.POST.get('exercise_subtype'),
        equipment=request.POST.get('exercise_equipment'),
        difficulty=request.POST.get('exercise_difficulty'),
        description=request.POST.get('exercise_description'),
        demo_link=request.POST.get('exercise_demo'),
    )

    new_exercise.save()

    return redirect('/')