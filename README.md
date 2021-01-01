Invoke-AtomicRedTeam is a PowerShell module to execute tests as defined in the [atomics folder](https://github.com/redcanaryco/atomic-red-team/tree/master/atomics) of Red Canary's Atomic Red Team project. The "atomics folder" contains a folder for each Technique defined by the [MITRE ATT&CK™ Framework](https://attack.mitre.org/matrices/enterprise/). Inside of each of these "T#" folders you'll find a **yaml** file that defines the attack procedures for each atomic test as well as an easier to read markdown (**md**) version of the same data.

* Executing atomic tests may leave your system in an undesirable state. You are responsible for understanding what a test does before executing.

* Ensure you have permission to test before you begin.

* It is recommended to set up a test machine for atomic test execution that is similar to the build in your environment. Be sure you have your collection/EDR solution in place, and that the endpoint is checking in and active.

See the Wiki for complete [Installation and Usage instructions](https://github.com/redcanaryco/invoke-atomicredteam/wiki).

Note: This execution framworks works on Windows, MacOS and Linux. If using on MacOS or Linux you must install PowerShell Core first.

Invoke Container

The Dockerfile and entrypoint.sh scripts found in the root directory can be used to create a docker image containing atomic red  atomics and Invoke-Atomic. The following envionment variables can be defined at runtime:

- test_id (string)
- get_prereqs (bool)
- remote_host (string)
- remote_username (string)
- remote_private_key_path (string)

Build the container image by cloning down the repo and running the following command in the root directory:

`docker build -t invoke-container:latest .`

Afer bulding the container image you can run atomic tests against remote hosts using the following command as an example:

`docker run -e test_id=T1135 -e remote_host="172.16.0.12" -e remote_username="ubuntu" invoke-container`

You'll be prompted to enter the password for the username provided. If instead you'd like to provide an ssh key you can do so with the following command where "key.pem" is the private key of the user accessing the host:

`docker run -v "$(pwd)/key":/tmp/key.pem -e test_id="T1135" -e remote_host="172.17.0.2" -e remote_username="ubuntu" -e remote_private_key_path="/tmp/key/key.pem" invoke-container`

Keep in mind, if you're running against a remote host powershell remoting will need to be enabled on that host.
