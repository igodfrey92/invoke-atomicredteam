FROM ubuntu:18.04

RUN apt-get update -y && apt-get upgrade -y

# install dependencies and powershell for linux
RUN apt-get install -y wget software-properties-common && \
    wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update -y && \
    add-apt-repository -y universe && \
    apt-get install -y powershell 

# install atomic red
SHELL ["pwsh", "-Command" , "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue'; $verbosePreference='Continue';"]

RUN IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing); Install-AtomicRedTeam -getAtomics -Force;
RUN if (!(Test-Path -Path $PROFILE)) { \
      New-Item -ItemType File -Path $PROFILE -Force \
    }

# import the invoke module
RUN echo 'Import-Module "/root/AtomicRedTeam/invoke-atomicredteam/Invoke-AtomicRedTeam.psd1" -Force;' >> $PROFILE

# set the entrypoint; allows for passing in of arguments to Invoke-AtomicTest
ENTRYPOINT [ "/usr/bin/pwsh", "-C", "Invoke-AtomicTest" ]

# todo allow for remote execution against hosts
# todo allow for saving test results on host or exporting elsewhere