# analog_bridge

## Running manually
```bash
docker run -d \
    -e DMR_ID=... \
    analog-bridge:VERSION
```

### Available environment variables
```bash
EMULATOR_ADDR       # Address to the md380 emulator service
EMULATOR_PORT       # Port for the md380 emulator
DMR_ID              # DMR ID from radioid.net
SSID                # 2 numbers for repeater ID
```