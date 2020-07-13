#!/bin/bash
set -e

# ignore host key checking
echo "Host *
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config

# todo allow for running multiple tests at once against the same host
# todo allow for running multiple tests against different hosts
# todo create some mechanism for uploading/storing results externally to container
# run atomic test; get prereqs if desired (defaults to false)
if [ -z $test_id ]
then
  echo "Please supply a test ID"
else
  if [ -z $remote_host ]
  then
    if [ $get_prereqs = true ]
    then
      pwsh -C Invoke-AtomicTest $test_id -GetPreReqs
    else
      pwsh -C Invoke-AtomicTest $test_id
    fi
  else
    if [ -z $remote_private_key_path ]
    then
      if [ $get_prereqs = true ]
      then
        echo "Running test against host $remote_host"
        pwsh -C "\$sess = New-PSSession -HostName $remote_host -Username $remote_username; Invoke-AtomicTest -Session \$sess $test_id -GetPreReqs" | tee /var/log/$test_id-results.log
      else
        echo "Running test against host $remote_host"
        pwsh -C "\$sess = New-PSSession -HostName $remote_host -Username $remote_username; Invoke-AtomicTest -Session \$sess $test_id" | tee /var/log/$test_id-results.log
      fi
    else
      if [ $get_prereqs = true ]
      then
        echo "Running test against host $remote_host"
        pwsh -C "\$sess = New-PSSession -HostName $remote_host -Username $remote_username -KeyFilePath $remote_private_key_path; Invoke-AtomicTest -Session \$sess $test_id -GetPreReqs" | tee /var/log/$test_id-results.log
      else
        echo "Running test against host $remote_host"
        pwsh -C "\$sess = New-PSSession -HostName $remote_host -Username $remote_username -KeyFilePath $remote_private_key_path; Invoke-AtomicTest -Session \$sess $test_id" | tee /var/log/$test_id-results.log
      fi
    fi
  fi
fi

exec "$@"