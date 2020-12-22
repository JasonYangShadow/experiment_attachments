# Experiments Attachments For LPMX
This repository contains performance overhead benchmark experiment scripts and results.
To do the experiment, a virtual machine available on Vagrant Cloud [https://app.vagrantup.com/jasonyangshadow/boxes/benchmark_ubuntu1804](https://app.vagrantup.com/jasonyangshadow/boxes/benchmark_ubuntu1804) is needed to reproduce all compared container system candidates. 

## Requirement
1. Vagrant [https://www.vagrantup.com/](https://www.vagrantup.com/)
2. Oracle VM Virtualbox [https://www.virtualbox.org/](https://www.virtualbox.org/)

## To reproduce the experiment environment
open the terminal on your machine and type the following commands:
```
vagrant box add jasonyangshadow/benchmark_ubuntu1804
vagrant init jasonyangshadow/benchmark_ubuntu1804
vagrant up
vagrant ssh
```
Then you are in the virtual machine and all containers used in the experiment are configured and installed properly

A shell script named "installation_benchmark.sh" inside the home directory is used for the package installation performance benchmark test. It contains necessary bash commands for automating the experiment, just run it by the following command:

The time cost for installing packages is evaluated by the **time** command available in the Linux system.
```
cd ~ && ./installation_benchmark.sh
```

Another shell script named "container_creation_benchmark.sh" inside the home directory is used for the container creation benchmark test. It also contains necessary bash commands for automating the experiment.

To run the bash script:
```
cd ~ && ./container_creation_benchmark.sh
```

Besides, all these experiment scripts are updated and available at [https://github.com/JasonYangShadow/experiment_attachments](https://github.com/JasonYangShadow/experiment_attachments), make sure receiving the latest version from the Github repository. 

