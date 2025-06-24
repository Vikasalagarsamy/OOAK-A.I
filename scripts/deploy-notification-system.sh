#!/bin/bash

# Notification System Deployment Script
echo "🚀 Starting Notification System Deployment"

# 1. Environment Setup
echo "Setting up environment variables..."
export NOTIFICATION_POLLING_INTERVAL=30000
export NOTIFICATION_MAX_RETRIES=3

# 2. Database Backup
echo "Creating database backup..."
pg_dump -U postgres -d ooak_ai > backup_$(date +%Y%m%d).sql

# 3. Database Migration
echo "Running database migrations..."
psql -U postgres -d ooak_ai << EOF
CREATE TABLE IF NOT EXISTS notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) NOT NULL,
    read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_read ON notifications(read);
EOF

# 4. Deploy Backend Changes
echo "Deploying backend changes..."
git checkout e893160
render deploy

# 5. Verify Backend
echo "Verifying backend deployment..."
curl -s https://api.ooak-ai.com/health
if [ $? -ne 0 ]; then
    echo "❌ Backend deployment failed"
    exit 1
fi

# 6. Deploy Frontend Changes
echo "Deploying frontend changes..."
git checkout 40f24a4
render deploy

# 7. Post-Deployment Verification
echo "Running post-deployment checks..."

# Check API endpoints
curl -s https://api.ooak-ai.com/api/notifications/health
if [ $? -ne 0 ]; then
    echo "❌ Notification API check failed"
    exit 1
fi

# 8. Tag Deployment
echo "Tagging deployment..."
git tag -a v1.1.0 40f24a4 -m "Notification System Deployment $(date)"
git push origin v1.1.0

# 9. Update Deployment Log
echo "Updating deployment log..."
cat << EOF >> deployments.log
## Deployment $(date)
Version: v1.1.0
Commit: 40f24a4
Feature: Notification System
Status: ✅ Success
EOF

echo "✅ Deployment completed successfully!"

# Monitoring Instructions
echo """
🔍 Post-Deployment Monitoring:
1. Check error logs: render logs
2. Monitor API health: curl https://api.ooak-ai.com/health
3. Watch notification metrics: curl https://api.ooak-ai.com/api/notifications/metrics
4. Verify frontend: https://ooak-ai.com
"""

# Rollback Instructions
echo """
⚠️ Rollback Instructions (if needed):
1. git checkout dcec553
2. render deploy
3. psql -U postgres -d ooak_ai -f backup_$(date +%Y%m%d).sql
""" 