INSERT INTO workoutware.dbo.user_info (first_name, last_name, email, password_hash, phone_number, height, user_type, fitness_goal, date_registered, registered) 
	VALUES ('John', 'Doe', 'john@email.com', 'hashed_pw_123', '555-0123', 70.0, 'regular', 'strength', '2025-01-15', 1);

SELECT * FROM workoutware.dbo.user_info;