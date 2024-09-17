-- Users table
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    user_type VARCHAR(20) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP WITH TIME ZONE
);

-- UserProfiles table
CREATE TABLE UserProfiles (
    profile_id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE NOT NULL,
    is_student BOOLEAN NOT NULL,
    profession VARCHAR(100),
    experience_level VARCHAR(50),
    education_level VARCHAR(50),
    career_goal TEXT,
    learning_objective TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- LearningPaths table
CREATE TABLE LearningPaths (
    path_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Courses table
CREATE TABLE Courses (
    course_id SERIAL PRIMARY KEY,
    path_id INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    subcategory VARCHAR(50),
    description TEXT,
    difficulty_level VARCHAR(20) NOT NULL,
    order_in_path INTEGER NOT NULL,
    FOREIGN KEY (path_id) REFERENCES LearningPaths(path_id) ON DELETE CASCADE
);

-- Modules table
CREATE TABLE Modules (
    module_id SERIAL PRIMARY KEY,
    course_id INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    order_in_course INTEGER NOT NULL,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- Levels table
CREATE TABLE Levels (
    level_id SERIAL PRIMARY KEY,
    module_id INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL,
    order_in_module INTEGER NOT NULL,
    points_value INTEGER NOT NULL,
    FOREIGN KEY (module_id) REFERENCES Modules(module_id) ON DELETE CASCADE
);

-- LearningMaterials table
CREATE TABLE LearningMaterials (
    material_id SERIAL PRIMARY KEY,
    level_id INTEGER NOT NULL,
    content_type VARCHAR(50) NOT NULL,
    content TEXT,
    external_url VARCHAR(255),
    FOREIGN KEY (level_id) REFERENCES Levels(level_id) ON DELETE CASCADE
);

-- Quizzes table
CREATE TABLE Quizzes (
    quiz_id SERIAL PRIMARY KEY,
    level_id INTEGER NOT NULL,
    questions JSONB NOT NULL,
    FOREIGN KEY (level_id) REFERENCES Levels(level_id) ON DELETE CASCADE
);

-- QuizAttempts table
CREATE TABLE QuizAttempts (
    attempt_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    quiz_id INTEGER NOT NULL,
    answers JSONB NOT NULL,
    score INTEGER NOT NULL,
    completed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (quiz_id) REFERENCES Quizzes(quiz_id) ON DELETE CASCADE
);

-- Achievements table
CREATE TABLE Achievements (
    achievement_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    earned_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- PointsLog table
CREATE TABLE PointsLog (
    log_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    points INTEGER NOT NULL,
    action VARCHAR(100) NOT NULL,
    earned_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Leaderboard table
CREATE TABLE Leaderboard (
    leaderboard_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    total_points INTEGER NOT NULL,
    rank INTEGER NOT NULL,
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Payments table
CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    status VARCHAR(20) NOT NULL,
    payment_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- UserCourseProgress table
CREATE TABLE UserCourseProgress (
    progress_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    percentage_complete DECIMAL(5, 2) NOT NULL,
    last_activity TIMESTAMP WITH TIME ZONE,
    start_date TIMESTAMP WITH TIME ZONE,
    completion_date TIMESTAMP WITH TIME ZONE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- Create indexes for frequently queried columns
CREATE INDEX idx_user_email ON Users(email);
CREATE INDEX idx_user_profiles_user_id ON UserProfiles(user_id);
CREATE INDEX idx_courses_path_id ON Courses(path_id);
CREATE INDEX idx_modules_course_id ON Modules(course_id);
CREATE INDEX idx_levels_module_id ON Levels(module_id);
CREATE INDEX idx_quiz_attempts_user_id ON QuizAttempts(user_id);
CREATE INDEX idx_quiz_attempts_quiz_id ON QuizAttempts(quiz_id);
CREATE INDEX idx_achievements_user_id ON Achievements(user_id);
CREATE INDEX idx_points_log_user_id ON PointsLog(user_id);
CREATE INDEX idx_leaderboard_user_id ON Leaderboard(user_id);
CREATE INDEX idx_payments_user_id ON Payments(user_id);
CREATE INDEX idx_user_course_progress_user_id ON UserCourseProgress(user_id);
CREATE INDEX idx_user_course_progress_course_id ON UserCourseProgress(course_id);
