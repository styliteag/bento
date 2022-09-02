#!/bin/sh

cd packer_templates/ubuntu

packer build -var-file=../../../stynux-vmware-cluster-10.30.4.10.json  -force ubuntu-22.04-amd64-vsphere.json
packer build -var-file=../../../stynux-vmware-cluster-10.30.4.10.json  -force ubuntu-20.04-amd64-vsphere.json
packer build -var-file=../../../stynux-vmware-cluster-10.30.4.10.json  -force ubuntu-18.04-amd64-vsphere.json
packer build -var-file=../../../stynux-vmware-cluster-10.30.4.10.json  -force ubuntu-16.04-amd64-vsphere.json
