#!/bin/bash

# https://github.com/kube-vip/kube-vip
KVVERSION=v0.9.2

docker run --network host --rm ghcr.io/kube-vip/kube-vip:$KVVERSION manifest pod \
    --address 192.168.10.11 \
    --controlplane \
    --leaderElection \
    --services \
    --servicesElection true \
    --arp
