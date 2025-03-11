#!/bin/bash

# Script to fluctuate memory usage for Grafana/Prometheus testing
# Requires 'stress-ng' tool (install with: apt-get install stress-ng or yum install stress-ng)

echo "Memory fluctuation script for Grafana testing"
echo "Press Ctrl+C to stop the script"

# Function to display current memory usage
show_memory() {
  free -m | grep "Mem:" | awk '{printf "Memory Usage: %d MB / %d MB (%.2f%%)\n", $3, $2, $3*100/$2}'
}

# Check if stress-ng is installed
if ! command -v stress-ng &> /dev/null; then
  echo "stress-ng is not installed. Please install it first."
  echo "On Debian/Ubuntu: sudo apt-get install stress-ng"
  echo "On RHEL/CentOS: sudo yum install stress-ng"
  exit 1
fi

# Main loop to fluctuate memory
while true; do
  # Show current memory usage
  echo "==== $(date) ===="
  show_memory
  
  # Determine a random amount of memory to use (between 100MB and 400MB)
  MEM_SIZE=$((RANDOM % 300 + 100))
  DURATION=$((RANDOM % 30 + 15))  # Random duration between 15-45 seconds
  
  echo "Allocating ${MEM_SIZE}MB of memory for ${DURATION} seconds..."
  
  # Start stress-ng to allocate memory
  stress-ng --vm 1 --vm-bytes ${MEM_SIZE}M --timeout ${DURATION}s &
  STRESS_PID=$!
  
  # Wait for stress-ng to finish
  wait $STRESS_PID
  
  # Show memory after allocation
  show_memory
  
  echo "Releasing memory and waiting for 20 seconds..."
  sleep 20  # Wait period between memory spikes
  
  # Show memory after release
  show_memory
  echo ""
done
