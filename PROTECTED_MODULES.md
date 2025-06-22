# Protected Modules

This document outlines the modules that are considered stable and should not be modified without proper review and testing.

## Version v1.0.0-auth-stable

### Authentication Module
**Status**: STABLE - DO NOT MODIFY
**Protected Files**:
- `app/login/**`
- `app/api/auth/**`
- `components/auth/**`
- `lib/auth.ts`
- `lib/auth-client.ts`
- `middleware.ts` (authentication-related code)

### Menu Permissions Module
**Status**: STABLE - PARTIAL MODIFICATIONS ALLOWED
**Protected Files**:
- `app/(authenticated)/admin/menu-permissions/**` (core functionality)
- `app/api/auth/menu-permissions/**` (core functionality)
- `app/api/admin/menu-permissions/**` (core functionality)

**Allowed Modifications**:
1. Adding new menu items to the database
2. Updating menu hierarchies
3. Adding new menu sections
4. Modifying menu item properties (path, icon, etc.)

**Database Tables Open for Menu Updates**:
- `menu_items` - Adding new rows
- `designation_menu_permissions` - Adding corresponding permissions

### Dashboard Core
**Status**: STABLE - BASE FUNCTIONALITY
**Protected Files**:
- `app/(authenticated)/dashboard/page.tsx` (core structure)
- `app/api/dashboard/route.ts` (base endpoints)
- `components/dashboard/DashboardContent.tsx` (base layout)

### Critical Configuration
**Status**: STABLE - REQUIRES REVIEW
**Protected Files**:
- `next.config.js` (routing rules)
- `lib/db.ts` (database configuration)

## Guidelines for Future Development

1. **Menu Management (ALLOWED CHANGES)**
   - New menu items can be added through the admin interface
   - Menu items can be reorganized under different sections
   - New sections can be added to group menu items
   - Example: Adding "Menu Permissions" under "System Administration"

2. **Do Not Modify Protected Files**
   - Core functionality should remain unchanged
   - Create new files instead of modifying existing ones
   - Use composition over modification

3. **Database Changes**
   - Do not modify existing table structures
   - Menu-related tables are exception (see Menu Management)
   - Add new tables for new features
   - Use migrations for any schema changes

4. **Route Groups**
   - Keep `(authenticated)` route group structure
   - Maintain existing rewrite rules in `next.config.js`
   - Add new routes following the established pattern

5. **Component Extensions**
   - Create new components instead of modifying existing ones
   - Use props and composition to extend functionality
   - Keep existing prop interfaces unchanged

6. **API Extensions**
   - Create new endpoints for new features
   - Do not modify existing endpoint contracts
   - Version new APIs if needed

## Menu Addition Process

When adding new menu items:
1. Use the Menu Permissions admin interface
2. Add the menu item under appropriate parent
3. Set proper path, icon, and section
4. Update permissions for relevant designations
5. Follow the existing menu structure pattern

Example for adding "Menu Permissions" under System Administration:
```sql
-- This type of menu addition is allowed
INSERT INTO menu_items (
    name,
    path,
    icon,
    parent_id,
    string_id,
    section_name,
    is_admin_only,
    sort_order,
    is_visible
) VALUES (
    'Menu Permissions',
    '/admin/menu-permissions',
    'Settings',
    (SELECT id FROM menu_items WHERE string_id = 'system_administration'),
    'menu_permissions',
    'Configuration',
    true,
    10,
    true
);
```

## Extending Functionality

When adding new features:
1. Create new routes under appropriate route groups
2. Add new API endpoints in separate files
3. Create new components in relevant directories
4. Update menu items through the admin interface
5. Document new additions in their own documentation files

## Recovery Point

If needed, you can always return to this stable version:
```bash
git checkout v1.0.0-auth-stable
``` 