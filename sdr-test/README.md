# SDR Test
A simple container that can be installed within a Kubernetes cluster to test 
software define radios which are connected to nodes within the cluster.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Installation
The installation uses Kustomize to apply the necessary resources to the cluster.

```bash
kubectl apply -k
```

## Usage
This container is intended to be used as a test container to verify that the
software defined radios are functioning correctly. The container will run a
simple test to verify that the radio is functioning correctly.


## Contributing
Pull requests are welcome. For major changes, please open an issue first to 
discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
