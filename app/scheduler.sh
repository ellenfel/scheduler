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
