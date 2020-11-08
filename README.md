# ansible-adsb
 
This repository hosts [ansible](https://www.ansible.com) playbooks for deploying a full ADSB re-streaming site to various ADSB websites in to a [rancher](https://rancher.com) kubernetes cluster. Most of the focus is on deploying the workloads, however, there are included roles and playbooks for starting up the server nodes from scratch, deploying rancher, as well as a few useful and or fun workloads to deploy that aren't ADSB related.

A special thank you to [mikenye](https://github.com/mikenye) for his fantastic ADSB docker images, as well as [geerlingguy](https://github.com/geerlingguy) for his excellent [ansible for devops](https://github.com/geerlingguy/ansible-for-devops) youtube series and [turing pi](https://github.com/geerlingguy/turing-pi-cluster) series, from which I drew major inspiration to even try this.

Tested and working on:

* `aarch64` (`arm64v8`) platform (Raspberry Pi 4/3B+) and ubuntu arm64 OS 20.04

Should work on:

* `x86_64` (`amd64`) platform
* `armv7l` (`arm32v7`) platform (Raspberry Pi 3B+) running 32 bit raspian or ubuntu 32 bit arm os.

## Table of Contents

* [fredclausen/ansible-adsb](#ansible-adsb)
  * [Table of Contents](#table-of-contents)
  * [Workloads](#workloads)
  * [Prerequisites](#prerequisites)

## Workloads

Below is a list of workloads that can be deployed in to the cluster. Each workload can be individually turned off if you decide you don't want to install it in to the cluster via the `group_vars/all.yaml` file. This will be discussed further in the [config](#config) section.

* ADSB
  * | Workload | Type |
    | [asbdexchange](https://github.com/mikenye/docker-adsbexchange) | Feeder |
    | [adsbhub](https://github.com/mikenye/docker-adsbhub) | Feeder |