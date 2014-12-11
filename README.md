DDK Test
========

**Setup Jenkins**:

- environment variables
  - `HOST_USERNAME`
  - `HOST_PASSWORD`
  - `HOST_IP`
  - `LOCAL_HOSTNAME` -- name of the Jenkins server

- execute shell

        exec ./ddk-build.sh

**Known issues**:

- Currently we need to manually setup the NFS ISO library on the Jenkins server, and then manually add it to the target XenServer host. It would be great if both of these could be automated.
- Where should we export the finished build to?
- xenserver-ddk-files needs to be updated to quote `--build` before the DDK VM can actually build the hello world example.
