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
    exercise_id = models.IntegerField()
    name = models.CharField(max_length=100)
    type = models.CharField(max_length=50)
    subtype = models.CharField(max_length=50)
    equipment = models.CharField(max_length=50)
    difficulty = models.IntegerField()
    description = models.TextField()
    demo_link = models.CharField(max_length=50)