#!/bin/bash
# =============================================================================
# Emergency PostgreSQL Fix Script
# =============================================================================
# Run this script if PostgreSQL is not starting properly after cluster recovery
# =============================================================================

echo "🔧 Emergency PostgreSQL Fix Script"
echo "=================================="

echo "1. Stopping PostgreSQL service..."
sudo systemctl stop postgresql
sudo pkill -f postgres || true

sleep 3

echo "2. Checking cluster status..."
if sudo pg_ctlcluster 16 main status; then
    echo "✅ Cluster is running"
else
    echo "❌ Cluster has issues, attempting recovery..."
    
    echo "3. Removing corrupted cluster..."
    sudo pg_dropcluster 16 main --stop || true
    
    echo "4. Cleaning up directories..."
    sudo rm -rf /var/lib/postgresql/16/main || true
    sudo rm -rf /etc/postgresql/16/main || true
    
    echo "5. Creating fresh cluster..."
    sudo pg_createcluster 16 main --start
    
    echo "6. Waiting for cluster to be ready..."
    sleep 5
fi

echo "7. Starting PostgreSQL service..."
sudo systemctl start postgresql
sudo systemctl enable postgresql

echo "8. Waiting for PostgreSQL to be ready..."
sleep 10

echo "9. Checking PostgreSQL socket..."
if [ -S "/var/run/postgresql/.s.PGSQL.5432" ]; then
    echo "✅ PostgreSQL socket is ready"
else
    echo "❌ Socket not ready, waiting longer..."
    sleep 10
fi

# Check if TCP port is ready
echo "10. Checking PostgreSQL TCP port..."
if nc -z 127.0.0.1 5432; then
    echo "✅ PostgreSQL TCP port is ready"
else
    echo "❌ TCP port not ready"
fi

echo "11. Final status check..."
sudo systemctl status postgresql --no-pager
sudo pg_ctlcluster 16 main status

echo ""
echo "🎉 Emergency fix completed!"
echo "You can now run your Ansible playbook again:"
echo "ansible-playbook -i inventory.ini playbook.yml"