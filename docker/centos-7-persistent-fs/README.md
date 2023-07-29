# Interactive Shell within data 'Persistent' CentOS 7 Docker Container

This script provides an interactive shell within a CentOS 7 Docker container. The persistent data is stored in a local `fs` directory, with all the important Linux subdirectories being populated by extracting data from the Docker image for CentOS 7. If the `fs` directory already exists, the script will skip the extraction step. Various directories from `fs` are then mounted to the corresponding paths within the container. This allows the container to retain its data across multiple runs, making it loosely "persistent".

Please note, this only works if the docker image has one `layer.tar` when creating the `fs` directory. Currently, CentOS 7 does, so this works! (for now...)

> :warning: FOR NON PRODUCTION USE!! USE AT YOUR OWN RISK!!

## Getting Started

These instructions will get you a copy of the project up and running on your local machine.

### Prerequisites

* Docker

### Running the script

1. Clone the repository to your local machine.
2. Navigate to the directory containing the script.
3. Run the script:

```bash
./run.sh
```

### License
This project is licensed under the MIT License - see the LICENSE.md file in the parent folder for details.

### Acknowledgments
Thanks to the Docker and CentOS teams for maintaining their respective projects.
