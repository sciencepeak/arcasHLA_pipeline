#!/bin/bash


current_wdl_script=arcasHLA.local.wdl

java -jar $WOMTOOL validate $current_wdl_script
java -jar $WOMTOOL inputs $current_wdl_script > local_inputs_template.json

# solve the potential privilege issue:
# sudo chmod 666 /var/run/docker.sock