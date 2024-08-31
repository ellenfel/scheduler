# Scheduler Script Documentation

## Overview

The `scheduler.sh` script automates the scheduling of end-of-day, end-of-week, and end-of-month report generation by setting up cron jobs on your system. This ensures that reports are generated automatically at specific times without manual intervention.

## Script: `scheduler.sh`

### Purpose

The script schedules the following reports:
- **End-of-Day Report**: Generated daily at 23:59.
- **End-of-Week Report**: Generated every Sunday at 23:59.
- **End-of-Month Report**: Generated on the last day of each month at 23:59.

### How It Works

- **Cron Jobs**: The script checks if a cron job already exists for the desired task. If not, it adds the necessary cron job.
- **Environment Setup**: Ensure that paths and environment variables used by the script are properly configured.

### Script Content

```bash
#!/bin/bash

# Define paths and commands
REPORT_SCRIPT="/home/ellenfel/Desktop/reporting/test-on-production.sh"

# Function to schedule a cron job
schedule_job() {
    local cron_time=$1
    local job_command=$2

    # Check if the job already exists
    existing_job=$(crontab -l | grep -F "$job_command")

    if [ -z "$existing_job" ]; then
        # Add the cron job
        (crontab -l; echo "$cron_time $job_command") | crontab -
        echo "Scheduled: $cron_time $job_command"
    else
        echo "Job already scheduled: $cron_time $job_command"
    fi
}

# Schedule end-of-day report (runs every day at 23:59)
schedule_job "59 23 * * *" "sudo bash $REPORT_SCRIPT end_of_day"

# Schedule end-of-week report (runs every Sunday at 23:59)
schedule_job "59 23 * * 0" "sudo bash $REPORT_SCRIPT end_of_week"

# Schedule end-of-month report (runs on the last day of every month at 23:59)
schedule_job "59 23 28-31 * *" "sudo bash -c '[ $(date +\%d -d tomorrow) == 01 ] && $REPORT_SCRIPT end_of_month'"

# Additional logic for specific cases can be added here
```

### Explanation:

1. **End-of-Day Report**:
   - Scheduled to run daily at 23:59.
   - Command: `sudo bash $REPORT_SCRIPT end_of_day`

2. **End-of-Week Report**:
   - Scheduled to run every Sunday at 23:59.
   - Command: `sudo bash $REPORT_SCRIPT end_of_week`

3. **End-of-Month Report**:
   - Scheduled to run on the last day of every month at 23:59.
   - The script checks if tomorrow is the first of the month to determine the last day.
   - Command: `sudo bash -c '[ $(date +\%d -d tomorrow) == 01 ] && $REPORT_SCRIPT end_of_month'`
