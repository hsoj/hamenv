# dvswitch_base
The dvswitch_base container image is provided to ensure that all of the dependencies 
required are provided for projects which leverage it.  In the event that there 
are additional dependencies that are shared amongst projects that are relevant, 
they should be added to this container image.

## Building
This image should only be built manually for development purposes, as the published 
artifact will require additional checks that are outside the scope of this 
document.

### Manual build
*NOTE*: Ensure to execute commands from the root directory of the repository.

```bash
docker build -t dvswitch_base:local build/dvswitch_base/
```