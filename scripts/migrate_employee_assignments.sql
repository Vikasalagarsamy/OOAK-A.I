-- Create employee_assignments table
CREATE TABLE IF NOT EXISTS employee_assignments (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(id),
    company_id INTEGER REFERENCES companies(id),
    branch_id INTEGER REFERENCES branches(id),
    department_id INTEGER REFERENCES departments(id),
    designation_id INTEGER REFERENCES designations(id),
    is_primary BOOLEAN DEFAULT false,
    start_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    end_date TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER REFERENCES employees(id),
    updated_by INTEGER REFERENCES employees(id)
);

-- Create index for faster queries
CREATE INDEX idx_employee_assignments_employee_id ON employee_assignments(employee_id);
CREATE INDEX idx_employee_assignments_company_id ON employee_assignments(company_id);
CREATE INDEX idx_employee_assignments_branch_id ON employee_assignments(branch_id);
CREATE INDEX idx_employee_assignments_current ON employee_assignments(employee_id) WHERE end_date IS NULL;

-- Migrate existing primary assignments
INSERT INTO employee_assignments (
    employee_id,
    company_id,
    branch_id,
    department_id,
    designation_id,
    is_primary,
    start_date
)
SELECT 
    id as employee_id,
    primary_company_id as company_id,
    home_branch_id as branch_id,
    department_id,
    designation_id,
    true as is_primary,
    COALESCE(hire_date, created_at) as start_date
FROM employees
WHERE primary_company_id IS NOT NULL 
    OR home_branch_id IS NOT NULL;

-- Add new columns to employees table
ALTER TABLE employees 
    ADD COLUMN IF NOT EXISTS company_id INTEGER REFERENCES companies(id),
    ADD COLUMN IF NOT EXISTS branch_id INTEGER REFERENCES branches(id);

-- Update employees table with current assignments
UPDATE employees e
SET 
    company_id = primary_company_id,
    branch_id = home_branch_id;

-- Create trigger function to maintain assignment history
CREATE OR REPLACE FUNCTION update_employee_assignment()
RETURNS TRIGGER AS $$
BEGIN
    -- If company_id or branch_id changed
    IF (NEW.company_id != OLD.company_id) OR (NEW.branch_id != OLD.branch_id) THEN
        -- End the current assignment
        UPDATE employee_assignments
        SET end_date = CURRENT_TIMESTAMP
        WHERE employee_id = NEW.id 
            AND end_date IS NULL;
            
        -- Create new assignment
        INSERT INTO employee_assignments (
            employee_id,
            company_id,
            branch_id,
            department_id,
            designation_id,
            is_primary,
            start_date
        ) VALUES (
            NEW.id,
            NEW.company_id,
            NEW.branch_id,
            NEW.department_id,
            NEW.designation_id,
            true,
            CURRENT_TIMESTAMP
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER employee_assignment_change
    AFTER UPDATE OF company_id, branch_id
    ON employees
    FOR EACH ROW
    EXECUTE FUNCTION update_employee_assignment();

-- Add comments for documentation
COMMENT ON TABLE employee_assignments IS 'Tracks historical and current assignments of employees to companies and branches';
COMMENT ON COLUMN employee_assignments.is_primary IS 'Indicates if this was the primary assignment at the time'; 