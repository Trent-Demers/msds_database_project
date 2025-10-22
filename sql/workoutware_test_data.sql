USE workoutware;

INSERT INTO user_info (first_name, last_name, email, password_hash, phone_number, height, user_type, fitness_goal, date_registered, registered) 
    VALUES 
    ('John', 'Doe', 'john@email.com', 'hashed_pw_123', '555-0123', 70.0, 'regular', 'strength', '2025-01-15', 1),
    ('Jane', 'Smith', 'jane@email.com', 'hashed_pw_456', '555-0456', 65.5, 'beginner', 'weight_loss', '2025-02-01', 1),
    ('Mike', 'Johnson', 'mike@email.com', 'hashed_pw_789', '555-0789', 72.0, 'athlete', 'strength', '2025-03-10', 1);

INSERT INTO user_stats_log (user_id, date, weight, waist, body_fat_percentage, notes)
    VALUES
    (1, '2025-10-01', 185.5, 34.0, 18.5, ''),
    (1, '2025-10-08', 184.0, 33.5, 18.0, ''),
    (2, '2025-10-01', 152.0, 28.0, 24.5, ''),
    (2, '2025-10-08', 151.0, 27.5, 24.0, ''),
    (3, '2025-10-01', 195.0, 32.0, 15.0, '');

INSERT INTO exercise (name, type, subtype, equipment, difficulty, description, demo_link)
	VALUES 
    ('Barbell Bench Press', 'strength', 'compound', 'barbell', 3, 'Press bar from chest to full extension', 'https://youtube.com/bench-press'),
    ('Barbell Back Squat', 'strength', 'compound', 'barbell', 4, 'Squat with bar on back', 'https://youtube.com/back-squat'),
    ('Pull-ups', 'strength', 'compound', 'bodyweight', 4, 'Pull chin over bar', 'https://youtube.com/pullups'),
    ('Running', 'cardio', 'steady_state', 'NULL', 2, 'Cardiovascular running exercise', 'https://youtube.com/running'),
    ('Plank', 'flexibility', 'isometric', 'bodyweight', 2, 'Hold straight body position', 'https://youtube.com/plank'),
    ('Deadlift', 'strength', 'compound', 'barbell', 5, 'Lift bar from ground to standing', 'https://youtube.com/deadlift'),
    ('Overhead Press', 'strength', 'compound', 'barbell', 4, 'Press bar overhead', 'https://youtube.com/ohp');
    
INSERT INTO target (target_name, target_group, target_function)
	VALUES
		('Chest', 'Upper Body', 'Push'),
		('Back', 'Upper Body', 'Pull'),
		('Quadriceps', 'Lower Body', 'Legs'),
		('Hamstrings', 'Lower Body', 'Legs'),
		('Core', 'Core', 'Stability'),
		('Biceps', 'Upper Body', 'Pull'),
		('Triceps', 'Upper Body', 'Push'),
		('Shoulders', 'Upper Body', 'Push'),
		('Glutes', 'Lower Body', 'Legs'),
		('Calves', 'Lower Body', 'Legs');
        
INSERT INTO exercise_target_association (exercise_id, target_id, intensity)
	VALUES
	(1, 1, 'primary'),
	(1, 7, 'secondary'),
	(1, 8, 'secondary'),
	(2, 3, 'primary'),
	(2, 4, 'secondary'),
	(2, 9, 'secondary'),
	(3, 2, 'primary'),
	(3, 6, 'secondary'),
	(5, 5, 'primary'),
	(6, 4, 'primary'),
	(6, 2, 'secondary'),
	(7, 8, 'primary'),
	(7, 7, 'secondary');
    
INSERT INTO user_pb (user_id, exercise_id, pr_type, pb_weight, pb_reps, pb_date, previous_pr, notes)
	VALUES 
	(1, 1, 'weight', 225.0, 1, '2025-09-15', 185.0, ''),
	(1, 1, 'weight', 185.0, 8, '2025-09-01', 0.0, ''),
	(2, 3, 'reps', NULL, 15, '2025-10-01', NULL, ''),
	(3, 2, 'weight', 405.0, 1, '2025-08-20', 365.0, ''),
	(3, 6, 'weight', 495.0, 1, '2025-09-10', NULL, '');
    
INSERT INTO workout_sessions (user_id, session_name, session_date, start_time, duration_minutes, bodyweight, completed, is_template)
	VALUES
	(1, 'Push Day', '2025-10-14', '18:00:00', 65, 185.5, 1, 1), 
	(1, 'Pull Day', '2025-10-16', '07:00:00', 55, 185.0, 1, 1), 
	(2, 'Full Body', '2025-10-15', '19:00:00', 45, 152.0, 1, 1),
	(3, 'Leg Day', '2025-10-14', '17:00:00', 75, 195.0, 1, 1);
    
INSERT INTO session_exercises (session_id, exercise_id, exercise_order, target_sets, target_reps, completed)
	VALUES
	(1, 1, 1, 3, 8, 1),
	(1, 7, 2, 3, 12, 1),
	(2, 3, 1, 4, 10, 1),
	(2, 6, 2, 3, 5, 1),
	(3, 2, 1, 4, 10, 1),
	(3, 5, 2, 3, 60, 1),
	(4, 2, 1, 5, 5, 1);

INSERT INTO sets (session_exercise_id, set_number, weight, reps, rpe, completed, is_warmup, completion_time) 
	VALUES
    (1, 1, 185.0, 10, 7, 1, 0, NULL),
    (1, 2, 185.0, 9, 8, 1, 0, NULL),
    (1, 3, 185.0, 8, 9, 1, 0, NULL),
    (2, 1, 95.0, 12, 7, 1, 0, NULL),
    (2, 2, 95.0, 11, 8, 1, 0, NULL),
    (2, 3, 95.0, 10, 9, 1, 0, NULL),
    (3, 1, NULL, 12, 8, 1, 0, NULL),
    (3, 2, NULL, 10, 9, 1, 0, NULL),
    (3, 3, NULL, 8, 9, 1, 0, NULL),
    (3, 4, NULL, 6, 10, 1, 0, NULL),
    (4, 1, 315.0, 5, 8, 1, 0, NULL),
    (4, 2, 315.0, 5, 9, 1, 0, NULL),
    (4, 3, 315.0, 5, 9, 1, 0, NULL),
    (5, 1, 185.0, 10, 7, 1, 0, NULL),
    (5, 2, 185.0, 10, 8, 1, 0, NULL),
    (5, 3, 185.0, 10, 8, 1, 0, NULL),
    (5, 4, 185.0, 10, 9, 1, 0, NULL),
    (7, 1, 365.0, 5, 8, 1, 0, NULL),
    (7, 2, 365.0, 5, 9, 1, 0, NULL),
    (7, 3, 365.0, 5, 9, 1, 0, NULL),
    (7, 4, 365.0, 5, 10, 1, 0, NULL),
    (7, 5, 365.0, 5, 10, 1, 0, NULL);
    
INSERT INTO goals (user_id, goal_type, goal_description, target_value, current_value, unit, exercise_id, start_date, target_date, status)
	VALUES
    (1, 'PR', 'Bench press 225 lbs', 225.0, 185.0, 'lbs', 1, '2025-09-01', '2025-12-31', 'active'),
    (2, 'bodyweight', 'Lose weight to 145 lbs', 145.0, 152.0, 'lbs', NULL, '2025-10-01', '2025-11-30', 'active'),
    (1, 'frequency', 'Workout 30 days straight', 30.0, 18.0, 'days', NULL, '2025-10-01', '2025-11-01', 'active'),
    (3, 'PR', 'Squat 405 lbs', 405.0, 365.0, 'lbs', 2, '2025-08-15', '2025-12-01', 'active'),
    (2, 'PR', 'Do 20 consecutive pull-ups', 20.0, 15.0, 'reps', 3, '2025-09-15', '2026-03-15', 'active');

INSERT INTO progress (user_id, exercise_id, date, period_type, max_weight, avg_weight, total_volume, workout_count)
	VALUES
    (1, 1, '2025-10-07', 'weekly', 185.0, 180.0, 4440.0, 2),
    (1, 1, '2025-10-14', 'weekly', 195.0, 187.5, 4995.0, 2),
    (3, 2, '2025-10-14', 'weekly', 365.0, 365.0, 9125.0, 1),
    (1, 3, '2025-10-16', 'weekly', NULL, NULL, 0.0, 1);
    
INSERT INTO data_validation (user_id, set_id, exercise_id, input_weight, expected_max, flagged_as, user_action, timestamp)
	VALUES
    (1, 15, 2, 275.0, 205.0, 'outlier', 'corrected', '2025-10-14 18:30:00'),
    (2, NULL, 3, 95.5, 100.0, 'normal', 'verified', '2025-10-15 19:15:00');
    
INSERT INTO workout_plan (user_id, plan_description, plan_type, number_of_days)
	VALUES
    (1, 'Push Pull Legs routine for strength', 'PPL', 6),
    (2, 'Full body beginner workout', 'Full Body', 3),
    (3, 'Advanced powerlifting split', 'Upper/Lower', 4);
    
INSERT INTO daily_workout_plan (workout_plan_id, day, wk_day, session_id)
	VALUES
    (1, 1, 'Push', 1),
    (1, 2, 'Pull', 2),
    (1, 3, 'Legs', 4),
    (1, 4, 'Push', 1), 
    (1, 5, 'Pull', 2), 
    (1, 6, 'Legs', 4),  
    (2, 1, 'Full Body', 3),
    (2, 2, 'Rest', NULL),     
    (2, 3, 'Full Body', 3), 
    (2, 4, 'Rest', NULL),
    (2, 5, 'Full Body', 3),  
    (2, 6, 'Rest', NULL),
    (2, 7, 'Rest', NULL),
    (3, 1, 'Upper Body', 1),  
    (3, 2, 'Lower Body', 4),  
    (3, 3, 'Rest', NULL),
    (3, 4, 'Upper Body', 1), 
    (3, 5, 'Lower Body', 4),  
    (3, 6, 'Rest', NULL),
    (3, 7, 'Rest', NULL)