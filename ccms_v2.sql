-- ============================================================
--  Co-Curricular Management System (CCMS v2) Database Export
--  Database Name : `ccms_v2`
--  Compatibility : MySQL 5.7+ / MariaDB 10.2+ / phpMyAdmin
--  Generated for : Bestlink College of the Philippines Portal
-- ============================================================

CREATE DATABASE IF NOT EXISTS `ccms_v2`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `ccms_v2`;

SET FOREIGN_KEY_CHECKS = 0;

-- --------------------------------------------------------
-- Table structure for `roles`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
    `id`          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `name`        VARCHAR(50) NOT NULL UNIQUE,
    `description` VARCHAR(255) DEFAULT NULL,
    `created_at`  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `users`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
    `id`            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `username`      VARCHAR(60)   NOT NULL UNIQUE,
    `email`         VARCHAR(150)  NOT NULL UNIQUE,
    `first_name`    VARCHAR(100)  NOT NULL,
    `last_name`     VARCHAR(100)  NOT NULL,
    `password_hash` VARCHAR(255)  NOT NULL,
    `role`          ENUM('admin','ssc','club_adviser','student') NOT NULL DEFAULT 'student',
    `role_id`       INT UNSIGNED  DEFAULT 4,
    `profile_pic`   VARCHAR(255)  DEFAULT NULL,
    `created_at`    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at`    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY `idx_role` (`role`),
    KEY `idx_username` (`username`),
    CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `students`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `students`;
CREATE TABLE `students` (
    `id`             INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `user_id`        INT UNSIGNED DEFAULT NULL,
    `student_number` VARCHAR(50)  DEFAULT NULL,
    `first_name`     VARCHAR(100) NOT NULL,
    `last_name`      VARCHAR(100) NOT NULL,
    `birthday`       DATE         DEFAULT NULL,
    `course`         VARCHAR(150) NOT NULL,
    `year_level`     VARCHAR(50)  NOT NULL,
    `section`        VARCHAR(50)  NOT NULL,
    `phone`          VARCHAR(20)  DEFAULT NULL,
    `status`         ENUM('Active','Inactive') NOT NULL DEFAULT 'Active',
    `created_at`     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at`     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_student_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `clubs`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `clubs`;
CREATE TABLE `clubs` (
    `id`           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `code`         VARCHAR(20)  NOT NULL UNIQUE,
    `name`         VARCHAR(150) NOT NULL,
    `category`     ENUM('Academic','Cultural','Sports','Advocacy','Religious') NOT NULL DEFAULT 'Academic',
    `description`  TEXT,
    `adviser_name` VARCHAR(150) DEFAULT 'Unassigned',
    `status`       ENUM('Active','Pending Charter','Suspended') NOT NULL DEFAULT 'Active',
    `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `club_memberships`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `club_memberships`;
CREATE TABLE `club_memberships` (
    `id`                 INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `club_id`            INT UNSIGNED NOT NULL,
    `user_id`            INT UNSIGNED NOT NULL,
    `role`               VARCHAR(50) DEFAULT 'Member',
    `status`             ENUM('Active','Pending','Rejected') NOT NULL DEFAULT 'Pending',
    `approved_by`        INT UNSIGNED DEFAULT NULL,
    `letter_intent`      VARCHAR(255) DEFAULT NULL,
    `letter_endorsement` VARCHAR(255) DEFAULT NULL,
    `joined_at`          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `uq_club_user` (`club_id`, `user_id`),
    KEY `idx_user` (`user_id`),
    KEY `idx_club` (`club_id`),
    CONSTRAINT `fk_cm_club` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_cm_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `student_participation`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `student_participation`;
CREATE TABLE `student_participation` (
    `id`                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `user_id`           INT UNSIGNED NOT NULL,
    `event_id`          INT UNSIGNED DEFAULT NULL,
    `activity_name`     VARCHAR(200) NOT NULL,
    `activity_category` VARCHAR(100) NOT NULL,
    `participation_date`DATE NOT NULL,
    `role_taken`        VARCHAR(100) DEFAULT 'Participant',
    `score_rating`      INT DEFAULT 5,
    `created_at`        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_sp_user` (`user_id`),
    KEY `idx_sp_category` (`activity_category`),
    CONSTRAINT `fk_sp_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `org_announcements`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `org_announcements`;
CREATE TABLE `org_announcements` (
    `id`           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `club_id`      INT UNSIGNED NOT NULL,
    `author_id`    INT UNSIGNED NOT NULL,
    `title`        VARCHAR(250) NOT NULL,
    `category`     ENUM('Event','Activity','Requirement / Submission','Meeting','General') NOT NULL DEFAULT 'General',
    `priority`     ENUM('Normal','Important','Urgent') NOT NULL DEFAULT 'Normal',
    `content`      TEXT NOT NULL,
    `target_group` VARCHAR(100) DEFAULT 'All Members',
    `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_club` (`club_id`),
    KEY `idx_author` (`author_id`),
    CONSTRAINT `fk_ann_club` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_ann_author` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `events`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `events`;
CREATE TABLE `events` (
    `id`                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `club_id`           INT UNSIGNED NOT NULL,
    `title`             VARCHAR(200) NOT NULL,
    `description`       TEXT,
    `event_date`        DATETIME NOT NULL,
    `venue`             VARCHAR(150) NOT NULL,
    `category`          VARCHAR(100) DEFAULT 'Academic',
    `status`            ENUM('Upcoming','Approved','Completed','Pending OSA','Pending SSC','Pending Admin','Rejected') NOT NULL DEFAULT 'Pending SSC',
    `event_type`        VARCHAR(50) DEFAULT 'Regular',
    `created_by`        INT UNSIGNED DEFAULT NULL,
    `endorsement_notes` TEXT DEFAULT NULL,
    `rejection_note`    TEXT DEFAULT NULL,
    `created_at`        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_events_club` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `event_registrations`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `event_registrations`;
CREATE TABLE `event_registrations` (
    `id`            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `event_id`      INT UNSIGNED NOT NULL,
    `user_id`       INT UNSIGNED NOT NULL,
    `registered_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `status`        ENUM('Registered','Attended','Cancelled') NOT NULL DEFAULT 'Registered',
    UNIQUE KEY `uq_event_user_reg` (`event_id`, `user_id`),
    KEY `idx_user` (`user_id`),
    KEY `idx_event` (`event_id`),
    CONSTRAINT `fk_er_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_er_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `budget_requests`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `budget_requests`;
CREATE TABLE `budget_requests` (
    `id`           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `club_id`      INT UNSIGNED NOT NULL,
    `title`        VARCHAR(200) NOT NULL,
    `description`  TEXT DEFAULT NULL,
    `amount`       DECIMAL(10,2) NOT NULL,
    `status`       ENUM('Pending Adviser','Pending SSC','Pending OSA','Pending Finance','Pending Admin','Disbursed','Rejected') NOT NULL DEFAULT 'Pending Adviser',
    `requested_by` INT UNSIGNED NOT NULL,
    `notes`        TEXT DEFAULT NULL,
    `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_br_club` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_br_user` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `attendance_logs`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `attendance_logs`;
CREATE TABLE `attendance_logs` (
    `id`        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `event_id`  INT UNSIGNED NOT NULL,
    `user_id`   INT UNSIGNED NOT NULL,
    `check_in`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `method`    ENUM('QR','RFID','Manual') NOT NULL DEFAULT 'QR',
    `logged_by` INT UNSIGNED DEFAULT NULL,
    UNIQUE KEY `uq_event_user` (`event_id`, `user_id`),
    KEY `idx_user` (`user_id`),
    KEY `idx_event` (`event_id`),
    CONSTRAINT `fk_al_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_al_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `achievements`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `achievements`;
CREATE TABLE `achievements` (
    `id`           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `club_id`      INT UNSIGNED NOT NULL,
    `submitted_by` INT UNSIGNED NOT NULL,
    `title`        VARCHAR(250) NOT NULL,
    `competition`  VARCHAR(250) NOT NULL,
    `award_date`   DATE NOT NULL,
    `proof_file`   VARCHAR(300) DEFAULT NULL,
    `status`       ENUM('Pending','Verified','Rejected') NOT NULL DEFAULT 'Pending',
    `verified_by`  INT UNSIGNED DEFAULT NULL,
    `notes`        TEXT DEFAULT NULL,
    `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_ach_club` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_ach_user` FOREIGN KEY (`submitted_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `messages` / `interclubcommunication`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `message_attachments`;
DROP TABLE IF EXISTS `message_recipients`;
DROP TABLE IF EXISTS `messages`;
DROP TABLE IF EXISTS `conversations`;

CREATE TABLE `conversations` (
    `id`              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `subject`         VARCHAR(255) DEFAULT 'General Discussion',
    `organization_id` INT UNSIGNED DEFAULT NULL,
    `created_by`      INT UNSIGNED NOT NULL,
    `is_announcement` TINYINT(1) DEFAULT 0,
    `created_at`      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at`      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY `idx_org` (`organization_id`),
    KEY `idx_creator` (`created_by`),
    CONSTRAINT `fk_conv_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `messages` (
    `id`              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `conversation_id` INT UNSIGNED NOT NULL,
    `sender_id`       INT UNSIGNED NOT NULL,
    `message_content` TEXT NOT NULL,
    `created_at`      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_conv` (`conversation_id`),
    KEY `idx_sender` (`sender_id`),
    CONSTRAINT `fk_msg_conv` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_msg_sender_user` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `message_recipients` (
    `id`           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `message_id`   INT UNSIGNED NOT NULL,
    `user_id`      INT UNSIGNED NOT NULL,
    `is_read`      TINYINT(1) DEFAULT 0,
    `read_at`      DATETIME DEFAULT NULL,
    KEY `idx_msg_user` (`message_id`, `user_id`),
    KEY `idx_read` (`user_id`, `is_read`),
    CONSTRAINT `fk_mr_msg` FOREIGN KEY (`message_id`) REFERENCES `messages` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_mr_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `message_attachments` (
    `id`           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `message_id`   INT UNSIGNED NOT NULL,
    `file_name`    VARCHAR(255) NOT NULL,
    `file_path`    VARCHAR(255) NOT NULL,
    `file_size`    INT UNSIGNED DEFAULT 0,
    `uploaded_at`  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_att_msg` (`message_id`),
    CONSTRAINT `fk_att_msg` FOREIGN KEY (`message_id`) REFERENCES `messages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `reports`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `reports`;
CREATE TABLE `reports` (
    `id`          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `user_id`     INT UNSIGNED NOT NULL,
    `report_type` VARCHAR(100) NOT NULL,
    `summary`     TEXT,
    `created_at`  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_user` (`user_id`),
    CONSTRAINT `fk_rpt_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `notifications`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
    `id`         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `user_id`    INT UNSIGNED NOT NULL,
    `title`      VARCHAR(200) NOT NULL,
    `message`    TEXT NOT NULL,
    `type`       VARCHAR(50) DEFAULT 'info',
    `is_read`    TINYINT(1) NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_user_read` (`user_id`, `is_read`),
    CONSTRAINT `fk_notif_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `audit_logs`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `audit_logs`;
CREATE TABLE `audit_logs` (
    `id`           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `user_id`      INT UNSIGNED NOT NULL,
    `action`       VARCHAR(100) NOT NULL,
    `target_table` VARCHAR(100) DEFAULT NULL,
    `target_id`    INT UNSIGNED DEFAULT NULL,
    `detail`       TEXT DEFAULT NULL,
    `ip_address`   VARCHAR(50) DEFAULT NULL,
    `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_user` (`user_id`),
    KEY `idx_created` (`created_at`),
    CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `ai_recommendation_logs`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `ai_recommendation_logs`;
CREATE TABLE `ai_recommendation_logs` (
    `id`              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `user_id`         INT UNSIGNED NOT NULL,
    `request_type`    ENUM('recommendation','report') NOT NULL DEFAULT 'recommendation',
    `prompt_summary`  TEXT,
    `ai_response`     MEDIUMTEXT,
    `model_used`      VARCHAR(100) DEFAULT 'gemini-2.0-flash',
    `created_at`      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_user` (`user_id`),
    KEY `idx_type` (`request_type`),
    CONSTRAINT `fk_air_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for `club_applications`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `club_applications`;
CREATE TABLE `club_applications` (
    `id`                 INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `club_id`            INT UNSIGNED NOT NULL,
    `user_id`            INT UNSIGNED NOT NULL,
    `first_name`         VARCHAR(100) DEFAULT NULL,
    `last_name`          VARCHAR(100) DEFAULT NULL,
    `student_id_no`      VARCHAR(50)  DEFAULT NULL,
    `course`             VARCHAR(150) DEFAULT NULL,
    `year_level`         VARCHAR(50)  DEFAULT NULL,
    `email`              VARCHAR(150) DEFAULT NULL,
    `phone`              VARCHAR(20)  DEFAULT NULL,
    `sex`                VARCHAR(20)  DEFAULT NULL,
    `dob`                DATE         DEFAULT NULL,
    `address`            TEXT         DEFAULT NULL,
    `motivation`         TEXT         DEFAULT NULL,
    `letter_intent`      VARCHAR(255) DEFAULT NULL,
    `letter_endorsement` VARCHAR(255) DEFAULT NULL,
    `status`             ENUM('Pending','Approved','Rejected') NOT NULL DEFAULT 'Pending',
    `reviewed_by`        INT UNSIGNED DEFAULT NULL,
    `reviewed_at`        DATETIME DEFAULT NULL,
    `created_at`         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_club` (`club_id`),
    KEY `idx_user` (`user_id`),
    CONSTRAINT `fk_ca_club` FOREIGN KEY (`club_id`) REFERENCES `clubs` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_ca_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tables structure for Elections (`elections`, `election_candidates`, `election_votes`)
-- --------------------------------------------------------
DROP TABLE IF EXISTS `election_votes`;
DROP TABLE IF EXISTS `election_candidates`;
DROP TABLE IF EXISTS `elections`;

CREATE TABLE `elections` (
    `id`            INT AUTO_INCREMENT PRIMARY KEY,
    `election_code` VARCHAR(50) UNIQUE NOT NULL,
    `club_id`       INT NOT NULL,
    `title`         VARCHAR(255) NOT NULL,
    `description`   TEXT NULL,
    `closes_at`     DATETIME NULL,
    `status`        ENUM('open', 'closed', 'counting') DEFAULT 'open',
    `positions`     TEXT NULL,
    `created_by`    INT NOT NULL,
    `created_at`    DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `election_candidates` (
    `id`             INT AUTO_INCREMENT PRIMARY KEY,
    `election_id`    INT NOT NULL,
    `candidate_code` VARCHAR(50) NOT NULL,
    `name`           VARCHAR(150) NOT NULL,
    `position`       VARCHAR(100) NOT NULL,
    `party`          VARCHAR(150) NULL,
    `year_level`     VARCHAR(50) NULL,
    `program`        VARCHAR(50) NULL,
    `gwa`            VARCHAR(20) NULL,
    `platform_tag`   TEXT NULL,
    `achievements`   TEXT NULL,
    `votes_count`    INT DEFAULT 0,
    `created_at`     DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `election_votes` (
    `id`          INT AUTO_INCREMENT PRIMARY KEY,
    `election_id` INT NOT NULL,
    `user_id`     INT NOT NULL,
    `votes_json`  TEXT NOT NULL,
    `created_at`  DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `user_election` (`election_id`, `user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tables structure for Volunteer Hour Tracking
-- (`volunteer_roles`, `volunteer_registrations`, `volunteer_attendance`, `volunteer_hours`)
-- --------------------------------------------------------
DROP TABLE IF EXISTS `volunteer_hours`;
DROP TABLE IF EXISTS `volunteer_attendance`;
DROP TABLE IF EXISTS `volunteer_registrations`;
DROP TABLE IF EXISTS `volunteer_roles`;

CREATE TABLE `volunteer_roles` (
    `id`              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `event_id`        INT UNSIGNED NOT NULL,
    `role_name`       VARCHAR(150) NOT NULL,
    `slots`           INT UNSIGNED NOT NULL DEFAULT 5,
    `slots_available` INT UNSIGNED NOT NULL DEFAULT 5,
    `expected_hours`  DECIMAL(4,2) NOT NULL DEFAULT 5.00,
    `description`     TEXT DEFAULT NULL,
    `created_at`      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_vr_event` (`event_id`),
    CONSTRAINT `fk_vr_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `volunteer_registrations` (
    `id`                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `user_id`           INT UNSIGNED NOT NULL,
    `event_id`          INT UNSIGNED NOT NULL,
    `role_id`           INT UNSIGNED NOT NULL,
    `status`            ENUM('Registered', 'Cancelled') NOT NULL DEFAULT 'Registered',
    `registration_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_vreg_user` (`user_id`),
    KEY `idx_vreg_event` (`event_id`),
    KEY `idx_vreg_role` (`role_id`),
    UNIQUE KEY `uq_vreg_user_role` (`user_id`, `role_id`),
    CONSTRAINT `fk_vreg_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_vreg_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_vreg_role` FOREIGN KEY (`role_id`) REFERENCES `volunteer_roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `volunteer_attendance` (
    `id`              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `registration_id` INT UNSIGNED NOT NULL,
    `user_id`         INT UNSIGNED NOT NULL,
    `event_id`        INT UNSIGNED NOT NULL,
    `check_in`        DATETIME DEFAULT NULL,
    `check_out`       DATETIME DEFAULT NULL,
    `calculated_hours`DECIMAL(4,2) DEFAULT 0.00,
    `created_at`      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_vatt_reg` (`registration_id`),
    KEY `idx_vatt_user` (`user_id`),
    CONSTRAINT `fk_vatt_reg` FOREIGN KEY (`registration_id`) REFERENCES `volunteer_registrations` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_vatt_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_vatt_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `volunteer_hours` (
    `id`                  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `user_id`             INT UNSIGNED NOT NULL,
    `event_id`            INT UNSIGNED NOT NULL,
    `registration_id`     INT UNSIGNED NOT NULL,
    `role_id`             INT UNSIGNED NOT NULL,
    `hours`               DECIMAL(4,2) NOT NULL DEFAULT 0.00,
    `verification_status` ENUM('Pending Verification', 'Verified', 'Rejected') NOT NULL DEFAULT 'Pending Verification',
    `verified_by`         INT UNSIGNED DEFAULT NULL,
    `verified_at`         DATETIME DEFAULT NULL,
    `created_at`          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_vh_user` (`user_id`),
    KEY `idx_vh_event` (`event_id`),
    KEY `idx_vh_status` (`verification_status`),
    CONSTRAINT `fk_vh_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_vh_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_vh_reg` FOREIGN KEY (`registration_id`) REFERENCES `volunteer_registrations` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_vh_role` FOREIGN KEY (`role_id`) REFERENCES `volunteer_roles` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_vh_verifier` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
--  SEED DATA FOR CCMS_V2
-- ============================================================

-- 1. System Roles
INSERT INTO `roles` (`id`, `name`, `description`) VALUES
(1, 'admin',        'System Administrator with full institutional clearance and management access.'),
(2, 'ssc',          'Supreme Student Council Executive Officer with governance and audit privileges.'),
(3, 'club_adviser', 'Faculty Club Adviser supervising student organization activities and requisitions.'),
(4, 'student',      'General Student enrolled in academic programs and participating in co-curricular clubs.');

-- 2. Core System Accounts
INSERT INTO `users` (`id`, `username`, `email`, `first_name`, `last_name`, `password_hash`, `role`, `role_id`) VALUES
(1, 'admin',        'admin@bcp.edu.ph',       'System',  'Admin',    '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW',   'admin',        1),
(2, 'scc.admin',    'scc.admin@bcp.edu.ph',   'System',  'Admin',    '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW',   'admin',        1),
(3, 'ssc',          'ssc@bcp.edu.ph',         'SSC',     'Officer',  '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW',     'ssc',          2),
(4, 'ssc.officer',  'ssc.officer@bcp.edu.ph', 'SSC',     'Officer',  '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW',     'ssc',          2),
(5, 'osa',          'osa@bcp.edu.ph',         'OSA',     'Director', '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW',     'ssc',          2),
(6, 'finance',      'finance@bcp.edu.ph',     'Finance', 'Officer',  '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW',   'admin',        1),
(7, 'adviser',      'adviser@bcp.edu.ph',     'Faculty', 'Adviser',  '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'club_adviser', 3),
(8, 'student',      'student@bcp.edu.ph',     'Juan',    'Santos',   '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'student',      4);

-- 3. Program Student Accounts
INSERT INTO `users` (`id`, `username`, `email`, `first_name`, `last_name`, `password_hash`, `role`, `role_id`) VALUES
(9,  'bsit.student',    'bsit@student.bcp.edu.ph',    'Juan',    'Santos',     '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'student', 4),
(10, 'bshm.student',    'bshm@student.bcp.edu.ph',    'Maria',   'Cruz',       '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'student', 4),
(11, 'bsais.student',   'bsais@student.bcp.edu.ph',   'Jose',    'Reyes',      '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'student', 4),
(12, 'bstm.student',    'bstm@student.bcp.edu.ph',    'Ana',     'Dela Cruz',  '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'student', 4),
(13, 'bsoa.student',    'bsoa@student.bcp.edu.ph',    'Carlos',  'Garcia',     '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'student', 4),
(14, 'bse.student',     'bse@student.bcp.edu.ph',     'Liza',    'Ramos',      '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'student', 4),
(15, 'bsba.student',    'bsba@student.bcp.edu.ph',    'Ramon',   'Villanueva', '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'student', 4),
(16, 'bsis.student',    'bsis@student.bcp.edu.ph',    'Patricia','Aquino',     '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'student', 4),
(17, 'bscpe.student',   'bscpe@student.bcp.edu.ph',   'Mark',    'Bautista',   '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'student', 4),
(18, 'bspsych.student', 'bspsych@student.bcp.edu.ph', 'Jenny',   'Navarro',    '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'student', 4),
(19, 'bscrim.student',  'bscrim@student.bcp.edu.ph',  'Rico',    'Fernandez',  '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'student', 4),
(20, 'bspe.student',    'bspe@student.bcp.edu.ph',    'Sheila',  'Santos',     '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'student', 4),
(21, 'tle.student',     'tle@student.bcp.edu.ph',     'Angelo',  'Torres',     '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'student', 4),
(22, 'bseled.student',  'bseled@student.bcp.edu.ph',  'Claire',  'Mendoza',    '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'student', 4),
(23, 'bsseed.student',  'bsseed@student.bcp.edu.ph',  'Danilo',  'Pascual',    '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'student', 4),
(24, 'bslis.student',   'bslis@student.bcp.edu.ph',   'Rowena',  'Espinosa',   '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'student', 4);

-- 4. Faculty Adviser Accounts
INSERT INTO `users` (`id`, `username`, `email`, `first_name`, `last_name`, `password_hash`, `role`, `role_id`) VALUES
(25, 'cssec.adviser',    'cssec@adviser.bcp.edu.ph',    'Alex',    'Reyes',    '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'club_adviser', 3),
(26, 'acads.adviser',    'acads@adviser.bcp.edu.ph',    'Mark',    'Velo',     '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'club_adviser', 3),
(27, 'aces.adviser',     'aces@adviser.bcp.edu.ph',     'Elena',   'Ramos',    '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'club_adviser', 3),
(28, 'aiss.adviser',     'aiss@adviser.bcp.edu.ph',     'Clara',   'Tan',      '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'club_adviser', 3),
(29, 'bliss.adviser',    'bliss@adviser.bcp.edu.ph',    'Robert',  'Cruz',     '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'club_adviser', 3),
(30, 'brave.adviser',    'brave@adviser.bcp.edu.ph',    'Diana',   'Gomez',    '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'club_adviser', 3),
(31, 'cjsu.adviser',     'cjsu@adviser.bcp.edu.ph',     'Jose',    'Mercado',  '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'club_adviser', 3),
(32, 'eyo.adviser',      'eyo@adviser.bcp.edu.ph',      'Lisa',    'Santos',   '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'club_adviser', 3),
(33, 'galaw.adviser',    'galaw@adviser.bcp.edu.ph',    'Manuel',  'Cruz',     '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'club_adviser', 3),
(34, 'gems.adviser',     'gems@adviser.bcp.edu.ph',     'Anna',    'Reyes',    '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'club_adviser', 3),
(35, 'gold.adviser',     'gold@adviser.bcp.edu.ph',     'Karen',   'Lim',      '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'club_adviser', 3),
(36, 'jfinex.adviser',   'jfinex@adviser.bcp.edu.ph',   'Manuel',  'Cruz',     '$2y$10$KJXJ3P3Rp7oQnTz0kvFLGu60.3AioABZxYSRZO0B0TtcQnnhZNFNW', 'club_adviser', 3);

-- 5. Student Details Directory
INSERT INTO `students` (`id`, `user_id`, `student_number`, `first_name`, `last_name`, `birthday`, `course`, `year_level`, `section`, `phone`, `status`) VALUES
(1,  8,  '2024-10001', 'Juan',     'Santos',     '2004-06-20', 'Bachelor of Science in Information Technology', '4th Year', '41018', '09999999999', 'Active'),
(2,  9,  '2024-10001', 'Juan',     'Santos',     '2004-06-20', 'Bachelor of Science in Information Technology', '2nd Year', 'IT-2A', '09999999999', 'Active'),
(3,  10, '2024-10002', 'Maria',    'Cruz',       '2005-03-15', 'Bachelor of Science in Hospitality Management', '1st Year', 'HM-1B', '09111111111', 'Active'),
(4,  11, '2024-10003', 'Jose',     'Reyes',      '2003-09-10', 'Bachelor of Science in Accounting Info Systems', '3rd Year', 'AIS-3A', '09222222222', 'Active');

-- 6. Student Participation History (for AI Recommendation Engine)
INSERT INTO `student_participation` (`id`, `user_id`, `event_id`, `activity_name`, `activity_category`, `participation_date`, `role_taken`, `score_rating`) VALUES
(1, 8,  1, '24-Hour Inter-College Hackathon 2025',     'Hackathon / Coding',       '2025-11-15', 'Lead Programmer', 5),
(2, 8,  2, 'National Web Innovation Challenge',        'Coding Competition',       '2025-10-10', 'Team Captain', 5),
(3, 8,  3, 'Student Council Leadership Boot Camp',    'Leadership Workshop',      '2025-08-20', 'Participant', 4),
(4, 9,  1, 'Algorithmic Problem Solving Sprint',        'Coding Competition',       '2025-09-12', 'Competitor', 5),
(5, 10, NULL, 'Campus Hospitality & Culinary Expo',     'Cultural & Skill Showcase','2025-12-01', 'Exhibitor', 4);

-- 7. Student Organizations & Clubs
INSERT INTO `clubs` (`id`, `code`, `name`, `category`, `description`, `adviser_name`, `status`) VALUES
(1, 'ITS',      'Information Technology Society',              'Academic', 'Official organization for IT students focusing on technical skill-building and innovation.', 'Prof. Alex Reyes', 'Active'),
(2, 'CSSEC',    'Computer Science Student Executive Council',  'Academic', 'Empowering CS students through leadership, programming competitions, and research.', 'Prof. Alex Reyes', 'Active'),
(3, 'ACADS',    'Assoc of Computer Eng Driven Students',       'Academic', 'Academic advancement for Computer Engineering students.', 'Prof. Mark Velo', 'Active'),
(4, 'BCPVOL',   'BCP Campus Volunteers & Extension',           'Advocacy', 'Community outreach, outreach missions, and student volunteer projects.', 'Dr. Elena Cruz', 'Active');

-- 8. Club Memberships
INSERT INTO `club_memberships` (`id`, `club_id`, `user_id`, `role`, `status`, `approved_by`) VALUES
(1, 1, 8, 'Member',  'Active', 25),
(2, 2, 8, 'Officer', 'Active', 25),
(3, 1, 9, 'Member',  'Active', 25);

-- 9. Organization Announcements
INSERT INTO `org_announcements` (`id`, `club_id`, `author_id`, `title`, `category`, `priority`, `content`, `target_group`) VALUES
(1, 1, 25, 'Passing of Mid-Term Activity Clearance & Financial Reports', 'Requirement / Submission', 'Urgent', 'All officer committees and project heads are required to submit their midterm activity accomplishment reports and liquidation documents by August 15, 2026.', 'Organization Officers'),
(2, 1, 25, 'Annual Tech Hackathon 2026 Guidelines & Team Registration', 'Event', 'Important', 'Registration for the 24-Hour Hackathon is officially open! Form teams of 3 to 4 members.', 'All Members');

-- 10. Events
INSERT INTO `events` (`id`, `club_id`, `title`, `description`, `event_date`, `venue`, `category`, `status`, `event_type`, `created_by`) VALUES
(1, 1, 'Annual Tech Symposium 2026',  'A nationwide technology symposium featuring AI, Cloud Computing, and Cybersecurity workshops.', '2026-08-15 09:00:00', 'Main Auditorium', 'Hackathon / Coding', 'Approved', 'Regular', 25),
(2, 2, 'BCP Hackathon & Code Fest',   '24-hour inter-college coding competition with cash prizes and industry mentors.',              '2026-08-22 08:00:00', 'IT Laboratory 3', 'Coding Competition', 'Approved', 'Regular', 25),
(3, 4, 'Community Outreach Drive',    'Barangay computer literacy workshop and donation drive.',                                       '2026-09-05 08:30:00', 'Barangay Hall',   'Leadership Workshop', 'Pending SSC', 'Regular', 25);

-- 11. Event Registrations
INSERT INTO `event_registrations` (`id`, `event_id`, `user_id`, `status`) VALUES
(1, 1, 8, 'Registered'),
(2, 2, 8, 'Registered');

-- 12. Budget Requests
INSERT INTO `budget_requests` (`id`, `club_id`, `title`, `description`, `amount`, `status`, `requested_by`, `notes`) VALUES
(1, 1, 'Tech Symposium Equipment & Badges', 'Funding for keynote speaker honorarium, certificates, and event badges.', 15000.00, 'Pending Finance', 25, 'Endorsed by OSA & SSC.'),
(2, 2, 'Hackathon Refreshments & Prizes',   'Food catering for 100 participants and trophy prizes for winners.',           25000.00, 'Pending SSC',     25, 'Pending initial SSC review.');

-- 13. Attendance Logs
INSERT INTO `attendance_logs` (`id`, `event_id`, `user_id`, `check_in`, `method`, `logged_by`) VALUES
(1, 1, 8, '2026-08-15 08:55:00', 'QR', 25);

-- 14. Achievements & Awards
INSERT INTO `achievements` (`id`, `club_id`, `submitted_by`, `title`, `competition`, `award_date`, `proof_file`, `status`, `verified_by`) VALUES
(1, 1, 8, 'Champion - National Web Development Challenge', 'PH Inter-College WebDev Expo 2025', '2025-11-20', NULL, 'Verified', 3);

-- 15. Inter-Club Conversations & Messages
INSERT INTO `conversations` (`id`, `subject`, `organization_id`, `created_by`, `is_announcement`, `created_at`) VALUES
(1, 'Organization Consultation', 1, 10, 0, '2026-09-07 09:00:00'),
(2, 'Activity Proposal Reminder', 1, 3, 1, '2026-09-07 10:00:00'),
(3, 'Question Regarding Event', 1, 8, 0, '2026-09-07 14:00:00');

INSERT INTO `messages` (`id`, `conversation_id`, `sender_id`, `message_content`, `created_at`) VALUES
(1, 1, 10, 'Good morning SSC, submitting our quarterly activity report for IT Society.', '2026-09-07 09:00:00'),
(2, 1, 3,  'Thank you Adviser Maria! Received.', '2026-09-07 09:15:00'),
(3, 2, 3,  'Reminder: Organization Activity Proposals are due on September 15, 2026.', '2026-09-07 10:00:00'),
(4, 3, 8,  'Good afternoon, SSC. Noted. Thank you!', '2026-09-07 14:00:00'),
(5, 3, 3,  'You\'re welcome.', '2026-09-07 14:05:00');

INSERT INTO `message_recipients` (`id`, `message_id`, `user_id`, `is_read`, `read_at`) VALUES
(1, 1, 3, 1, '2026-09-07 09:14:00'),
(2, 2, 10, 1, '2026-09-07 09:20:00'),
(3, 3, 8, 0, NULL),
(4, 3, 10, 0, NULL),
(5, 4, 3, 1, '2026-09-07 14:04:00'),
(6, 5, 8, 1, '2026-09-07 14:06:00');

-- 16. System Notifications
INSERT INTO `notifications` (`id`, `user_id`, `title`, `message`, `type`, `is_read`) VALUES
(1, 8, 'Welcome to CCMS v2 Portal', 'Explore AI-recommended activities tailored to your participation history!', 'info', 1);

-- 17. System Audit Logs
INSERT INTO `audit_logs` (`id`, `user_id`, `action`, `target_table`, `target_id`, `detail`, `ip_address`) VALUES
(1, 1, 'system_setup', 'users', 1, 'Database schema ccms_v2 initialized with core tables and seed data.', '127.0.0.1');

-- 18. Volunteer Roles & Hours Seed Data
INSERT INTO `volunteer_roles` (`id`, `event_id`, `role_name`, `slots`, `slots_available`, `expected_hours`, `description`) VALUES
(1, 1, 'Registration Assistance', 5, 4, 5.00, 'Assist with participant registration desk, issuing ID tags, and attendance check-ins.'),
(2, 1, 'Ushering & Usher Team', 10, 9, 5.00, 'Guide guests, dignitaries, and students to designated seating areas in the venue.'),
(3, 1, 'Technical & Stage Assistance', 3, 3, 5.00, 'Assist the tech committee with audio-visual equipment, stage setup, and presentation laptops.'),
(4, 1, 'Media & Documentation', 5, 5, 4.00, 'Take event photos, record video highlights, and draft official press releases.'),
(5, 1, 'Logistics & Refreshments', 5, 5, 5.00, 'Help distribute snacks, water, and event kits to participants.');

INSERT INTO `volunteer_registrations` (`id`, `user_id`, `event_id`, `role_id`, `status`, `registration_date`) VALUES
(1, 8, 1, 1, 'Registered', DATE_SUB(NOW(), INTERVAL 2 DAY));

INSERT INTO `volunteer_attendance` (`id`, `registration_id`, `user_id`, `event_id`, `check_in`, `check_out`, `calculated_hours`) VALUES
(1, 1, 8, 1, DATE_SUB(NOW(), INTERVAL 5 HOUR), NOW(), 5.00);

INSERT INTO `volunteer_hours` (`id`, `user_id`, `event_id`, `registration_id`, `role_id`, `hours`, `verification_status`) VALUES
(1, 8, 1, 1, 1, 5.00, 'Pending Verification');
