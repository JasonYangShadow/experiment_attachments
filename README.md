# Experiments Attachments For LPMX
This repository contains benchmark experiment scripts for LPMX.

To reproduce the experiments inside this repository, virtualbox and vagrant are needed.
## Requirement
1. Vagrant [https://www.vagrantup.com/](https://www.vagrantup.com/)
2. Oracle VM Virtualbox [https://www.virtualbox.org/](https://www.virtualbox.org/)

## To reproduce the composability experiment
open the terminal on your machine and type the following commands:
```
vagrant box add jasonyangshadow/composability
vagrant init jasonyangshadow/composability
vagrant up
vagrant ssh
```

Then you are in the virtual machine and all containers used in the experiment are configured and installed properly

A shell script named `run.sh` inside the home directory is used for the composability experiment, which has the very same content of the script named `composability.sh` inside this repository. Another script named `composability_helper.sh` is the real script executed inside the container for real genome analysis. Anyway, you do not need to download and put these scripts inside virtual machines, because they are also packaged and included inside the exported vagrant box. 

## To reproduce the benchmark experiment
open the terminal on your machine and type the following commands:
```
vagrant box add jasonyangshadow/benchmark_ubuntu1804
vagrant init jasonyangshadow/benchmark_ubuntu1804
vagrant up
vagrant ssh
```
Then you are in the virtual machine and all containers used in the experiment are configured and installed properly

A shell script named `installation_benchmark.sh` inside the home directory is used for the package installation performance benchmark test. It contains necessary bash commands for automating the experiment, just run it by the following command:

The time cost for installing packages is evaluated by the **time** command available in the Linux system.
```
cd ~ && ./installation_benchmark.sh
```

Another shell script named `container_creation_benchmark.sh` inside the home directory is used for the container creation benchmark test. It also contains necessary bash commands for automating the experiment.

To run the bash script:
```
cd ~ && ./container_creation_benchmark.sh
```

Also for a python script named `image_convertion_benchmark.py`, it is used for Docker image convertion benchmark test for Singularity and LPMX. It is also included inside the exported box.
## Notice:
All these experiment scripts are updated and available at [https://github.com/JasonYangShadow/experiment_attachments](https://github.com/JasonYangShadow/experiment_attachments), make sure receiving the latest version from the Github repository. 

