-- Create Subscription Packages table
CREATE TABLE SubscriptionPackages (
    package_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    duration_months INTEGER NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    features JSONB,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Modify Payments table to record subscription transactions
ALTER TABLE Payments
ADD COLUMN subscription_id INTEGER,
ADD COLUMN package_id INTEGER,
ADD COLUMN transaction_type VARCHAR(50) NOT NULL,
ADD COLUMN subscription_start_date TIMESTAMP WITH TIME ZONE,
ADD COLUMN subscription_end_date TIMESTAMP WITH TIME ZONE;

-- Add foreign key constraints
ALTER TABLE Payments
ADD CONSTRAINT fk_payments_subscription_package
FOREIGN KEY (package_id) REFERENCES SubscriptionPackages(package_id);

-- Create Certificates table
CREATE TABLE Certificates (
    certificate_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    issue_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    expiry_date TIMESTAMP WITH TIME ZONE,
    certificate_url VARCHAR(255),
    is_valid BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- Create indexes for improved query performance
CREATE INDEX idx_subscription_packages_is_active ON SubscriptionPackages(is_active);
CREATE INDEX idx_payments_user_id ON Payments(user_id);
CREATE INDEX idx_payments_subscription_id ON Payments(subscription_id);
CREATE INDEX idx_payments_package_id ON Payments(package_id);
CREATE INDEX idx_certificates_user_id ON Certificates(user_id);
CREATE INDEX idx_certificates_course_id ON Certificates(course_id);
CREATE INDEX idx_certificates_issue_date ON Certificates(issue_date);
