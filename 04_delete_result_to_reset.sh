#!/bin/bash

# mprof run --include-children bash 03_clean_up_result.sh
# mprof plot

rm -r "$PWD"/../wdl_result_directory
rm -r "$PWD"/../wdl_runtime_directory



echo "The script runs up to here!"


