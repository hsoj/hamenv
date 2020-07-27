# analog-bridge
The analog-bridge container provides a USRP service to communicate with the 
DVSwitch mobile application, as well as sends communications through the 
md380-emu container to encode/decode the DMR communications for the MMDVM 
bridge.

### Available environment variables
```bash
ANALOG_ADDR         # Address for this container
ANALOG_PORT         # Port for the Analog Bridge to RX from the MMDVM Bridge
CALLSIGN            # The operators callsign
DMR_ID              # DMR ID from radioid.net
EMULATOR_ADDR       # Address to the md380 emulator service
EMULATOR_PORT       # Port for the md380 emulator
MMDVM_ADDR          # Address to the MMDVM bridge
MMDVM_PORT          # Port for the MMDVM bridge
MOBILE_CLIENT_PORT  # Port the mobile application connects to
SSID                # 2 numbers for repeater ID
```

## Examples
### Building
*NOTE* Building should be done from the root directory of the repository.

```bash
docker build -t analog-bridge:0.0.1 build/analog-bridge
```

### Running
```bash
docker run -d \
    -e CALLSIGN=... \
    -e DMR_ID=... \
    -e ANALOG_ADDR={{external_ip_of_container_host}} \
    -e EMULATOR_ADDR={{external_ip_of_container_host}} \
    -e MMDVM_ADDR={{external_ip_of_container_host}} \
    analog-bridge:0.0.1
```