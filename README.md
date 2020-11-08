# ansible-adsb
 
This repository hosts [ansible](https://www.ansible.com) playbooks for deploying a full ADSB re-streaming site to various ADSB websites in to a [rancher](https://rancher.com) kubernetes cluster. Most of the focus is on deploying the workloads, however, there are included roles and playbooks for starting up the server nodes from scratch, deploying rancher, as well as a few useful and or fun workloads to deploy that aren't ADSB related.

A special thank you to [mikenye](https://github.com/mikenye) for his fantastic ADSB docker images, as well as [geerlingguy](https://github.com/geerlingguy) for his excellent [ansible for devops](https://github.com/geerlingguy/ansible-for-devops) youtube series and [turing pi](https://github.com/geerlingguy/turing-pi-cluster) series, from which I drew major inspiration to even try this.

Tested and working on:

* `aarch64` (`arm64v8`) platform (Raspberry Pi 4/3B+) and ubuntu arm64 OS 20.04 LTS

Should work on:

* `x86_64` (`amd64`) platform running non-apt based systems, but will require modification to the playbooks.
* `armv7l` (`arm32v7`) platform (Raspberry Pi 3B+) running 32 bit raspian or ubuntu 32 bit arm os.

## Table of Contents

* [fredclausen/ansible-adsb](#ansible-adsb)
  * [Table of Contents](#table-of-contents)
  * [Workloads](#workloads)
    * [ADSB](#adsb)
    * [Fun or Useful](#fun-or-useful)
  * [Prerequisites](#prerequisites)
    * [Initial server setup](#initial-server-setup)
      * [Installing Ansible](#installing-ansible)
      * [Installing kubectl](#installing-kubectl)
      * [Flashing the OS](#flashing-the-os)
      * [Getting your node IPs](#getting-node-ips)
      * [Update the OS and install packages](#update-the-os-and-install-packages)
    * [Rancher setup](#rancher-setup)
  * [Cluster Setup](#cluster-setup)
    * [Configure the new cluster](#configure-the-new-cluster)
  * [ADSB Workload Setup](#adsb-workload-setup)

## Workloads

Below is a list of workloads that can be deployed in to the cluster. Each workload can be individually turned off if you decide you don't want to install it in to the cluster via the `group_vars/all.yaml` file. This will be discussed further in the [config](#config) section.

### ADSB

| Workload | Type |
| ---------|------|
| [asbdexchange](https://github.com/mikenye/docker-adsbexchange) | Feeder |
| [adsbhub](https://github.com/mikenye/docker-adsbhub) | Feeder |
| [dump978](https://github.com/mikenye/docker-dump978) | RTLSDR Decoder |
| [fr24/flightradar24](https://github.com/mikenye/docker-flightradar24) | Feeder |
| [influxdb](https://hub.docker.com/_/influxdb) | Database |
| [mlat](https://github.com/mikenye/docker-readsb-protobuf) | Local data aggregator |
| [opensky](https://github.com/mikenye/docker-opensky-network) | Feeder |
| [plane finder](https://github.com/mikenye/docker-planefinder) | Feeder |
| [readsb-proto-buf](https://github.com/mikenye/docker-readsb-protobuf) | RTLSDR Decoder / Statistics collection / Statistics Visualization / Map visualization of targets |
| [tar1090](https://github.com/mikenye/docker-tar1090) | Map visualization of targets |

## Fun or Useful

| Workload | Type |
| ---------|------|
| cloudflared | DNS encryption |
| pihole | DNS ad filtering |
| guac | Server management interfaces (SSH, remote desktop, etc) |
| nut | UPS management for cluster notes |
| transmission | torrent client |

## Prerequisites

Download this repository or git clone to your local system to get started.

Re-name `group_vars/all.template.yaml` to `group_vars/all.yaml`

These playbooks are designed to run against a kubernetes cluster. This cluster could be running k8s, k3s, or Rancher rke. If you don't have a cluster installed, we'll cover how to use this repository's files to set up rancher (and eventually, when I test it out, k3s too!) but keep in mind rancher cannot run on ARM32, and it is basically unusuably on Pi3B+ due to the limits of the 3B+ hardware. k3s should be your choice if you do not have at a minimum Pi4s.

If you have a working cluster that can accessed using a local instance of kubectl, and ansible installed, head on down to [ADSB Workload Setup](#adsb-workload-setup). If not, read on!

#### Installing Ansible

Head on over to [ansible's documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) to find directions on installing ansible for your system. Note, this needs to be installed on your computer, not on any of the nodes you will be setting up for the cluster!

#### Installing kubectl

Head on over to [kubernete's site](https://kubernetes.io/docs/tasks/tools/install-kubectl/) for directions on installing kubectl for your system. Note, this needs to be installed on your computer, not on any of the nodes you will be setting up for the cluster!

#### Flashing the OS

For ARM based systems that can run ARM64 (Pi3B+ and Pi4) I STRONGLY recommend ARM64 based operating systems such as [ubuntu's ARM64 server](https://ubuntu.com/download/server/arm).

To flash the image on to an SD card, see the [other tools](https://www.raspberrypi.org/documentation/installation/installing-images/) at that link. Balena Etcher is great and very easy.

For other architectures follow the install guide for your distribution of linux. Server distros are strongly recommended.

#### Getting the node IPs

Now its time to start some configuration. Plug in your Pi's SD cards, power on your VMs, or otherwise turn on your nodes and ensure they are connected to your network.

Google around if you need help, but generally, you can look in your router's web interface for the most basic way of getting the IPs of all of the nodes.

Please, ensure at a bare minimum the node you intend to be the `master node` has a static IP assigned. I recommend all of the nodes have static IPs but it isn't strictly speaking necessary.

Now we need to configure the `inventory/inventory` file.

There are four sections here.

`[master]` is the section that will tell ansible what node(s) will be the master node(s). Please input the IP address of the node(s). The playbooks you will run will set the host-name of each of the nodes via the `new_hostname` variable on the same line as the IP address of the node. You can see the format I've used, and while it is not requisite to change the default value I have provided, you can. The name just has to be unique for each node on the cluster.

`[workers]` is the exact same formatting as master above, except that these are the nodes you intend to run as the worker(s).

`[rancher]` is the node that the rancher management interface will be installed on. It should a master node, and only one of the master nodes if you have more than one.

`[nut-master]` and `[nut-slave]` are a list of all of the nodes you want to run the nut UPS management stuff on. Set the IP address of the node that has the UPS plugged in to it under `[nut-master]`, and all of the nodes you intend to monitor the UPS under `[nut-slave]`.

If you do not have a UPS, or do not wish to configure it, delete all of the IPs under both headers.

The config files that will be copied to the nodes in command we will run below. Modify the nut config files for the nut-server and nut-slave under roles/nut-(master/slave)/files to suit your configuration.


#### Update the OS and install packages

Now it is time to prepare the system for the cluster, and we will do that by updating it, ensuring the hardware configuration for docker is correct, actually installing docker, and finally, installing rancher. 

Open a terminal window and `cd` in to the directory containing the repository.

Issue the following command

```
ansible-playbook -i inventory/inventory setup-servers.yaml
```

And sit back and wait. Depending on the age of the operating system you installed and the performance of the nodes, this may take a while. Your system will reboot to apply the host-name change and any kernel-updates.

## Cluster Setup

At this point, you should have your nodes all prepared. Let us configure the cluster.

Open your web browser and open it up to `https://your rancher ip you set above:8443`. Go through the initial setup which should all be self explanatory. Default username and password are both `admin`.

### Configure The New Cluster

The first thing we need to do is set up a new cluster. Click `Add Cluster`. If you do not see an `Add Cluster` button at the top right, click global at the very top of the screen. On the next screen, click `Existing Nodes`

We need to change a few configuration options here. 

* Give your cluster a name under `Cluster Name`.

* Under `Kubenetes Options` change `Network Provider` to `Flannel`.

* Under `Advanced Options` change `Nginx Ingress` to `Disabled`.

* On the next screen we have some values we need to save to `group_vars/all.yaml`.

* Copy the value after `--token` to the `rancher_token` variable.

* Copy the value after `--ca-checksum` to the `rancher_checksum` variable.

* Copy the value after `--server` to the `rancher_server` variable.

* Save all.yaml.

Click `Next`

## ADSB Workload Setup