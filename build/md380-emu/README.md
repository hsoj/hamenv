# md380-emu
A container for providing an MD380 emulator to encode and decode the audio 
stream sent to the exposed port (Default: 2047).

Every deployment will need at least one emulator container running.

## Examples
### Building
*NOTE* Building should be done from the root directory of the repository.

```bash
docker build -t md380-emu:local build/md380-emu
```

### Running
```bash
docker run -d -p 2047:2047/udp md380-emu:latest
```