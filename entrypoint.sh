#!/bin/bash
set -e

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
        pwsh -C "\$sess = New-PSSession -HostName $remote_host -Username $remote_username; Invoke-AtomicTest -Session \$sess $test_id -GetPreReqs"
      else
        pwsh -C "\$sess = New-PSSession -HostName $remote_host -Username $remote_username; Invoke-AtomicTest -Session \$sess $test_id"
      fi
    else
      if [ $get_prereqs = true ]
      then
        pwsh -C "\$sess = New-PSSession -HostName $remote_host -Username $remote_username -KeyFilePath $remote_private_key_path; Invoke-AtomicTest -Session \$sess $test_id -GetPreReqs"
      else
        pwsh -C "\$sess = New-PSSession -HostName $remote_host -Username $remote_username -KeyFilePath $remote_private_key_path; Invoke-AtomicTest -Session \$sess $test_id"
      fi
    fi
  fi
fi

exec "$@"