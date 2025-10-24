from django.shortcuts import render, redirect
from django.template import loader
from django.http import HttpResponse
from django.contrib.auth.decorators import login_required
from django.views.generic import TemplateView
from .models import user_info, exercise, workout_sessions, session_exercises, sets, data_validation, progress
from datetime import datetime, date
from decimal import Decimal
from django.db import connection
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth import login


# Create your views here.

@login_required
def home(request):
    """
    Home page - shows different dashboard based on user type
    Superusers see admin dashboard, regular users see user dashboard
    """
    if request.user.is_superuser:
        # Admin Dashboard
        exercises = exercise.objects.all().values()
        return render(request, 'admin_dashboard.html', {'exercises': exercises})
    else:
        # User Dashboard
        return render(request, 'user_dashboard.html', {})
    
@login_required
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

@login_required
def log_workout(request):
    """Display workout logging interface"""
    exercises_list = exercise.objects.all()
    
    try:
        user_record = user_info.objects.get(email=request.user.email)
        user_id = user_record.user_id
    except user_info.DoesNotExist:
        # If no user_info record, create one
        user_record = user_info.objects.create(
            first_name=request.user.first_name or request.user.username,
            last_name=request.user.last_name or '',
            email=request.user.email,
            password_hash='django_auth',
            registered=True,
            date_registered=date.today()
        )
        user_id = user_record.user_id
    
    # user's recent sessions
    recent_sessions = workout_sessions.objects.filter(
        user_id=user_id
    ).order_by('-session_date')[:5]
    
    return render(request, 'log_workout.html', {
        'exercises': exercises_list,
        'recent_sessions': recent_sessions,
        'today': date.today()
    })

@login_required
def create_workout_session(request):
    """Create new workout session"""
    if request.method == 'POST':
        # create user_info record
        try:
            user_record = user_info.objects.get(email=request.user.email)
        except user_info.DoesNotExist:
            user_record = user_info.objects.create(
                first_name=request.user.first_name or request.user.username,
                last_name=request.user.last_name or '',
                email=request.user.email,
                password_hash='django_auth',
                registered=True,
                date_registered=date.today()
            )
        
        # workout session
        new_session = workout_sessions(
            user_id=user_record,
            session_name=request.POST.get('session_name'),
            session_date=request.POST.get('session_date', date.today()),
            start_time=request.POST.get('start_time') or None,
            bodyweight=request.POST.get('bodyweight') or None
        )
        new_session.save()
        
        # redirect to add exercises
        return redirect('add_exercises_to_session', session_id=new_session.session_id)
    
    return redirect('log_workout')

@login_required
def add_exercises_to_session(request, session_id):
    """Add exercises and sets to a workout session"""
    session = workout_sessions.objects.get(session_id=session_id)
    exercises_list = exercise.objects.all()
    
    # exercises in this session
    session_ex = session_exercises.objects.filter(
        session_id=session_id
    ).select_related('exercise_id')
    
    # sets for each exercise
    session_data = []
    for se in session_ex:
        sets_data = sets.objects.filter(session_exercise_id=se.session_exercise_id).order_by('set_number')
        session_data.append({
            'session_exercise': se,
            'sets': sets_data
        })
    
    return render(request, 'add_exercises.html', {
        'session': session,
        'exercises': exercises_list,
        'session_data': session_data
    })

@login_required
def add_exercise_to_session(request, session_id):
    """Add a single exercise to session"""
    if request.method == 'POST':
        exercise_id = request.POST.get('exercise_id')
        target_sets = request.POST.get('target_sets', 3)
        target_reps = request.POST.get('target_reps', 10)
        
        # next exercise order
        max_order = session_exercises.objects.filter(
            session_id=session_id
        ).count()
        
        #  session_exercise
        new_se = session_exercises(
            session_id=workout_sessions.objects.get(session_id=session_id),
            exercise_id=exercise.objects.get(exercise_id=exercise_id),
            exercise_order=max_order + 1,
            target_sets=target_sets,
            target_reps=target_reps
        )
        new_se.save()
        
    return redirect('add_exercises_to_session', session_id=session_id)

@login_required
def log_set(request, session_exercise_id):
    """Log individual sets with SMART VALIDATION"""
    if request.method == 'POST':
        weight_input = request.POST.get('weight', '0')
        weight_input = Decimal(weight_input) if weight_input else Decimal('0')
        reps_input = int(request.POST.get('reps', 0))
        rpe_input = int(request.POST.get('rpe', 5))
        set_number = int(request.POST.get('set_number', 1))
        
        #exercise info
        se = session_exercises.objects.get(session_exercise_id=session_exercise_id)
        ex = se.exercise_id
        
        #user_info
        session = se.session_id
        user_record = session.user_id
        
        validation_result = validate_weight_input(
            user_record.user_id, 
            ex.exercise_id, 
            weight_input
        )
        
        # set
        new_set = sets(
            session_exercise_id=se,
            set_number=set_number,
            weight=weight_input if weight_input > 0 else None,
            reps=reps_input,
            rpe=rpe_input
        )
        new_set.save()
        
        # log validation
        data_validation.objects.create(
            user_id=user_record,
            set_id=new_set,
            exercise_id=ex,
            input_weight=weight_input,
            expected_max=validation_result.get('expected_max'),
            flagged_as=validation_result['flag'],
            timestamp=datetime.now()
        )
        
        # return validation feedback
        return render(request, 'set_logged.html', {
            'validation': validation_result,
            'set': new_set,
            'session_exercise_id': session_exercise_id,
            'session_id': session.session_id
        })
    
    return redirect('log_workout')

def validate_weight_input(user_id, exercise_id, input_weight):
    """
    SMART VALIDATION - Professor's key feedback!
    Checks if weight is realistic based on history
    """
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT MAX(s.weight) as max_weight,
                   AVG(s.weight) as avg_weight
            FROM sets s
            JOIN session_exercises se ON s.session_exercise_id = se.session_exercise_id
            JOIN workout_sessions ws ON se.session_id = ws.session_id
            WHERE ws.user_id = %s 
              AND se.exercise_id = %s
              AND s.weight IS NOT NULL
        """, [user_id, exercise_id])
        
        result = cursor.fetchone()
        
        if result[0] is None:
            return {
                'flag': 'first_time',
                'message': '🌟 First time logging this exercise! Great start!',
                'expected_max': None
            }
        
        max_weight = Decimal(str(result[0]))
        avg_weight = Decimal(str(result[1]))
        
        if input_weight > max_weight * Decimal('1.15'):
            return {
                'flag': 'outlier',
                'message': f'⚠️ {input_weight} lbs is {input_weight - max_weight:.1f} lbs more than your max ({max_weight} lbs). Verify?',
                'expected_max': max_weight
            }
        elif input_weight > max_weight:
            return {
                'flag': 'new_pr',
                'message': f'🎉 NEW PR! {input_weight} lbs is {input_weight - max_weight:.1f} lbs more than your previous max!',
                'expected_max': max_weight
            }
        elif input_weight < avg_weight * Decimal('0.7'):
            return {
                'flag': 'suspicious_low',
                'message': f'⚠️ {input_weight} lbs is unusually low (your average is {avg_weight:.1f} lbs). Correct?',
                'expected_max': max_weight
            }
        else:
            return {
                'flag': 'normal',
                'message': f'✓ Looks good! Within your typical range.',
                'expected_max': max_weight
            }

@login_required
def view_progress(request):
    """Display progress trends"""
    try:
        user_record = user_info.objects.get(email=request.user.email)
        user_id = user_record.user_id
    except user_info.DoesNotExist:
        return redirect('log_workout')
    
    #progress data
    progress_data = progress.objects.filter(
        user_id=user_id
    ).select_related('exercise_id').order_by('-date')[:20]
    
    #recent validations
    recent_validations = data_validation.objects.filter(
        user_id=user_id
    ).select_related('exercise_id').order_by('-timestamp')[:10]
    
    return render(request, 'progress.html', {
        'progress_data': progress_data,
        'validations': recent_validations
    })


def signup(request):
    """User registration view"""
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            # Automatically log them in
            login(request, user)
            # Redirect to home
            return redirect('home')
    else:
        form = UserCreationForm()
    
    return render(request, 'registration/signup.html', {'form': form})