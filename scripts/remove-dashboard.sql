-- Remove Dashboard menu item and update sort orders
DELETE FROM designation_menu_permissions
WHERE menu_item_id IN (SELECT id FROM menu_items WHERE name = 'Dashboard');

DELETE FROM menu_items 
WHERE name = 'Dashboard';

-- Update sort orders for remaining items
UPDATE menu_items 
SET sort_order = sort_order - 1 
WHERE sort_order > 1;

-- Update menu items to start with Sales
UPDATE menu_items 
SET sort_order = 1 
WHERE name = 'Sales' AND parent_id IS NULL; 