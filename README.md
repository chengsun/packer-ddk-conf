DDK Test
========

**Setup Jenkins**:

- environment variables
  - `HOST_USERNAME`
  - `HOST_PASSWORD`
  - `HOST_IP`

- execute shell

        exec ./ddk-build.sh

**Known issues**:

- xenserver-ddk-files needs to be updated to quote `--build` before the DDK VM can actually build the hello world example.
