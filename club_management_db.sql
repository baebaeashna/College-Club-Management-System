-- ==========================================
-- 1. PARENT TABLES (Run these first)
-- ==========================================

-- 1. STUDENT TABLE (The Users)
CREATE TABLE STUDENT (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    branch VARCHAR(50),     -- e.g., CSE, ECE
    year INT                -- e.g., 1, 2, 3, 4
);

-- 2. CLUB TABLE (The Main Organization)
CREATE TABLE CLUB (
    club_id INT PRIMARY KEY,
    club_name VARCHAR(100) UNIQUE NOT NULL,
    category VARCHAR(50),       -- e.g., Technical, Cultural
    established_date DATE,
    club_budget DECIMAL(10, 2) DEFAULT 0.00 -- Tracks total money available
);

-- 3. SPONSOR TABLE (The Money Source)
CREATE TABLE SPONSOR (
    sponsor_id INT PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    industry VARCHAR(50),       -- e.g., EdTech, Food & Bev
    contact_phone VARCHAR(15)
);

-- ==========================================
-- 2. CHILD TABLES (Run these second)
-- ==========================================

-- 4. CLUB_TEAMS TABLE (Your "Vision" Feature)
-- Defines that 'ACM' has a 'Coding Wing' and 'Design Wing'
CREATE TABLE CLUB_TEAMS (
    team_id INT PRIMARY KEY,
    club_id INT,
    team_name VARCHAR(50),      -- e.g., "Social Media", "Logistics"
    FOREIGN KEY (club_id) REFERENCES CLUB(club_id) ON DELETE CASCADE
);

-- 5. MEMBERSHIP TABLE (Who is in which Team?)
-- Links Student -> Team
CREATE TABLE MEMBERSHIP (
    membership_id INT PRIMARY KEY,
    student_id INT,
    team_id INT,
    role VARCHAR(50) DEFAULT 'Member', -- Member, Lead, Co-Lead
    join_date DATE,
    status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id),
    FOREIGN KEY (team_id) REFERENCES CLUB_TEAMS(team_id)
);

-- 6. EVENT TABLE (The Activities)
-- Organized by the Club (Note: Linked to Club, not Team, because the whole Club organizes it)
CREATE TABLE EVENT (
    event_id INT PRIMARY KEY,
    club_id INT,
    event_name VARCHAR(100) NOT NULL,
    type VARCHAR(50),           -- Hackathon, Workshop, Talk
    event_date DATE,
    venue VARCHAR(100),
    budget_required DECIMAL(10, 2), -- How much money is needed
    FOREIGN KEY (club_id) REFERENCES CLUB(club_id)
);

-- ==========================================
-- 3. TRANSACTION TABLES (Run these last)
-- ==========================================

-- 7. PARTICIPATION TABLE (Attendance & Winners)
-- Tracks who went to which event
CREATE TABLE PARTICIPATION (
    participation_id INT PRIMARY KEY,
    event_id INT,
    student_id INT,
    attendance_status VARCHAR(20) DEFAULT 'Absent', -- Present/Absent
    position_secured VARCHAR(20) DEFAULT NULL,      -- 1st, 2nd, or NULL
    FOREIGN KEY (event_id) REFERENCES EVENT(event_id),
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id)
);

-- 8. EVENT_SPONSORSHIP TABLE (Money Transaction)
-- Tracks which sponsor gave money for which event
CREATE TABLE EVENT_SPONSORSHIP (
    deal_id INT PRIMARY KEY,
    event_id INT,
    sponsor_id INT,
    amount_contributed DECIMAL(10, 2), -- The cash amount
    FOREIGN KEY (event_id) REFERENCES EVENT(event_id),
    FOREIGN KEY (sponsor_id) REFERENCES SPONSOR(sponsor_id)
);