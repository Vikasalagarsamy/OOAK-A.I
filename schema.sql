-- Menu Permissions Schema

-- Check and create designations table if it doesn't exist
CREATE TABLE IF NOT EXISTS designations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Check and create employees table if it doesn't exist
CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    designation_id INTEGER REFERENCES designations(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Menu Items Table (stores the static menu structure)
CREATE TABLE IF NOT EXISTS menu_items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    path VARCHAR(255) NOT NULL,
    icon VARCHAR(100) NOT NULL,
    parent_id INTEGER REFERENCES menu_items(id),
    description TEXT,
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Designation Menu Permissions Table (stores which designation can access which menu items)
CREATE TABLE IF NOT EXISTS designation_menu_permissions (
    id SERIAL PRIMARY KEY,
    designation_id INTEGER NOT NULL REFERENCES designations(id) ON DELETE CASCADE,
    menu_item_id INTEGER NOT NULL REFERENCES menu_items(id) ON DELETE CASCADE,
    can_view BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER REFERENCES employees(id),
    updated_by INTEGER REFERENCES employees(id),
    UNIQUE(designation_id, menu_item_id)
);

-- Function to update timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Drop existing triggers if they exist
DROP TRIGGER IF EXISTS update_menu_items_modtime ON menu_items;
DROP TRIGGER IF EXISTS update_designation_menu_permissions_modtime ON designation_menu_permissions;
DROP TRIGGER IF EXISTS update_designations_modtime ON designations;
DROP TRIGGER IF EXISTS update_employees_modtime ON employees;

-- Create triggers for updating timestamps
CREATE TRIGGER update_menu_items_modtime
    BEFORE UPDATE ON menu_items
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_designation_menu_permissions_modtime
    BEFORE UPDATE ON designation_menu_permissions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_designations_modtime
    BEFORE UPDATE ON designations
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_employees_modtime
    BEFORE UPDATE ON employees
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Drop existing indexes if they exist
DROP INDEX IF EXISTS idx_menu_items_parent_id;
DROP INDEX IF EXISTS idx_designation_menu_permissions_designation_id;
DROP INDEX IF EXISTS idx_designation_menu_permissions_menu_item_id;

-- Create indexes for better performance
CREATE INDEX idx_menu_items_parent_id ON menu_items(parent_id);
CREATE INDEX idx_designation_menu_permissions_designation_id ON designation_menu_permissions(designation_id);
CREATE INDEX idx_designation_menu_permissions_menu_item_id ON designation_menu_permissions(menu_item_id);

-- Insert default SALES HEAD designation if it doesn't exist
INSERT INTO designations (name, description)
VALUES ('SALES HEAD', 'Head of Sales Department')
ON CONFLICT (name) DO NOTHING;

-- Insert default menu items if they don't exist
INSERT INTO menu_items (name, path, icon, parent_id, sort_order, is_active)
VALUES 
    ('Sales', '/sales', 'TrendingUp', NULL, 1, true)
ON CONFLICT DO NOTHING;

-- Insert child menu items
WITH sales_menu AS (
    SELECT id FROM menu_items WHERE name = 'Sales' AND path = '/sales'
)
INSERT INTO menu_items (name, path, icon, parent_id, sort_order, is_active)
SELECT 
    m.name,
    m.path,
    m.icon,
    s.id as parent_id,
    m.sort_order,
    m.is_active
FROM (
    VALUES 
        ('Leads', '/sales/leads', 'Users', 1, true),
        ('Quotations', '/sales/quotations', 'FileText', 2, true)
) as m(name, path, icon, sort_order, is_active)
CROSS JOIN sales_menu s
ON CONFLICT DO NOTHING;

-- Set up default permissions for SALES HEAD
WITH sales_head AS (
    SELECT id FROM designations WHERE name = 'SALES HEAD'
)
INSERT INTO designation_menu_permissions (designation_id, menu_item_id, can_view)
SELECT 
    sh.id as designation_id,
    mi.id as menu_item_id,
    true as can_view
FROM sales_head sh
CROSS JOIN menu_items mi
ON CONFLICT (designation_id, menu_item_id) DO NOTHING;

-- Remove Dashboard menu item and update sort orders
DELETE FROM designation_menu_permissions
WHERE menu_item_id IN (SELECT id FROM menu_items WHERE name = 'Dashboard');

DELETE FROM menu_items 
WHERE name = 'Dashboard';

-- Update sort orders for remaining items
WITH dashboard_order AS (
  SELECT sort_order 
  FROM menu_items 
  WHERE name = 'Dashboard'
)
UPDATE menu_items 
SET sort_order = sort_order - 1 
WHERE sort_order > (SELECT sort_order FROM dashboard_order);

-- Update menu items to start with Sales
UPDATE menu_items 
SET sort_order = 1 
WHERE name = 'Sales' AND parent_id IS NULL;

-- Companies and Branches Schema

-- Check and create companies table if it doesn't exist
CREATE TABLE IF NOT EXISTS companies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Check and create branches table if it doesn't exist
CREATE TABLE IF NOT EXISTS branches (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    company_id INTEGER NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create triggers for updating timestamps
CREATE TRIGGER update_companies_modtime
    BEFORE UPDATE ON companies
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_branches_modtime
    BEFORE UPDATE ON branches
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Create indexes for better performance
CREATE INDEX idx_branches_company_id ON branches(company_id);

-- Insert sample data
INSERT INTO companies (name, city, country, is_active)
VALUES 
    ('OOAK Studios - Chennai', 'Chennai', 'India', true),
    ('OOAK Studios - Bangalore', 'Bangalore', 'India', true)
ON CONFLICT DO NOTHING;

WITH chennai_company AS (
    SELECT id FROM companies WHERE name = 'OOAK Studios - Chennai'
),
bangalore_company AS (
    SELECT id FROM companies WHERE name = 'OOAK Studios - Bangalore'
)
INSERT INTO branches (name, company_id, city, country, is_active)
SELECT 'T. Nagar Branch', id, 'Chennai', 'India', true
FROM chennai_company
UNION ALL
SELECT 'Anna Nagar Branch', id, 'Chennai', 'India', true
FROM chennai_company
UNION ALL
SELECT 'Koramangala Branch', id, 'Bangalore', 'India', true
FROM bangalore_company
ON CONFLICT DO NOTHING; 