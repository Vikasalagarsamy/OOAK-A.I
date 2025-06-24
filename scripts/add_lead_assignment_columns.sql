-- Add columns for lead assignment
ALTER TABLE leads
ADD COLUMN IF NOT EXISTS assigned_to INTEGER REFERENCES employees(id),
ADD COLUMN IF NOT EXISTS assigned_by INTEGER REFERENCES employees(id),
ADD COLUMN IF NOT EXISTS assigned_at TIMESTAMP WITH TIME ZONE,
ADD COLUMN IF NOT EXISTS status VARCHAR(50) DEFAULT 'unassigned';

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_leads_assigned_to ON leads(assigned_to);
CREATE INDEX IF NOT EXISTS idx_leads_status ON leads(status);

-- Update existing leads to have 'unassigned' status if null
UPDATE leads SET status = 'unassigned' WHERE status IS NULL; 