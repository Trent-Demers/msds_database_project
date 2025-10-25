from django.db import models

# Create your models here.
class user_info(models.Model):
    user_id = models.IntegerField(primary_key=True)
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    address = models.CharField(max_length=50)
    town = models.CharField(max_length=50)
    state = models.CharField(max_length=50)
    country = models.CharField(max_length=50)
    email = models.CharField(max_length=50)
    phone_number = models.CharField(max_length=50)
    password_hash = models.CharField(max_length=100)
    date_of_birth = models.DateField()
    height = models.DecimalField(max_digits=5, decimal_places=0)
    date_registered = models.DateField()
    date_unregistered = models.DateField()
    registered = models.BooleanField()
    fitness_goal = models.CharField(max_length=50)
    user_type = models.CharField(max_length=50)

    class Meta:
        managed = False
        db_table = 'user_info'

class exercise(models.Model):
    exercise_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)
    type = models.CharField(max_length=50)
    subtype = models.CharField(max_length=50)
    equipment = models.CharField(max_length=50)
    difficulty = models.IntegerField()
    description = models.TextField()
    demo_link = models.CharField(max_length=50)
    

    class Meta:
        managed = False
        db_table = 'exercise'

#new below

class workout_sessions(models.Model):
    session_id = models.AutoField(primary_key=True)
    user_id = models.ForeignKey('user_info', on_delete=models.CASCADE, db_column='user_id')
    session_name = models.CharField(max_length=100, blank=True, null=True)
    session_date = models.DateField()
    start_time = models.TimeField(blank=True, null=True)
    end_time = models.TimeField(blank=True, null=True)
    duration_minutes = models.IntegerField(blank=True, null=True)
    bodyweight = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)
    completed = models.BooleanField(default=True)
    is_template = models.BooleanField(default=False)
    
    class Meta:
        managed = False  # Don't let Django manage this table
        db_table = 'workout_sessions'

class session_exercises(models.Model):
    session_exercise_id = models.AutoField(primary_key=True)
    session_id = models.ForeignKey('workout_sessions', on_delete=models.CASCADE, db_column='session_id')
    exercise_id = models.ForeignKey('exercise', on_delete=models.CASCADE, db_column='exercise_id')
    exercise_order = models.IntegerField()
    target_sets = models.IntegerField(blank=True, null=True)
    target_reps = models.IntegerField(blank=True, null=True)
    completed = models.BooleanField(default=True)
    #notes = models.TextField(blank=True, null=True)
    
    class Meta:
        managed = False
        db_table = 'session_exercises'

class sets(models.Model):
    set_id = models.AutoField(primary_key=True)
    session_exercise_id = models.ForeignKey('session_exercises', on_delete=models.CASCADE, db_column='session_exercise_id')
    set_number = models.IntegerField()
    weight = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    reps = models.IntegerField(blank=True, null=True)
    rpe = models.IntegerField(blank=True, null=True)
    completed = models.BooleanField(default=True)
    is_warmup = models.BooleanField(default=False, blank=True, null=True)
    completion_time = models.DateTimeField(blank=True, null=True)
    notes = models.TextField(blank=True, null=True)
    
    class Meta:
        managed = False
        db_table = 'sets'

class data_validation(models.Model):
    validation_id = models.AutoField(primary_key=True)
    user_id = models.ForeignKey('user_info', on_delete=models.CASCADE, db_column='user_id')
    set_id = models.ForeignKey('sets', on_delete=models.SET_NULL, db_column='set_id', null=True, blank=True)
    exercise_id = models.ForeignKey('exercise', on_delete=models.CASCADE, db_column='exercise_id')
    input_weight = models.DecimalField(max_digits=6, decimal_places=2)
    expected_max = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    flagged_as = models.CharField(max_length=20, blank=True, null=True)
    user_action = models.CharField(max_length=20, blank=True, null=True)
    timestamp = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        managed = False
        db_table = 'data_validation'

class progress(models.Model):
    metric_id = models.AutoField(primary_key=True)
    user_id = models.ForeignKey('user_info', on_delete=models.CASCADE, db_column='user_id')
    exercise_id = models.ForeignKey('exercise', on_delete=models.CASCADE, db_column='exercise_id')
    date = models.DateField()
    period_type = models.CharField(max_length=20)
    max_weight = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    avg_weight = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    total_volume = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    workout_count = models.IntegerField(blank=True, null=True)
    
    class Meta:
        managed = False
        db_table = 'progress'
