-- DROP DATABASE workoutware;
CREATE DATABASE workoutware;
USE workoutware;

CREATE TABLE user_info (
   user_id INT NOT NULL AUTO_INCREMENT,
   first_name VARCHAR(50) NOT NULL,
   last_name VARCHAR(50) NOT NULL,
   address VARCHAR(50),
   town VARCHAR(50),
   state VARCHAR(50),
   country VARCHAR(50),
   email VARCHAR(50) NOT NULL,
   phone_number VARCHAR(50),
   password_hash VARCHAR(100) NOT NULL,
   date_of_birth DATE,
   height DECIMAL(5,2),
   date_registered DATE DEFAULT (CURRENT_DATE),
   date_unregistered DATE,
   registered BOOLEAN,
   fitness_goal VARCHAR(50),
   user_type VARCHAR(50),
   UNIQUE (email),
   UNIQUE (phone_number),
   PRIMARY KEY (user_id)
);
   
CREATE TABLE user_stats_log (
   log_id INT NOT NULL AUTO_INCREMENT,
   user_id INT NOT NULL,
   date DATE NOT NULL,
   weight DECIMAL(5,2) NOT NULL,
   neck DECIMAL(4,2),
   waist DECIMAL(5,2),
   hips DECIMAL(5,2),
   body_fat_percentage DECIMAL(4,2),
   notes TEXT,
   PRIMARY KEY (log_id),
   FOREIGN KEY (user_id) REFERENCES user_info(user_id) ON DELETE CASCADE
);
   
CREATE TABLE exercise (
   exercise_id INT NOT NULL AUTO_INCREMENT,
   name VARCHAR(100) NOT NULL,
   type VARCHAR(50) NOT NULL,
   subtype VARCHAR(50),
   equipment VARCHAR(50),
   difficulty INT,
   description TEXT,
   demo_link VARCHAR(100),
   PRIMARY KEY (exercise_id),
   UNIQUE (name),
   CHECK (difficulty >= 1 AND difficulty <= 5)
);
   
CREATE TABLE target (
   target_id INT NOT NULL AUTO_INCREMENT,
   target_name VARCHAR(50) NOT NULL,
   target_group VARCHAR(50),
   target_function VARCHAR(100),
   PRIMARY KEY (target_id),
   UNIQUE (target_name)
);
   
CREATE TABLE exercise_target_association (
   association_id INT NOT NULL AUTO_INCREMENT,
   exercise_id INT NOT NULL,
   target_id INT NOT NULL,
   intensity VARCHAR(20) NOT NULL,
   PRIMARY KEY (association_id),
   FOREIGN KEY (exercise_id) REFERENCES exercise(exercise_id) ON DELETE CASCADE,
   FOREIGN KEY (target_id) REFERENCES target(target_id) ON DELETE CASCADE
   );

CREATE TABLE workout_sessions (
   session_id INT NOT NULL AUTO_INCREMENT,
   user_id INT NOT NULL,
   session_name VARCHAR(100),
   session_date DATE NOT NULL,
   start_time TIME,
   end_time TIME,
   duration_minutes INT,
   bodyweight DECIMAL(5,2),
   completed BOOLEAN DEFAULT 1,
   is_template BOOLEAN DEFAULT 0,
   PRIMARY KEY (session_id),
   FOREIGN KEY (user_id) REFERENCES user_info(user_id) ON DELETE CASCADE
);

CREATE TABLE session_exercises (
   session_exercise_id INT NOT NULL AUTO_INCREMENT,
   session_id INT NOT NULL,
   exercise_id INT NOT NULL,
   exercise_order INT NOT NULL,
   target_sets INT,
   target_reps INT,
   completed BOOLEAN DEFAULT 1,
   notes TEXT,
   PRIMARY KEY (session_exercise_id),
   FOREIGN KEY (session_id) REFERENCES workout_sessions(session_id) ON DELETE CASCADE,
   FOREIGN KEY (exercise_id) REFERENCES exercise(exercise_id) ON DELETE CASCADE
);

CREATE TABLE sets (
   set_id INT NOT NULL AUTO_INCREMENT,
   session_exercise_id INT NOT NULL,
   set_number INT NOT NULL,
   weight DECIMAL(6,2),
   reps INT,
   rpe INT,
   completion_time DATETIME,
   completed BOOLEAN DEFAULT 1,
   is_warmup BOOLEAN, 
   notes TEXT,
   PRIMARY KEY (set_id),
   FOREIGN KEY (session_exercise_id) REFERENCES session_exercises(session_exercise_id) ON DELETE CASCADE,
   CHECK (rpe >= 1 AND rpe <= 10)
);

CREATE TABLE user_pb (
   pr_id INT NOT NULL AUTO_INCREMENT,
   user_id INT NOT NULL,
   exercise_id INT NOT NULL,
   session_id INT NOT NULL,
   pr_type VARCHAR(20) NOT NULL,
   pb_weight DECIMAL(6,2),
   pb_sets INT, 
   pb_reps INT,
   pb_time TIME,
   pb_distance DECIMAL(6,2),
   pb_date DATE NOT NULL,
   previous_pr DECIMAL(6,2),
   notes TEXT,
   PRIMARY KEY (pr_id),
   FOREIGN KEY (user_id) REFERENCES user_info(user_id) ON DELETE CASCADE,
   FOREIGN KEY (exercise_id) REFERENCES exercise(exercise_id) ON DELETE CASCADE,
   FOREIGN KEY (session_id) REFERENCES workout_sessions(session_id) ON DELETE CASCADE
);

CREATE TABLE goals (
   goal_id INT NOT NULL AUTO_INCREMENT,
   user_id INT NOT NULL,
   goal_type VARCHAR(100) NOT NULL,
   goal_description TEXT,
   target_value DECIMAL(8,2) NOT NULL,
   current_value DECIMAL(8,2),
   unit VARCHAR(20) NOT NULL,
   exercise_id INT,
   start_date DATE NOT NULL,
   status VARCHAR(50) DEFAULT 'active',
   completion_date DATE,
   PRIMARY KEY (goal_id),
   FOREIGN KEY (user_id) REFERENCES user_info(user_id) ON DELETE CASCADE,
   FOREIGN KEY (exercise_id) REFERENCES exercise(exercise_id) ON DELETE SET NULL
   );

CREATE TABLE progress (
   progress_id INT NOT NULL AUTO_INCREMENT,
   user_id INT NOT NULL,
   exercise_id INT NOT NULL,
   date DATE NOT NULL,
   period_type VARCHAR(20) NOT NULL,
   max_weight DECIMAL(6,2),
   avg_weight DECIMAL(6,2),
   total_volume DECIMAL(10,2),
   workout_count INT,
   PRIMARY KEY (progress_id),
   FOREIGN KEY (user_id) REFERENCES user_info(user_id) ON DELETE CASCADE,
   FOREIGN KEY (exercise_id) REFERENCES exercise(exercise_id) ON DELETE CASCADE
   );

CREATE TABLE data_validation (
   validation_id INT NOT NULL AUTO_INCREMENT,
   user_id INT NOT NULL,
   set_id INT,
   exercise_id INT NOT NULL,
   input_weight DECIMAL(6,2) NOT NULL,
   expected_max DECIMAL(6,2),
   flagged_as VARCHAR(20),
   user_action VARCHAR(20),
   timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (validation_id),
   FOREIGN KEY (user_id) REFERENCES user_info(user_id) ON DELETE CASCADE,
   FOREIGN KEY (set_id) REFERENCES sets(set_id) ON DELETE SET NULL,
   FOREIGN KEY (exercise_id) REFERENCES exercise(exercise_id) ON DELETE CASCADE
   );

CREATE TABLE workout_plan (
   plan_id INT NOT NULL AUTO_INCREMENT,
   user_id INT NOT NULL,
   plan_description TEXT,
   plan_type VARCHAR(50),
   number_of_days INT,
   PRIMARY KEY (plan_id),
   FOREIGN KEY (user_id) REFERENCES user_info(user_id) ON DELETE CASCADE
);

CREATE TABLE daily_workout_plan (
   daily_plan_id INT NOT NULL AUTO_INCREMENT,
   workout_plan_id INT NOT NULL,
   day INT NOT NULL,
   wk_day VARCHAR(50),
   session_id INT,
   PRIMARY KEY (daily_plan_id),
   FOREIGN KEY (workout_plan_id) REFERENCES workout_plan(plan_id) ON DELETE CASCADE,
   FOREIGN KEY (session_id) REFERENCES workout_sessions(session_id) ON DELETE SET NULL
);



