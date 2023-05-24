#!/bin/bash

# Function to check if the maximum "last mv refresh" timestamp is greater than another database table
function check_mv_refresh {
    oracle_max_refresh=$(impala-shell -i impala_host --quiet -B -q "SELECT MAX(last_mv_refresh) FROM your_table;")

    other_db_max_refresh=$(impala-shell -i impala_host --quiet -B -q "SELECT MAX(last_mv_refresh) FROM other_table;")

    if [[ "$oracle_max_refresh" > "$other_db_max_refresh" ]]; then
        echo "Maximum last mv refresh in Oracle is greater than the other database."
        execute_pipeline
        exit 0
    else
        echo "MV not refreshed."
        exit 1
    fi
}

# Function to execute the pipeline
function execute_pipeline {
    echo "Executing the pipeline..."
    # Add your pipeline execution command here
}

# Check the completion status of the Oracle job
job_status=$(impala-shell -i impala_host --quiet -B -q "SELECT status FROM your_job;")

if [[ "$job_status" == "COMPLETED" ]]; then
    echo "Oracle job has completed."
    check_mv_refresh
else
    echo "Oracle job has not completed."
    exit 1
fi
