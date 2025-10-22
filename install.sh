# PYTHON VERSION: 3.12.1
# PIP VERSION: 25.2
# MySQL VERSION: 8.0

# Download repository from GitHub
git clone https://github.com/Trent-Demers/workoutware
cd workoutware

# Setup MySQL container with Docker
docker pull mysql:8.0
docker run --name workoutware -e MYSQL_ROOT_PASSWORD=Rutgers123 -p 3306:3306 -d mysql:8.0

# Run scripts available in the "sql" folder to set up database
    # Can be done using MySQL Workbench, DBeaver, or through VSCode

# Setup Python virtual environment
python -m venv .venv

    # Windows #
    cd .venv/Scripts
    activate  

    # Mac #
    cd .venv/bin
    activate 

cd ../..

pip install -r requirements.txt

# Link Django to MySQL database
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser 

# Start the server
python manage.py runserver