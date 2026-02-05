--[[
  ═══════════════════════════════════════════════════════════════════════════════════
  🐺 LXR-MDT - DATABASE SCHEMA
  ═══════════════════════════════════════════════════════════════════════════════════
  
  PURPOSE:
  Complete database schema for LXR-MDT system.
  Persistent storage for all medical and law enforcement records.
  
  INSTALLATION:
  Run this SQL file once on your MySQL/MariaDB database.
  All tables are prefixed with 'mdt_' for organization.
  
  © 2026 iBoss21 / The Lux Empire | wolves.land
  ═══════════════════════════════════════════════════════════════════════════════════
]]

-- ════════════════════════════════════════════════════════════════════════════════
-- PLAYERS TABLE (Shared Identity)
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `mdt_players` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `citizenid` VARCHAR(50) NOT NULL,
  `firstname` VARCHAR(50) NOT NULL,
  `lastname` VARCHAR(50) NOT NULL,
  `age` INT(3) DEFAULT 25,
  `dob` DATE DEFAULT NULL,
  `gender` VARCHAR(10) DEFAULT 'male',
  `bloodtype` VARCHAR(5) DEFAULT 'O+',
  `job` VARCHAR(50) DEFAULT 'unemployed',
  `phone` VARCHAR(20) DEFAULT NULL,
  `notes` TEXT DEFAULT NULL,
  `mugshot` TEXT DEFAULT NULL,
  `fingerprint` VARCHAR(100) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `citizenid` (`citizenid`),
  KEY `name_search` (`firstname`, `lastname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- MEDICAL RECORDS
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `mdt_medical_records` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `citizenid` VARCHAR(50) NOT NULL,
  `record_type` VARCHAR(50) NOT NULL COMMENT 'injury, disease, surgery, checkup, etc',
  `diagnosis` VARCHAR(255) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `severity` VARCHAR(20) DEFAULT 'minor' COMMENT 'minor, moderate, severe, critical',
  `body_part` VARCHAR(50) DEFAULT NULL COMMENT 'head, torso, arms, legs, etc',
  `status` VARCHAR(20) DEFAULT 'active' COMMENT 'active, treated, resolved',
  `doctor_name` VARCHAR(100) NOT NULL,
  `doctor_citizenid` VARCHAR(50) NOT NULL,
  `hospital` VARCHAR(100) DEFAULT 'Valentine Hospital',
  `notes` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `doctor` (`doctor_citizenid`),
  KEY `status` (`status`),
  CONSTRAINT `fk_medical_patient` FOREIGN KEY (`citizenid`) REFERENCES `mdt_players` (`citizenid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- TREATMENT HISTORY
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `mdt_treatment_history` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `citizenid` VARCHAR(50) NOT NULL,
  `treatment_type` VARCHAR(50) NOT NULL COMMENT 'bandage, surgery, injection, medication',
  `treatment_name` VARCHAR(100) NOT NULL,
  `body_part` VARCHAR(50) DEFAULT NULL,
  `success` TINYINT(1) DEFAULT 1,
  `doctor_name` VARCHAR(100) NOT NULL,
  `doctor_citizenid` VARCHAR(50) NOT NULL,
  `hospital` VARCHAR(100) DEFAULT 'Valentine Hospital',
  `notes` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `doctor` (`doctor_citizenid`),
  CONSTRAINT `fk_treatment_patient` FOREIGN KEY (`citizenid`) REFERENCES `mdt_players` (`citizenid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- PRESCRIPTIONS
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `mdt_prescriptions` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `citizenid` VARCHAR(50) NOT NULL,
  `medication` VARCHAR(100) NOT NULL,
  `dosage` VARCHAR(50) NOT NULL,
  `frequency` VARCHAR(50) DEFAULT 'As needed',
  `quantity` INT(5) DEFAULT 1,
  `refills` INT(3) DEFAULT 0,
  `expires_at` TIMESTAMP NULL DEFAULT NULL,
  `status` VARCHAR(20) DEFAULT 'active' COMMENT 'active, filled, expired, cancelled',
  `doctor_name` VARCHAR(100) NOT NULL,
  `doctor_citizenid` VARCHAR(50) NOT NULL,
  `notes` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `status` (`status`),
  CONSTRAINT `fk_prescription_patient` FOREIGN KEY (`citizenid`) REFERENCES `mdt_players` (`citizenid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- MEDICAL REPORTS
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `mdt_medical_reports` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `report_type` VARCHAR(50) NOT NULL COMMENT 'gunshot, surgery, autopsy, insanity, general',
  `citizenid` VARCHAR(50) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `content` TEXT NOT NULL,
  `findings` TEXT DEFAULT NULL,
  `recommendations` TEXT DEFAULT NULL,
  `doctor_name` VARCHAR(100) NOT NULL,
  `doctor_citizenid` VARCHAR(50) NOT NULL,
  `shared_with_law` TINYINT(1) DEFAULT 0,
  `attachments` TEXT DEFAULT NULL COMMENT 'JSON array of attachment URLs',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `report_type` (`report_type`),
  CONSTRAINT `fk_report_patient` FOREIGN KEY (`citizenid`) REFERENCES `mdt_players` (`citizenid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- DEATH CERTIFICATES
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `mdt_deaths` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `citizenid` VARCHAR(50) NOT NULL,
  `cause_of_death` VARCHAR(255) NOT NULL,
  `weapon` VARCHAR(100) DEFAULT NULL,
  `killer_name` VARCHAR(100) DEFAULT NULL,
  `killer_citizenid` VARCHAR(50) DEFAULT NULL,
  `location` VARCHAR(255) DEFAULT NULL,
  `doctor_name` VARCHAR(100) DEFAULT NULL,
  `doctor_citizenid` VARCHAR(50) DEFAULT NULL,
  `notes` TEXT DEFAULT NULL,
  `autopsy_performed` TINYINT(1) DEFAULT 0,
  `death_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `killer` (`killer_citizenid`),
  CONSTRAINT `fk_death_victim` FOREIGN KEY (`citizenid`) REFERENCES `mdt_players` (`citizenid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- CRIMINAL RECORDS
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `mdt_criminal_records` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `citizenid` VARCHAR(50) NOT NULL,
  `crime` VARCHAR(255) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `danger_level` INT(1) DEFAULT 1 COMMENT '1-5 scale',
  `gang_affiliation` VARCHAR(100) DEFAULT NULL,
  `notes` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  CONSTRAINT `fk_criminal_record` FOREIGN KEY (`citizenid`) REFERENCES `mdt_players` (`citizenid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- WARRANTS
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `mdt_warrants` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `warrant_type` VARCHAR(50) NOT NULL COMMENT 'arrest, search, execution, bounty',
  `citizenid` VARCHAR(50) NOT NULL,
  `crime` VARCHAR(255) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `fine` INT(10) DEFAULT 0,
  `jail_time` INT(10) DEFAULT 0 COMMENT 'In minutes',
  `status` VARCHAR(20) DEFAULT 'active' COMMENT 'active, executed, cancelled',
  `issuer_name` VARCHAR(100) NOT NULL,
  `issuer_citizenid` VARCHAR(50) NOT NULL,
  `expires_at` TIMESTAMP NULL DEFAULT NULL,
  `executed_by` VARCHAR(100) DEFAULT NULL,
  `executed_at` TIMESTAMP NULL DEFAULT NULL,
  `notes` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `status` (`status`),
  KEY `warrant_type` (`warrant_type`),
  CONSTRAINT `fk_warrant_suspect` FOREIGN KEY (`citizenid`) REFERENCES `mdt_players` (`citizenid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- ARRESTS
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `mdt_arrests` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `citizenid` VARCHAR(50) NOT NULL,
  `crimes` TEXT NOT NULL COMMENT 'JSON array of crimes',
  `description` TEXT DEFAULT NULL,
  `evidence` TEXT DEFAULT NULL COMMENT 'JSON array of evidence',
  `witnesses` TEXT DEFAULT NULL,
  `fine` INT(10) DEFAULT 0,
  `jail_time` INT(10) DEFAULT 0 COMMENT 'In minutes',
  `arresting_officer` VARCHAR(100) NOT NULL,
  `officer_citizenid` VARCHAR(50) NOT NULL,
  `location` VARCHAR(255) DEFAULT NULL,
  `notes` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `officer` (`officer_citizenid`),
  CONSTRAINT `fk_arrest_suspect` FOREIGN KEY (`citizenid`) REFERENCES `mdt_players` (`citizenid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- JAIL HISTORY
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `mdt_jail_history` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `citizenid` VARCHAR(50) NOT NULL,
  `sentence_time` INT(10) NOT NULL COMMENT 'In minutes',
  `time_served` INT(10) DEFAULT 0 COMMENT 'In minutes',
  `reason` TEXT NOT NULL,
  `jailed_by` VARCHAR(100) NOT NULL,
  `officer_citizenid` VARCHAR(50) NOT NULL,
  `status` VARCHAR(20) DEFAULT 'serving' COMMENT 'serving, released, escaped',
  `jail_start` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `jail_end` TIMESTAMP NULL DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `status` (`status`),
  CONSTRAINT `fk_jail_prisoner` FOREIGN KEY (`citizenid`) REFERENCES `mdt_players` (`citizenid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- BOUNTIES
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `mdt_bounties` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `citizenid` VARCHAR(50) NOT NULL,
  `amount` INT(10) NOT NULL,
  `reason` TEXT NOT NULL,
  `status` VARCHAR(20) DEFAULT 'active' COMMENT 'active, claimed, cancelled',
  `issuer_name` VARCHAR(100) NOT NULL,
  `issuer_citizenid` VARCHAR(50) NOT NULL,
  `claimed_by` VARCHAR(100) DEFAULT NULL,
  `claimer_citizenid` VARCHAR(50) DEFAULT NULL,
  `expires_at` TIMESTAMP NULL DEFAULT NULL,
  `claimed_at` TIMESTAMP NULL DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `status` (`status`),
  CONSTRAINT `fk_bounty_target` FOREIGN KEY (`citizenid`) REFERENCES `mdt_players` (`citizenid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- EVIDENCE LOCKER
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `mdt_evidence` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `case_id` INT(11) DEFAULT NULL COMMENT 'References arrest or warrant ID',
  `case_type` VARCHAR(20) DEFAULT 'arrest' COMMENT 'arrest, warrant, investigation',
  `evidence_type` VARCHAR(50) NOT NULL COMMENT 'weapon, item, photo, document',
  `evidence_name` VARCHAR(255) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `collected_by` VARCHAR(100) NOT NULL,
  `officer_citizenid` VARCHAR(50) NOT NULL,
  `location` VARCHAR(255) DEFAULT NULL,
  `stored_location` VARCHAR(100) DEFAULT 'Evidence Locker',
  `attachments` TEXT DEFAULT NULL COMMENT 'JSON array of file URLs',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `case_id` (`case_id`),
  KEY `officer` (`officer_citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- MEDICAL/LAW SUPPLIES
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `mdt_supplies` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `supply_type` VARCHAR(20) NOT NULL COMMENT 'medical, law',
  `item_name` VARCHAR(100) NOT NULL,
  `quantity` INT(10) NOT NULL,
  `location` VARCHAR(100) NOT NULL,
  `last_restock` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `restocked_by` VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `supply_type` (`supply_type`),
  KEY `location` (`location`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- MDT ACTION LOGS
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `mdt_logs` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `log_type` VARCHAR(50) NOT NULL COMMENT 'medical, law, security',
  `action` VARCHAR(100) NOT NULL,
  `actor_name` VARCHAR(100) NOT NULL,
  `actor_citizenid` VARCHAR(50) NOT NULL,
  `target_citizenid` VARCHAR(50) DEFAULT NULL,
  `details` TEXT DEFAULT NULL COMMENT 'JSON object with action details',
  `ip_address` VARCHAR(50) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `log_type` (`log_type`),
  KEY `actor` (`actor_citizenid`),
  KEY `target` (`target_citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- INITIAL DATA (Optional Example Records)
-- ════════════════════════════════════════════════════════════════════════════════

-- You can add example data here if needed for testing

-- ════════════════════════════════════════════════════════════════════════════════
-- END OF SCHEMA
-- ════════════════════════════════════════════════════════════════════════════════
-- 🐺 wolves.land | LXR-MDT Database Schema | iBoss21
-- ════════════════════════════════════════════════════════════════════════════════
