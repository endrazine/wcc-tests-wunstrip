#!/bin/bash
set -e

# Start debuginfod in background
export DEBUGINFOD_CACHE_PATH=/var/cache/debuginfod
echo "Starting debuginfod..."
debuginfod -p 8002 /usr/lib/debug /usr/bin &

# Wait for debuginfod to start
sleep 5

echo "debuginfod started, now running make commands..."

# Actually run the make commands
make wunstrip
make

echo "Build completed successfully!"

# Keep container running
tail -f /dev/null
