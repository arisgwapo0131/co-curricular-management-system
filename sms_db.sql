-- ============================================================
--  Co-Curricular Student Management System (SMS) Database Export
--  Database Name : `sms_db`
--  Compatibility : MySQL 5.7+ / MariaDB 10.2+ / phpMyAdmin
--  Generated for : Bestlink College of the Philippines Portal
-- ============================================================

CREATE DATABASE IF NOT EXISTS `sms_db`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `sms_db`;

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
    `id`             INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `club_id`        INT UNSIGNED NOT NULL,
    `title`          VARCHAR(200) NOT NULL,
    `description`    TEXT,
    `event_date`     DATETIME NOT NULL,
    `venue`          VARCHAR(150) NOT NULL,
    `status`         ENUM('Upcoming','Approved','Completed','Pending OSA','Pending SSC','Pending Admin','Rejected') NOT NULL DEFAULT 'Pending SSC',
    `event_type`     VARCHAR(50) DEFAULT 'Regular',
    `created_by`     INT UNSIGNED DEFAULT NULL,
    `rejection_note` TEXT DEFAULT NULL,
    `created_at`     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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
-- Table structure for `messages`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
    `id`             INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `channel_id`     VARCHAR(50) NOT NULL DEFAULT 'acads',
    `sender_id`      INT UNSIGNED NOT NULL,
    `sender_name`    VARCHAR(150) NOT NULL,
    `sender_initial` VARCHAR(5) DEFAULT NULL,
    `message`        TEXT NOT NULL,
    `created_at`     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_channel` (`channel_id`),
    KEY `idx_sender` (`sender_id`),
    CONSTRAINT `fk_msg_sender` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
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

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
--  SEED DATA
-- ============================================================

-- 1. System Roles
INSERT INTO `roles` (`id`, `name`, `description`) VALUES
(1, 'admin',        'System Administrator with full institutional clearance and management access.'),
(2, 'ssc',          'Supreme Student Council Executive Officer with governance and audit privileges.'),
(3, 'club_adviser', 'Faculty Club Adviser supervising student organization activities and requisitions.'),
(4, 'student',      'General Student enrolled in academic programs and participating in co-curricular clubs.');

-- 2. Core System & Central Administrative Accounts
INSERT INTO `users` (`id`, `username`, `email`, `first_name`, `last_name`, `password_hash`, `role`, `role_id`) VALUES
(1, 'admin',        'admin@bcp.edu.ph',       'System',  'Admin',    '$2y$10$Y5acmcuUERU.ZW0hCOkqWOocDJXF.HSuluj.tCbvBUsRo1nlRiuDm',   'admin',        1),
(2, 'scc.admin',    'scc.admin@bcp.edu.ph',   'System',  'Admin',    '$2y$10$Y5acmcuUERU.ZW0hCOkqWOocDJXF.HSuluj.tCbvBUsRo1nlRiuDm',   'admin',        1),
(3, 'ssc',          'ssc@bcp.edu.ph',         'SSC',     'Officer',  '$2y$10$CArxnMBAJgvhNWeCjuXepepTriMUum2luTXGHoldxaEax7sGDMmO.',     'ssc',          2),
(4, 'ssc.officer',  'ssc.officer@bcp.edu.ph', 'SSC',     'Officer',  '$2y$10$CArxnMBAJgvhNWeCjuXepepTriMUum2luTXGHoldxaEax7sGDMmO.',     'ssc',          2),
(5, 'osa',          'osa@bcp.edu.ph',         'OSA',     'Director', '$2y$10$CArxnMBAJgvhNWeCjuXepepTriMUum2luTXGHoldxaEax7sGDMmO.',     'ssc',          2),
(6, 'finance',      'finance@bcp.edu.ph',     'Finance', 'Officer',  '$2y$10$Y5acmcuUERU.ZW0hCOkqWOocDJXF.HSuluj.tCbvBUsRo1nlRiuDm',   'admin',        1),
(7, 'adviser',      'adviser@bcp.edu.ph',     'Faculty', 'Adviser',  '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(8, 'student',      'student@bcp.edu.ph',     'Juan',    'Santos',   '$2y$10$4ehWiL.y.P/nYs8.jTHQK..lEbB0UvDr2psBxSKoOQml0hax4pLCS', 'student',      4);

-- 3. Program Student Accounts
INSERT INTO `users` (`id`, `username`, `email`, `first_name`, `last_name`, `password_hash`, `role`, `role_id`) VALUES
(9,  'bsit.student',    'bsit@student.bcp.edu.ph',    'Juan',    'Santos',     '$2y$10$4ehWiL.y.P/nYs8.jTHQK..lEbB0UvDr2psBxSKoOQml0hax4pLCS', 'student', 4),
(10, 'bshm.student',    'bshm@student.bcp.edu.ph',    'Maria',   'Cruz',       '$2y$10$4ehWiL.y.P/nYs8.jTHQK..lEbB0UvDr2psBxSKoOQml0hax4pLCS', 'student', 4),
(11, 'bsais.student',   'bsais@student.bcp.edu.ph',   'Jose',    'Reyes',      '$2y$10$4ehWiL.y.P/nYs8.jTHQK..lEbB0UvDr2psBxSKoOQml0hax4pLCS', 'student', 4),
(12, 'bstm.student',    'bstm@student.bcp.edu.ph',    'Ana',     'Dela Cruz',  '$2y$10$4ehWiL.y.P/nYs8.jTHQK..lEbB0UvDr2psBxSKoOQml0hax4pLCS', 'student', 4),
(13, 'bsoa.student',    'bsoa@student.bcp.edu.ph',    'Carlos',  'Garcia',     '$2y$10$4ehWiL.y.P/nYs8.jTHQK..lEbB0UvDr2psBxSKoOQml0hax4pLCS', 'student', 4),
(14, 'bse.student',     'bse@student.bcp.edu.ph',     'Liza',    'Ramos',      '$2y$10$4ehWiL.y.P/nYs8.jTHQK..lEbB0UvDr2psBxSKoOQml0hax4pLCS', 'student', 4),
(15, 'bsba.student',    'bsba@student.bcp.edu.ph',    'Ramon',   'Villanueva', '$2y$10$4ehWiL.y.P/nYs8.jTHQK..lEbB0UvDr2psBxSKoOQml0hax4pLCS', 'student', 4),
(16, 'bsis.student',    'bsis@student.bcp.edu.ph',    'Patricia','Aquino',     '$2y$10$4ehWiL.y.P/nYs8.jTHQK..lEbB0UvDr2psBxSKoOQml0hax4pLCS', 'student', 4),
(17, 'bscpe.student',   'bscpe@student.bcp.edu.ph',   'Mark',    'Bautista',   '$2y$10$4ehWiL.y.P/nYs8.jTHQK..lEbB0UvDr2psBxSKoOQml0hax4pLCS', 'student', 4),
(18, 'bspsych.student', 'bspsych@student.bcp.edu.ph', 'Jenny',   'Navarro',    '$2y$10$4ehWiL.y.P/nYs8.jTHQK..lEbB0UvDr2psBxSKoOQml0hax4pLCS', 'student', 4),
(19, 'bscrim.student',  'bscrim@student.bcp.edu.ph',  'Rico',    'Fernandez',  '$2y$10$4ehWiL.y.P/nYs8.jTHQK..lEbB0UvDr2psBxSKoOQml0hax4pLCS', 'student', 4),
(20, 'bspe.student',    'bspe@student.bcp.edu.ph',    'Sheila',  'Santos',     '$2y$10$4ehWiL.y.P/nYs8.jTHQK..lEbB0UvDr2psBxSKoOQml0hax4pLCS', 'student', 4),
(21, 'tle.student',     'tle@student.bcp.edu.ph',     'Angelo',  'Torres',     '$2y$10$4ehWiL.y.P/nYs8.jTHQK..lEbB0UvDr2psBxSKoOQml0hax4pLCS', 'student', 4),
(22, 'bseled.student',  'bseled@student.bcp.edu.ph',  'Claire',  'Mendoza',    '$2y$10$4ehWiL.y.P/nYs8.jTHQK..lEbB0UvDr2psBxSKoOQml0hax4pLCS', 'student', 4),
(23, 'bsseed.student',  'bsseed@student.bcp.edu.ph',  'Danilo',  'Pascual',    '$2y$10$4ehWiL.y.P/nYs8.jTHQK..lEbB0UvDr2psBxSKoOQml0hax4pLCS', 'student', 4),
(24, 'bslis.student',   'bslis@student.bcp.edu.ph',   'Rowena',  'Espinosa',   '$2y$10$4ehWiL.y.P/nYs8.jTHQK..lEbB0UvDr2psBxSKoOQml0hax4pLCS', 'student', 4);

-- 4. Faculty Adviser Accounts
INSERT INTO `users` (`id`, `username`, `email`, `first_name`, `last_name`, `password_hash`, `role`, `role_id`) VALUES
(25, 'cssec.adviser',    'cssec@adviser.bcp.edu.ph',    'Alex',    'Reyes',    '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(26, 'acads.adviser',    'acads@adviser.bcp.edu.ph',    'Mark',    'Velo',     '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(27, 'aces.adviser',     'aces@adviser.bcp.edu.ph',     'Elena',   'Ramos',    '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(28, 'aiss.adviser',     'aiss@adviser.bcp.edu.ph',     'Clara',   'Tan',      '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(29, 'bliss.adviser',    'bliss@adviser.bcp.edu.ph',    'Robert',  'Cruz',     '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(30, 'brave.adviser',    'brave@adviser.bcp.edu.ph',    'Diana',   'Gomez',    '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(31, 'cjsu.adviser',     'cjsu@adviser.bcp.edu.ph',     'Jose',    'Mercado',  '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(32, 'eyo.adviser',      'eyo@adviser.bcp.edu.ph',      'Lisa',    'Santos',   '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(33, 'galaw.adviser',    'galaw@adviser.bcp.edu.ph',    'Manuel',  'Cruz',     '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(34, 'gems.adviser',     'gems@adviser.bcp.edu.ph',     'Anna',    'Reyes',    '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(35, 'gold.adviser',     'gold@adviser.bcp.edu.ph',     'Karen',   'Lim',      '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(36, 'jfinex.adviser',   'jfinex@adviser.bcp.edu.ph',   'Manuel',  'Cruz',     '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(37, 'hrs.adviser',      'hrs@adviser.bcp.edu.ph',      'Alex',    'Reyes',    '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(38, 'jma.adviser',      'jma@adviser.bcp.edu.ph',      'Sarah',   'Mercado',  '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(39, 'lakas.adviser',    'lakas@adviser.bcp.edu.ph',    'Clara',   'Tan',      '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(40, 'lapis.adviser',    'lapis@adviser.bcp.edu.ph',    'Diana',   'Gomez',    '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(41, 'libro.adviser',    'libro@adviser.bcp.edu.ph',    'Robert',  'Cruz',     '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(42, 'omega.adviser',    'omega@adviser.bcp.edu.ph',    'Jose',    'Mercado',  '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(43, 'psychsoc.adviser', 'psychsoc@adviser.bcp.edu.ph', 'Lisa',    'Santos',   '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(44, 'rsd.adviser',      'rsd@adviser.bcp.edu.ph',      'Anna',    'Reyes',    '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(45, 'sigma.adviser',    'sigma@adviser.bcp.edu.ph',    'Karen',   'Lim',      '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(46, 'techs.adviser',    'techs@adviser.bcp.edu.ph',    'Alex',    'Reyes',    '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(47, 'tts.adviser',      'tts@adviser.bcp.edu.ph',      'Sarah',   'Mercado',  '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(48, 'wika.adviser',     'wika@adviser.bcp.edu.ph',     'Clara',   'Tan',      '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(49, 'acac.adviser',     'acac@adviser.bcp.edu.ph',     'Sarah',   'Mercado',  '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(50, 'cesc.adviser',     'cesc@adviser.bcp.edu.ph',     'Mark',    'Velo',     '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(51, 'ebcpct.adviser',   'ebcpct@adviser.bcp.edu.ph',   'Mark',    'Velo',     '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(52, 'rcyc.adviser',     'rcyc@adviser.bcp.edu.ph',     'Elena',   'Cruz',     '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(53, 'smc.adviser',      'smc@adviser.bcp.edu.ph',      'Mark',    'Velo',     '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(54, 'allstar.adviser',  'allstar@adviser.bcp.edu.ph',  'Sarah',   'Mercado',  '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(55, 'bforce.adviser',   'bforce@adviser.bcp.edu.ph',   'Sarah',   'Mercado',  '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(56, 'creative.adviser', 'creative@adviser.bcp.edu.ph', 'Sarah',   'Mercado',  '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(57, 'cdc.adviser',      'cdc@adviser.bcp.edu.ph',      'Sarah',   'Mercado',  '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(58, 'dlc.adviser',      'dlc@adviser.bcp.edu.ph',      'Sarah',   'Mercado',  '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(59, 'ikatlong.adviser', 'ikatlong@adviser.bcp.edu.ph', 'Sarah',   'Mercado',  '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(60, 'image.adviser',    'image@adviser.bcp.edu.ph',    'Sarah',   'Mercado',  '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(61, 'sikat.adviser',    'sikat@adviser.bcp.edu.ph',    'Sarah',   'Mercado',  '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(62, 'uv.adviser',       'uv@adviser.bcp.edu.ph',       'Sarah',   'Mercado',  '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(63, 'peer.adviser',     'peer@adviser.bcp.edu.ph',     'Elena',   'Cruz',     '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3),
(64, 'newslink.adviser', 'newslink@adviser.bcp.edu.ph', 'Elena',   'Cruz',     '$2y$10$lJPG2pZxrt0MDUWgbdmXcumikOwJQOb8dFN29hs5f.ydj0nPFTC96', 'club_adviser', 3);

-- 5. Student Details Directory
INSERT INTO `students` (`id`, `user_id`, `student_number`, `first_name`, `last_name`, `birthday`, `course`, `year_level`, `section`, `phone`, `status`) VALUES
(1,  8,  '2024-10001', 'Juan',     'Santos',     '2004-06-20', 'Bachelor of Science in Information Technology', '4th Year', '41018', '09999999999', 'Active'),
(2,  9,  '2024-10001', 'Juan',     'Santos',     '2004-06-20', 'Bachelor of Science in Information Technology', '2nd Year', 'IT-2A', '09999999999', 'Active'),
(3,  10, '2024-10002', 'Maria',    'Cruz',       '2005-03-15', 'Bachelor of Science in Hospitality Management', '1st Year', 'HM-1B', '09111111111', 'Active'),
(4,  11, '2024-10003', 'Jose',     'Reyes',      '2003-09-10', 'Bachelor of Science in Accounting Info Systems', '3rd Year', 'AIS-3A', '09222222222', 'Active'),
(5,  12, '2024-10004', 'Ana',      'Dela Cruz',  '2004-01-25', 'Bachelor of Science in Tourism Management', '2nd Year', 'TM-2C', '09333333333', 'Active'),
(6,  13, '2024-10005', 'Carlos',   'Garcia',     '2005-11-30', 'Bachelor of Science in Office Administration', '1st Year', 'OA-1A', '09444444444', 'Active'),
(7,  14, '2024-10006', 'Liza',     'Ramos',      '2003-07-14', 'Bachelor of Science in Entrepreneurship', '3rd Year', 'ENT-3B', '09555555501', 'Active'),
(8,  15, '2024-10007', 'Ramon',    'Villanueva', '2004-04-22', 'Bachelor of Science in Business Administration', '2nd Year', 'BA-2A', '09555555502', 'Active'),
(9,  16, '2024-10008', 'Patricia', 'Aquino',     '2005-11-05', 'Bachelor of Science in Information Science', '1st Year', 'IS-1A', '09555555503', 'Active'),
(10, 17, '2024-10009', 'Mark',     'Bautista',   '2003-08-30', 'Bachelor of Science in Computer Engineering', '3rd Year', 'CPE-3A', '09555555504', 'Active'),
(11, 18, '2024-10010', 'Jenny',    'Navarro',    '2004-02-18', 'Bachelor of Science in Psychology', '2nd Year', 'PSY-2B', '09555555505', 'Active'),
(12, 19, '2024-10011', 'Rico',     'Fernandez',  '2002-12-09', 'Bachelor of Science in Criminology', '4th Year', 'CRIM-4A', '09555555506', 'Active'),
(13, 20, '2024-10012', 'Sheila',   'Santos',     '2004-05-03', 'Bachelor of Science in Physical Education', '2nd Year', 'PE-2A', '09555555507', 'Active'),
(14, 21, '2024-10013', 'Angelo',   'Torres',     '2005-10-27', 'Bachelor of Tech & Livelihood Education', '1st Year', 'TLE-1B', '09555555508', 'Active'),
(15, 22, '2024-10014', 'Claire',   'Mendoza',    '2003-01-16', 'Bachelor of Elementary Education', '3rd Year', 'ELED-3A', '09555555509', 'Active'),
(16, 23, '2024-10015', 'Danilo',   'Pascual',    '2004-09-08', 'Bachelor of Secondary Education', '2nd Year', 'SEED-2C', '09555555510', 'Active'),
(17, 24, '2024-10016', 'Rowena',   'Espinosa',   '2003-06-21', 'Bachelor of Library & Info Science', '3rd Year', 'LIS-3A', '09555555511', 'Active');

-- 6. Student Organizations & Clubs
INSERT INTO `clubs` (`id`, `code`, `name`, `category`, `description`, `adviser_name`, `status`) VALUES
(1, 'ITS',      'Information Technology Society',              'Academic', 'Official organization for IT students focusing on technical skill-building and innovation.', 'Prof. Alex Reyes', 'Active'),
(2, 'CSSEC',    'Computer Science Student Executive Council',  'Academic', 'Empowering CS students through leadership, programming competitions, and research.', 'Prof. Alex Reyes', 'Active'),
(3, 'ACADS',    'Assoc of Computer Eng Driven Students',       'Academic', 'Academic advancement for Computer Engineering students.', 'Prof. Mark Velo', 'Active'),
(4, 'ACES',     'Assoc of Computer Engineering Students',      'Academic', 'Student council representing all Computer Engineering batches.', 'Prof. Elena Ramos', 'Active'),
(5, 'AISS',     'Accounting Info System Society',              'Academic', 'Professional society for AIS majors promoting financial software expertise.', 'Prof. Clara Tan', 'Active'),
(6, 'BCPVOL',   'BCP Campus Volunteers & Extension',           'Advocacy', 'Community outreach, outreach missions, and student volunteer projects.', 'Dr. Elena Cruz', 'Active'),
(7, 'BCPARTS',  'BCP Cultural Arts & Performing Troupe',       'Cultural', 'Dance, music, theater, and creative performance representation across campus.', 'Prof. Sarah Mercado', 'Active');

-- 7. Club Memberships
INSERT INTO `club_memberships` (`id`, `club_id`, `user_id`, `role`, `status`, `approved_by`) VALUES
(1, 1, 8,  'Member',  'Active', 25),
(2, 2, 8,  'Officer', 'Active', 25),
(3, 1, 9,  'Member',  'Active', 25),
(4, 3, 17, 'Member',  'Active', 26),
(5, 6, 8,  'Member',  'Active', 52);

-- 8. Organization Announcements
INSERT INTO `org_announcements` (`id`, `club_id`, `author_id`, `title`, `category`, `priority`, `content`, `target_group`) VALUES
(1, 1, 25, 'Passing of Mid-Term Activity Clearance & Financial Reports', 'Requirement / Submission', 'Urgent', 'All officer committees and project heads are required to submit their midterm activity accomplishment reports and liquidation documents by August 15, 2026. Non-compliance will delay budget releases.', 'Organization Officers'),
(2, 1, 25, 'Annual Tech Hackathon 2026 Guidelines & Team Registration', 'Event', 'Important', 'Registration for the 24-Hour Hackathon is officially open! Form teams of 3 to 4 members. Pre-event orientation meeting scheduled on Friday at 3:00 PM in Lab 304.', 'All Members'),
(3, 2, 25, 'Executive Board & Faculty Adviser Monthly Assembly', 'Meeting', 'Normal', 'Monthly alignment meeting with club officers regarding mid-year outreach projects and upcoming inter-school competitions. Attendance is mandatory for all executive officers.', 'Executive Board');

-- 9. Events
INSERT INTO `events` (`id`, `club_id`, `title`, `description`, `event_date`, `venue`, `status`, `event_type`, `created_by`) VALUES
(1, 1, 'Annual Tech Symposium 2026',  'A nationwide technology symposium featuring AI, Cloud Computing, and Cybersecurity workshops.', '2026-08-15 09:00:00', 'Main Auditorium',  'Approved', 'Regular', 25),
(2, 2, 'BCP Hackathon & Code Fest',   '24-hour inter-college coding competition with cash prizes and industry mentors.',              '2026-08-22 08:00:00', 'IT Laboratory 3',  'Approved', 'Regular', 25),
(3, 6, 'Community Outreach Drive',    'Barangay computer literacy workshop and donation drive.',                                       '2026-09-05 08:30:00', 'Barangay Hall',    'Pending SSC', 'Regular', 25);

-- 10. Event Registrations
INSERT INTO `event_registrations` (`id`, `event_id`, `user_id`, `status`) VALUES
(1, 1, 8, 'Registered'),
(2, 2, 8, 'Registered'),
(3, 1, 9, 'Attended');

-- 11. Budget Requests
INSERT INTO `budget_requests` (`id`, `club_id`, `title`, `description`, `amount`, `status`, `requested_by`, `notes`) VALUES
(1, 1, 'Tech Symposium Equipment & Badges', 'Funding for keynote speaker honorarium, certificates, and event badges.', 15000.00, 'Pending Finance', 25, 'Endorsed by OSA & SSC.'),
(2, 2, 'Hackathon Refreshments & Prizes',   'Food catering for 100 participants and trophy prizes for winners.',           25000.00, 'Pending SSC',     25, 'Pending initial SSC review.'),
(3, 6, 'Outreach Kits & Logistics',          'Educational supplies and transport for volunteer outreach team.',              8000.00,  'Pending Adviser', 25, 'Submitted by student committee.');

-- 12. Attendance Logs
INSERT INTO `attendance_logs` (`id`, `event_id`, `user_id`, `check_in`, `method`, `logged_by`) VALUES
(1, 1, 8, '2026-08-15 08:55:00', 'QR', 25),
(2, 1, 9, '2026-08-15 09:02:00', 'QR', 25);

-- 13. Achievements & Awards
INSERT INTO `achievements` (`id`, `club_id`, `submitted_by`, `title`, `competition`, `award_date`, `proof_file`, `status`, `verified_by`) VALUES
(1, 1, 8, 'Champion - National Web Development Challenge', 'PH Inter-College WebDev Expo 2025', '2025-11-20', NULL, 'Verified', 3),
(2, 2, 8, '1st Runner-Up - Algorithmic Coding Cup',        'Luzon CS Summit 2025',             '2025-10-14', NULL, 'Verified', 3),
(3, 1, 8, 'Best Innovative App Presentation',              'Youth In Tech Awards 2025',         '2025-08-05', NULL, 'Pending',  NULL);

-- 14. Inter-Club Channel Messages
INSERT INTO `messages` (`id`, `channel_id`, `sender_id`, `sender_name`, `sender_initial`, `message`, `created_at`) VALUES
(1, 'acads', 10, 'Maria Santos', 'M', 'Good morning everyone! Reminder about the upcoming midterm evaluations.', '2026-09-07 09:04:00'),
(2, 'acads', 11, 'James Reyes',  'J', 'Thanks for the heads up! Do we need to submit the activity log before or after?', '2026-09-07 09:07:00'),
(3, 'acads', 8,  'Juan Santos',  'J', 'I believe it\'s before the exam week based on the last announcement.', '2026-09-07 09:10:00'),
(4, 'acads', 10, 'Maria Santos', 'M', 'Correct! Please check the bulletin board for the exact deadline.', '2026-09-07 09:12:00');

-- 15. System Notifications
INSERT INTO `notifications` (`id`, `user_id`, `title`, `message`, `type`, `is_read`) VALUES
(1, 8, 'Welcome to SMS Portal', 'Your student account is active. Explore clubs and register for events!', 'info', 1),
(2, 8, 'Event Registration Confirmed', 'You have successfully registered for Annual Tech Symposium 2026.', 'event', 0),
(3, 25, 'New Budget Request Submitted', 'Budget request #1 for Tech Symposium is now awaiting Finance approval.', 'budget', 0);

-- 16. System Audit Logs
INSERT INTO `audit_logs` (`id`, `user_id`, `action`, `target_table`, `target_id`, `detail`, `ip_address`) VALUES
(1, 1, 'system_setup', 'users', 1, 'Database schema initialized with core tables and seed data.', '127.0.0.1');
