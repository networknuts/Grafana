#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   echo "Please use: sudo $0"
   exit 1
fi

# Configuration
INSTALL_DIR="/opt/process-metrics-collector"
PYTHON_SCRIPT="process_metrics.py"
SERVICE_FILE="process-metrics-collector.service"
PROMETHEUS_USER="prometheus"

# Create prometheus user if not exists
if ! id "$PROMETHEUS_USER" &>/dev/null; then
    useradd -r -s /bin/false "$PROMETHEUS_USER"
fi

# Create installation directory
mkdir -p "$INSTALL_DIR"

# Copy Python script
cp "$PYTHON_SCRIPT" "$INSTALL_DIR/"
chown "$PROMETHEUS_USER:$PROMETHEUS_USER" "$INSTALL_DIR/$PYTHON_SCRIPT"
chmod 644 "$INSTALL_DIR/$PYTHON_SCRIPT"

# Copy and enable service file
cp "$SERVICE_FILE" "/etc/systemd/system/$SERVICE_FILE"
chmod 644 "/etc/systemd/system/$SERVICE_FILE"

# Reload systemd, enable and start service
systemctl daemon-reload
systemctl enable "$(basename "$SERVICE_FILE")"
systemctl start "$(basename "$SERVICE_FILE")"

# Verify service status
systemctl status "$(basename "$SERVICE_FILE")"

echo "Deployment completed successfully!"
