#!/bin/sh

# Run the prune command and then sleep in an infinite loop

echo "Starting crictl pruning loop..."
while true; do
  # Execute the crictl prune command
  echo "Executing crictl prune command at $(date)..."
  # Ensure the runtime-endpoint path is correct for MicroK8s
  /usr/local/bin/crictl --runtime-endpoint unix:///var/snap/microk8s/common/run/containerd.sock rmi --prune
  if [ $? -ne 0 ]; then
      echo "Warning: crictl prune command failed at $(date)."
      # Continue the loop even if prune fails
  else
      echo "crictl prune command completed at $(date)."
  fi

  # Sleep for 1 hour (3600 seconds)
  echo "Sleeping for 3600 seconds..."
  sleep 3600
done

