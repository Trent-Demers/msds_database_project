## 📊 ER Diagram 

```mermaid
%%{init: {
  'theme': 'base',
  'themeVariables': {
    'primaryColor': '#FFF7E6',      /* light card fill */
    'primaryTextColor': '#111111',  /* dark text */
    'nodeBorder': '#CCCCCC',
    'lineColor': '#ffffff',         /* connector color */
    'edgeColor': '#ffffff'
  },
  'flowchart': { 'curve': 'linear' }
}}%%
erDiagram
  %% --- RELATIONSHIPS ---
  USER ||--o{ USER_STATS_LOG : logs
  USER ||--o{ USER_PB : "has personal bests"
  USER ||--o{ WORKOUT_SESSIONS : performs
  WORKOUT_SESSIONS ||--o{ SESSION_EXERCISES : contains
  SESSION_EXERCISES ||--o{ SETS : consists_of
  EXERCISE ||--o{ SESSION_EXERCISES : used_in
  EXERCISE ||--o{ EXERCISE_TARGET_ASSOCIATION : linked_with
  TARGET ||--o{ EXERCISE_TARGET_ASSOCIATION : "has targets"
  USER ||--o{ GOALS : "sets goals"
  GOALS ||--o{ PROGRESS : "tracked_by"
  USER ||--o{ WORKOUT_PLAN : "has plan"
  WORKOUT_PLAN ||--o{ DAILY_WORKOUT_PLAN : includes
  USER ||--o{ DATA_VALIDATION : validates

  %% --- TABLES (key columns only) ---
  USER { int user_id PK
         string first_name
         string last_name
         string email
         string password_hash }
  USER_STATS_LOG { int log_id PK
                   int user_id FK
                   date date
                   decimal weight
                   decimal body_fat_percentage }
  USER_PB { int pb_id PK
            int user_id FK
            string exercise_name
            decimal max_weight }
  WORKOUT_SESSIONS { int session_id PK
                     int user_id FK
                     date session_date
                     string duration }
  SESSION_EXERCISES { int session_exercise_id PK
                      int session_id FK
                      int exercise_id FK
                      string notes }
  SETS { int set_id PK
         int session_exercise_id FK
         int reps
         decimal weight
         decimal duration }
  EXERCISE { int exercise_id PK
             string name
             string type }
  TARGET { int target_id PK
           string muscle_group }
  EXERCISE_TARGET_ASSOCIATION { int association_id PK
                                int exercise_id FK
                                int target_id FK }
  GOALS { int goal_id PK
          int user_id FK
          string description
          date start_date
          date end_date }
  PROGRESS { int progress_id PK
             int goal_id FK
             decimal completion_percent
             string status }
  WORKOUT_PLAN { int plan_id PK
                 int user_id FK
                 string plan_name
                 date created_at }
  DAILY_WORKOUT_PLAN { int daily_plan_id PK
                       int plan_id FK
                       date day
                       string activity }
  DATA_VALIDATION { int validation_id PK
                    int user_id FK
                    string table_name
                    string result }
