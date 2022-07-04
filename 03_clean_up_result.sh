#!/bin/bash

# mprof run --include-children bash 03_clean_up_result.sh
# mprof plot

# Delete the runtime files in the very end, if not deleted previously.
password_file_path="$PWD"/../example_password.txt
workflow_name=arcasHLA
current_wdl_runtime_directory="$PWD"/wdl_runtime_directory/${workflow_name}
echo $(cat $password_file_path) | sudo -S rm -r ${current_wdl_runtime_directory}/cromwell-executions ${current_wdl_runtime_directory}/cromwell-workflow-logs


mv "$PWD"/wdl_result_directory "$PWD"/..
mv "$PWD"/wdl_runtime_directory "$PWD"/..

# Delete running history in the R project.
rm -r "$PWD"/.Rproj.user

echo "The script runs up to here!"


