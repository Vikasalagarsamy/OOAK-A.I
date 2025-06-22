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
**Status**: STABLE - DO NOT MODIFY
**Protected Files**:
- `app/(authenticated)/admin/menu-permissions/**`
- `app/api/auth/menu-permissions/**`
- `app/api/admin/menu-permissions/**`

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

1. **Do Not Modify Protected Files**
   - Any changes to protected files require thorough review
   - Create new files instead of modifying existing ones
   - Use composition over modification

2. **Database Changes**
   - Do not modify existing tables/columns
   - Add new tables for new features
   - Use migrations for any schema changes

3. **Route Groups**
   - Keep `(authenticated)` route group structure
   - Maintain existing rewrite rules in `next.config.js`
   - Add new routes following the established pattern

4. **Component Extensions**
   - Create new components instead of modifying existing ones
   - Use props and composition to extend functionality
   - Keep existing prop interfaces unchanged

5. **API Extensions**
   - Create new endpoints for new features
   - Do not modify existing endpoint contracts
   - Version new APIs if needed

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