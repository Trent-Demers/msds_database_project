from django.db import models

# Create your models here.
class user(models.Model):
    user_id = models.IntegerField()
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