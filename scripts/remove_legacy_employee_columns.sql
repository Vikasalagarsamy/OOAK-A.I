-- Script to remove legacy employee columns (primary_company_id and home_branch_id)
-- Created: 2024-06-24

-- Start transaction
BEGIN;

-- 1. First verify all data has been migrated
DO $$
DECLARE
    unmigrated_count INTEGER;
BEGIN
    -- Check for any employees where new fields are NULL but old fields have data
    SELECT COUNT(*) INTO unmigrated_count
    FROM employees
    WHERE (
        (primary_company_id IS NOT NULL AND company_id IS NULL) OR
        (home_branch_id IS NOT NULL AND branch_id IS NULL)
    );

    IF unmigrated_count > 0 THEN
        RAISE EXCEPTION 'Found % employees with unmigrated data. Migration required before proceeding.', unmigrated_count;
    END IF;
END $$;

-- 2. Create backup of current data
CREATE TABLE IF NOT EXISTS employees_column_backup AS
SELECT 
    id,
    employee_id,
    primary_company_id,
    home_branch_id,
    company_id,
    branch_id,
    created_at,
    updated_at
FROM employees;

-- 3. Verify backup
DO $$
DECLARE
    original_count INTEGER;
    backup_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO original_count FROM employees;
    SELECT COUNT(*) INTO backup_count FROM employees_column_backup;

    IF original_count != backup_count THEN
        RAISE EXCEPTION 'Backup verification failed. Original count: %, Backup count: %', original_count, backup_count;
    END IF;
END $$;

-- 4. Drop the old columns
ALTER TABLE employees
    DROP COLUMN IF EXISTS primary_company_id,
    DROP COLUMN IF EXISTS home_branch_id;

-- 5. Create a verification view to monitor the change
CREATE OR REPLACE VIEW employee_company_assignments_v AS
SELECT 
    e.id,
    e.employee_id,
    e.first_name,
    e.last_name,
    e.company_id,
    c.name as company_name,
    e.branch_id,
    b.name as branch_name,
    e.created_at,
    e.updated_at
FROM employees e
LEFT JOIN companies c ON e.company_id = c.id
LEFT JOIN branches b ON e.branch_id = b.id;

-- 6. Log the change
CREATE TABLE IF NOT EXISTS schema_changes_log (
    id SERIAL PRIMARY KEY,
    change_description TEXT,
    executed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    backup_table_name TEXT
);

INSERT INTO schema_changes_log (change_description, backup_table_name)
VALUES (
    'Removed legacy columns primary_company_id and home_branch_id from employees table',
    'employees_column_backup'
);

-- Commit the transaction
COMMIT;

-- Post-removal verification queries (run these after commit)
/*
-- Verify columns are removed
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'employees' 
  AND column_name IN ('primary_company_id', 'home_branch_id');

-- Verify employee assignments are intact
SELECT COUNT(*) FROM employee_company_assignments_v;

-- Verify backup data
SELECT COUNT(*) FROM employees_column_backup;
*/ 