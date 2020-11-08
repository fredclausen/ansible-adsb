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
    * [ADSB](#adsb)
    * [Fun or Useful](#fun-or-useful)
  * [Prerequisites](#prerequisites)
    * [Initial server setup](#initial-server-setup)
    * [Rancher setup](#rancher-setup)
  * [Cluster Setup](#cluster-setup)
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

These playbooks are designed to run against a kubernetes cluster. This cluster could be running k8s, k3s, or Rancher rke. If you have a working cluster that can accessed using a local instance of kubectl, head on down to [ADSB Workload Setup](#adsb-workload-setup). If not, read on!



## Cluster Setup

## ADSB Workload Setup