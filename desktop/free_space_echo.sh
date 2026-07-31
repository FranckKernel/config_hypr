#!/bin/bash

PARTITION="/dev/nvme0n1p3"

# Get free space information for $PARTITION
free_space=$(df -h $PARTITION | awk 'NR==2 {print $4}')
used_percent=$(df -h $PARTITION | awk 'NR==2 {print $5}')
total_size=$(df -h $PARTITION | awk 'NR==2 {print $2}')
used_space=$(df -h $PARTITION | awk 'NR==2 {print $3}')

# Create notification message
message="$free_space"

# Send notification
echo "$message"
