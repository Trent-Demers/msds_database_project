CREATE DATABASE workoutware;

CREATE TABLE workoutware.dbo.user_info (
   user_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   first_name VARCHAR(50) NOT NULL,
   last_name VARCHAR(50) NOT NULL,
   address VARCHAR(50),
   town VARCHAR(50),
   state VARCHAR(50),
   country VARCHAR(50),
   email VARCHAR(50) UNIQUE NOT NULL,
   phone_number VARCHAR(50),
   password_hash VARCHAR(100) NOT NULL,
   date_of_birth DATE,
   height DECIMAL(5,2),
   date_registered DATE DEFAULT GETDATE(),
   date_unregistered DATE,
   registered BIT,
   fitness_goal VARCHAR(50),
   user_type VARCHAR(50)
   );
   
CREATE TABLE workoutware.dbo.user_stats_log (
   log_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   user_id INT NOT NULL,
   date DATE NOT NULL,
   weight DECIMAL(5,2) NOT NULL,
   neck DECIMAL(4,2),
   waist DECIMAL(5,2),
   hips DECIMAL(5,2),
   body_fat_percentage DECIMAL(4,2),
   notes TEXT,
   FOREIGN KEY (user_id) REFERENCES workoutware.dbo.user_info(user_id) ON DELETE CASCADE
   );
   
  CREATE TABLE workoutware.dbo.exercise (
   exercise_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   name VARCHAR(100) UNIQUE NOT NULL,
   type VARCHAR(50) NOT NULL,
   subtype VARCHAR(50),
   equipment VARCHAR(50),
   difficulty INT CHECK (difficulty BETWEEN 1 AND 5),
   description TEXT,
   demo_link VARCHAR(100)
   );
   
CREATE TABLE workoutware.dbo.target (
   target_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   target_name VARCHAR(50) UNIQUE NOT NULL,
   target_group VARCHAR(50),
   target_function VARCHAR(100)
   );
   
CREATE TABLE workoutware.dbo.exercise_target_association (
   association_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   exercise_id INT NOT NULL,
   target_id INT NOT NULL,
   intensity VARCHAR(20) NOT NULL,
   FOREIGN KEY (exercise_id) REFERENCES workoutware.dbo.exercise(exercise_id) ON DELETE CASCADE,
   FOREIGN KEY (target_id) REFERENCES workoutware.dbo.target(target_id) ON DELETE CASCADE
   );
   
CREATE TABLE workoutware.dbo.user_pb (
   pr_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   user_id INT NOT NULL,
   exercise_id INT NOT NULL,
   pr_type VARCHAR(20) NOT NULL,
   pb_weight DECIMAL(6,2),
   pb_reps INT,
   pb_time TIME,
   pb_date DATE NOT NULL,
   previous_pr DECIMAL(6,2),
   notes TEXT,
   FOREIGN KEY (user_id) REFERENCES workoutware.dbo.user_info(user_id) ON DELETE CASCADE,
   FOREIGN KEY (exercise_id) REFERENCES workoutware.dbo.exercise(exercise_id) ON DELETE CASCADE
   );

CREATE TABLE workoutware.dbo.workout_sessions (
   session_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   user_id INT NOT NULL,
   session_name VARCHAR(100),
   session_date DATE NOT NULL,
   start_time TIME,
   end_time TIME,
   duration_minutes INT,
   bodyweight DECIMAL(5,2),
   completed BIT DEFAULT 1,
   is_template INT DEFAULT 0,
   FOREIGN KEY (user_id) REFERENCES workoutware.dbo.user_info(user_id) ON DELETE CASCADE
   );

CREATE TABLE workoutware.dbo.session_exercises (
   session_exercise_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   session_id INT NOT NULL,
   exercise_id INT NOT NULL,
   exercise_order INT NOT NULL,
   target_sets INT,
   target_reps INT,
   completed BIT DEFAULT 1,
   FOREIGN KEY (session_id) REFERENCES workoutware.dbo.workout_sessions(session_id) ON DELETE CASCADE,
   FOREIGN KEY (exercise_id) REFERENCES workoutware.dbo.exercise(exercise_id) ON DELETE CASCADE
   );

CREATE TABLE workoutware.dbo.sets (
   set_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   session_exercise_id INT NOT NULL,
   set_number INT NOT NULL,
   weight DECIMAL(6,2),
   reps INT,
   rpe INT CHECK (rpe BETWEEN 1 AND 10),
   completed BIT DEFAULT 1,
   is_warmup BIT, 
   completion_time DATETIME,
   FOREIGN KEY (session_exercise_id) REFERENCES workoutware.dbo.session_exercises(session_exercise_id) ON DELETE CASCADE
   );
   
CREATE TABLE workoutware.dbo.goals (
   goal_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   user_id INT NOT NULL,
   goal_type VARCHAR(100) NOT NULL CHECK(goal_type IN ('PR','bodyweight','frequency','strength','endurance','consistency')),
   goal_description TEXT,
   target_value DECIMAL(8,2) NOT NULL,
   current_value DECIMAL(8,2),
   unit VARCHAR(20) NOT NULL,
   exercise_id INT,
   start_date DATE NOT NULL,
   target_date DATE,
   status VARCHAR(50) DEFAULT 'active',
   completion_date DATE,
   FOREIGN KEY (user_id) REFERENCES workoutware.dbo.user_info(user_id) ON DELETE CASCADE,
   FOREIGN KEY (exercise_id) REFERENCES workoutware.dbo.exercise(exercise_id) ON DELETE SET NULL
   );

CREATE TABLE workoutware.dbo.progress (
   metric_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   user_id INT NOT NULL,
   exercise_id INT NOT NULL,
   date DATE NOT NULL,
   period_type VARCHAR(20) NOT NULL,
   max_weight DECIMAL(6,2),
   avg_weight DECIMAL(6,2),
   total_volume DECIMAL(10,2),
   workout_count INT,
   FOREIGN KEY (user_id) REFERENCES workoutware.dbo.user_info(user_id) ON DELETE CASCADE,
   FOREIGN KEY (exercise_id) REFERENCES workoutware.dbo.exercise(exercise_id) ON DELETE CASCADE
   );

CREATE TABLE workoutware.dbo.data_validation (
   validation_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   user_id INT NOT NULL,
   set_id INT,
   exercise_id INT NOT NULL,
   input_weight DECIMAL(6,2) NOT NULL,
   expected_max DECIMAL(6,2),
   flagged_as VARCHAR(20),
   user_action VARCHAR(20),
   timestamp DATETIME DEFAULT GETDATE(),
   FOREIGN KEY (user_id) REFERENCES workoutware.dbo.user_info(user_id) ON DELETE CASCADE,
   FOREIGN KEY (set_id) REFERENCES workoutware.dbo.sets(set_id) ON DELETE SET NULL,
   FOREIGN KEY (exercise_id) REFERENCES workoutware.dbo.exercise(exercise_id) ON DELETE CASCADE
   );

CREATE TABLE workoutware.dbo.workout_plan (
   plan_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   user_id INT NOT NULL,
   plan_description TEXT,
   plan_type VARCHAR(50),
   number_of_days INT,
   FOREIGN KEY (user_id) REFERENCES workoutware.dbo.user_info(user_id) ON DELETE CASCADE
   );

CREATE TABLE workoutware.dbo.daily_workout_plan (
   daily_plan_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   workout_plan_id INT NOT NULL,
   day INT NOT NULL,
   wk_day VARCHAR(50) CHECK (wk_day IN (
       'Push', 'Pull', 'Legs', 'Upper Body', 'Lower Body', 'Full Body', 
       'Chest', 'Back', 'Shoulders', 'Arms', 'Core', 'Cardio', 'Rest'
   )),
   session_id INT,
   FOREIGN KEY (workout_plan_id) REFERENCES workoutware.dbo.workout_plan(plan_id) ON DELETE CASCADE,
   FOREIGN KEY (session_id) REFERENCES workoutware.dbo.workout_sessions(session_id) ON DELETE SET NULL
   );