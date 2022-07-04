#!/bin/bash

# mprof run --include-children bash 02_run_local_wdl_run.sh
# mprof plot



# modify these information for each script.
workflow_name=arcasHLA
# batch_method=by_folder
batch_method=by_file

# These information should be constant
current_present_working_directory="$PWD"
current_wdl_preparation_directory="$PWD"/wdl_preparation_directory/${workflow_name}
current_wdl_result_directory="$PWD"/wdl_result_directory/${workflow_name}
current_wdl_runtime_directory="$PWD"/wdl_runtime_directory/${workflow_name}
current_wdl_input_json_directory=${current_wdl_runtime_directory}/local_input_directory/json_file_directory/${batch_method}

wdl_script_file_path=${current_wdl_preparation_directory}/${workflow_name}.local.wdl
wdl_option_file_path=${current_wdl_runtime_directory}/wdl_local_options.json
password_file_path="$PWD"/../example_password.txt
# email_recipient_file_path="$PWD"/../email_recipient.txt

# give the docker permission.
echo $(cat $password_file_path) | sudo -S chmod 666 /var/run/docker.sock

cd $current_wdl_runtime_directory

if [[ $batch_method == "by_file" ]]
	then
		echo -e "\nNow the job is run by file\n"
		
		for input_file in $(find $current_wdl_input_json_directory -type f -name "*.json" | sort)
			do
				finished_sample_names=$(ls $current_wdl_result_directory | cut -d "." -f 1 | sort | uniq)
				to_run_sample_name=$(basename $input_file | cut -d "." -f 1)
				
				if [[ "${finished_sample_names[@]}" =~ "${to_run_sample_name}" ]]; then
					# whatever you want to do when array contains value
					echo $to_run_sample_name has run, will do nothing.
				fi

				if [[ ! "${finished_sample_names[@]}" =~ "${to_run_sample_name}" ]]; then
					# whatever you want to do when array doesn't contain value
					echo $to_run_sample_name has not run, will run now.
					time java -Xmx96g -jar $CROMWELL run $wdl_script_file_path --inputs $input_file --options $wdl_option_file_path
					# echo $(cat $password_file_path) | sudo -S rm -r cromwell-executions cromwell-workflow-logs
				fi
			done
		
elif [[ $batch_method == "by_folder" ]]
	then
		echo -e "\nNow the job is run by folder\n"
		
		for input_folder in $(find $current_wdl_input_json_directory -type d -name "input_folder*" | sort)
			do
				for input_file in $(find $input_folder -type f -name "*.json" | sort)
					do
						finished_sample_names=$(ls $current_wdl_result_directory | cut -d "." -f 1 | sort | uniq)
						to_run_sample_name=$(basename $input_file | cut -d "." -f 1)

						if [[ "${finished_sample_names[@]}" =~ "${to_run_sample_name}" ]]; then
							# whatever you want to do when array contains value
							echo $to_run_sample_name has run, will do nothing.
						fi

						if [[ ! "${finished_sample_names[@]}" =~ "${to_run_sample_name}" ]]; then
							# whatever you want to do when array doesn't contain value
							echo $to_run_sample_name has not run, will run now.
							time java -Xmx96g -jar $CROMWELL run $wdl_script_file_path --inputs $input_file --options $wdl_option_file_path &
						fi
					done
				wait
				# echo $(cat $password_file_path) | sudo -S rm -r cromwell-executions cromwell-workflow-logs
			done
		
else
	echo "the method is not found"
fi

cd $current_present_working_directory

echo "The script runs up to here!"
# echo -e "Subject:Hello \n\n You have a job done, guess which\n" | sendmail $(echo $(cat $email_recipient_file_path))


