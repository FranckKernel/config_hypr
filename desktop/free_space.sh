#!/bin/bash

label='Arch System'

arch_system_partition=$(
	lsblk -Jpo NAME,PARTLABEL |
		jq -r --arg label "$label" '
            .blockdevices[]
            | .children[]?
            | select(.partlabel == $label)
            | .name
        '
)

if [[ -z "$arch_system_partition" ]]; then
	notify-send -t 8000 -u critical \
		"Disk Space Status" \
		"Could not find partition: $label"
	exit 1
fi

# NR==2 : Only process the second line of the output
free_space=$(df -h "$arch_system_partition" | awk 'NR==2 {print $4}')
used_percent=$(df -h "$arch_system_partition" | awk 'NR==2 {print $5}')
total_size=$(df -h "$arch_system_partition" | awk 'NR==2 {print $2}')
used_space=$(df -h "$arch_system_partition" | awk 'NR==2 {print $3}')

message="Main Drive ($arch_system_partition)
Total: $total_size
Used: $used_space ($used_percent) | Free: $free_space"

notify-send -t 8000 -u normal "Disk Space Status" "$message"
