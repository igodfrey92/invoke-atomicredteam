FROM ubuntu:18.04

RUN apt-get update -y && apt-get upgrade -y

# install dependencies and powershell for linux
RUN apt-get install -y ssh wget software-properties-common && \
    wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update -y && \
    add-apt-repository -y universe && \
    apt-get install -y powershell 

# install atomic red
SHELL [ "pwsh", "-Command" , "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue'; $verbosePreference='Continue';"]

RUN IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing); Install-AtomicRedTeam -getAtomics -Force;
RUN if (!(Test-Path -Path $PROFILE)) { \
      New-Item -ItemType File -Path $PROFILE -Force \
    }

# import the invoke module
RUN echo 'Import-Module "/root/AtomicRedTeam/invoke-atomicredteam/Invoke-AtomicRedTeam.psd1" -Force;' >> $PROFILE

# env vars
ENV test_id=
ENV get_prereqs=false
# if supplying a dns hostname, be sure to mount a file either at /etc/hosts or /etc/resolv.conf to name resolution
ENV remote_host=
ENV remote_username=
# if accessing a remote host via private key, mount it inside the container at runtime with -v; supply the path to that key via this env variable
ENV remote_private_key_path=

# copy the entrypoint script and set it as the container entrypoint
COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT [ "entrypoint.sh" ]