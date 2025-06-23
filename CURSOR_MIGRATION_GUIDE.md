# Cursor Production Migration Guide

## Overview
This guide explains how to manage production database migrations directly through Cursor IDE. We separate schema migrations from data migrations for better control and safety.

## Key Files

1. `lib/db-production.ts`
   - Contains production database configuration
   - Provides helper functions for database operations
   - Implements connection pooling and error handling

2. `scripts/cursor-schema-migration.ts`
   - Handles schema changes only (CREATE, ALTER, etc.)
   - No data manipulation
   - Schema verification after migration

3. `scripts/cursor-data-migration.ts`
   - Handles data changes only (INSERT, UPDATE, etc.)
   - Data verification after migration
   - Row count reporting

## Security Considerations

- Production credentials are stored in `lib/db-production.ts`
- SSL is enabled with `rejectUnauthorized: false`
- Transactions ensure atomic migrations
- Automatic rollback on failure

## Running Migrations

1. **Schema Migration**
   ```bash
   # Update schema.sql with your schema changes
   npx ts-node scripts/cursor-schema-migration.ts
   ```

2. **Data Migration**
   ```bash
   # Update schema.sql with your data changes
   npx ts-node scripts/cursor-data-migration.ts
   ```

## Migration Types

### Schema Migration
- Table creation/modification
- Index management
- Constraint changes
- Stored procedure updates
- Trigger modifications

### Data Migration
- Initial data seeding
- Data updates
- Reference data management
- Configuration data

## Features

- **Separated Concerns**: Schema and data migrations run independently
- **Transaction Support**: All migrations run in transactions
- **Automatic Rollback**: Failed migrations are automatically rolled back
- **Schema Verification**: Post-migration schema verification
- **Data Verification**: Row count verification after data migration
- **Detailed Logging**: Comprehensive logging of all operations
- **Connection Pooling**: Efficient database connection management

## Best Practices

1. **Always Test Locally First**
   - Test migrations on development database
   - Verify changes work as expected
   - Check for potential data issues

2. **Order of Operations**
   - Run schema migrations first
   - Verify schema changes
   - Then run data migrations
   - Verify data integrity

3. **Backup Before Migration**
   - Take a database snapshot before running migrations
   - Document the current state
   - Have a rollback plan

4. **Review Changes**
   - Double-check schema changes
   - Verify column types and constraints
   - Consider impact on existing data
   - Review data manipulation queries

5. **Monitor Migration**
   - Watch the migration logs
   - Verify schema after migration
   - Check data counts
   - Test critical functionality

## Troubleshooting

If migration fails:
1. Check the error message
2. Verify database connectivity
3. Review SQL syntax
4. Check for conflicting changes
5. Ensure proper permissions
6. Verify data integrity

## Notes

- This approach is for direct schema/data management through Cursor
- Not recommended for automated deployments
- Use with caution in production environment
- Always have a backup plan
- Run schema migrations before data migrations

## Support

For issues or questions:
1. Check the error logs
2. Review the schema/data changes
3. Contact the database administrator
4. Document any recurring issues 