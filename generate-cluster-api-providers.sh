#!/bin/bash

# https://github.com/kubernetes-sigs/cluster-api/releases/ 
cluster_api_version="v1.9.6"
# https://github.com/kubernetes-sigs/cluster-api-ipam-provider-in-cluster/releases/
ipam_incluster_version="v1.0.2"
# https://github.com/ionos-cloud/cluster-api-provider-proxmox/releases/
capmox_version="v0.7.1"

# the documentation expects you to run `clusterctl init`, which has no option to output
# manifests to stdout or anywhere other than straight onto the cluster
# we use `clusterctl generate`, which works similarly, but acutally outputs the resources
# the manifests clusterctl will download and apply are published on each release
# https://github.com/kubernetes-sigs/cluster-api/releases

clusterctl generate provider --core  cluster-api:${cluster_api_version} --describe
clusterctl generate provider --core  cluster-api:${cluster_api_version} > templates/provider-core/resources.yaml

# currently, these providers live in the cluster-api repo
# https://github.com/kubernetes-sigs/cluster-api/tree/main/bootstrap/kubeadm
clusterctl generate provider --bootstrap  kubeadm:${cluster_api_version} --describe
clusterctl generate provider --bootstrap  kubeadm:${cluster_api_version} > templates/provider-bootstrap-kubeadm/resources.yaml
# https://github.com/kubernetes-sigs/cluster-api/tree/main/controlplane/kubeadm
clusterctl generate provider --control-plane  kubeadm:${cluster_api_version} --describe
clusterctl generate provider --control-plane  kubeadm:${cluster_api_version} > templates/provider-controlplane-kubeadm/resources.yaml

clusterctl generate provider --ipam in-cluster:${ipam_incluster_version} --describe 
clusterctl generate provider --ipam in-cluster:${ipam_incluster_version} >  templates/provider-ipam/resources.yaml

clusterctl generate provider --infrastructure proxmox:${capmox_version} --config secrets/clusterctl-config.yaml --describe
clusterctl generate provider --infrastructure proxmox:${capmox_version} --config secrets/clusterctl-config.yaml > templates/provider-capmox/resources.yaml
