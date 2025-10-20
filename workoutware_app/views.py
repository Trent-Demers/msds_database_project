from django.shortcuts import render
from django.template import loader
from django.http import HttpResponse
from django.shortcuts import redirect
from django.contrib.auth.decorators import login_required
from django.views.generic import TemplateView
from .models import user_info



# Create your views here.

def home(request):
    if request.user.is_authenticated:
        if request.user.groups.filter(name='User').exists():
            return render(request, 'user_dashboard.html', {})
        # elif request.user.groups.filter(name='Admin').exists():
        #     template = loader.get_template('admin_dashboard/')
        #     return HttpResponse(template.render())
        else:
            users = user_info.objects.all().values()
            print(users)
            return render(request, 'admin_dashboard.html', {})
    else:
        return redirect('accounts/login')