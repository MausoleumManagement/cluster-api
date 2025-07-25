#!/bin/bash


### TEST ###
ARG TERRAFORM_VERSION="1.12.2" # github-tags/hashicorp/terraform&versioning=semver
### TEST ###



# The commented lines should be detected and updated by renovate
# we have to manage the actual assignments ourselves

# https://github.com/kubernetes-sigs/cluster-api/releases/ 
# renovate: datasource=github-releases depName=cluster-api packageName=kubernetes-sigs/cluster-api versioning=semver currentValue=1.9.6
CLUSTER_API_VERSION=1.9.6 # renovate: datasource=github-releases depName=cluster-api packageName=kubernetes-sigs/cluster-api

# https://github.com/kubernetes-sigs/cluster-api-ipam-provider-in-cluster/releases/
# renovate: datasource=github-releases depName=cluster-api-ipam-provider-in-cluster packageName=kubernetes-sigs/cluster-api-ipam-provider-in-cluster versioning=semver currentValue=1.0.2
IPAM_INCLUSTER_VERSION=1.0.2

# https://github.com/ionos-cloud/cluster-api-provider-proxmox/releases/
# renovate: datasource=github-releases depName=cluster-api-provider-proxmox packageName=ionos-cloud/cluster-api-provider-proxmox versioning=semver currentValue=0.7.1
CAPMOX_VERSION=0.7.1

# the documentation expects you to run `clusterctl init`, which has no option to output
# manifests to stdout or anywhere other than straight onto the cluster
# we use `clusterctl generate`, which works similarly, but acutally outputs the resources
# the manifests clusterctl will download and apply are published on each release
# https://github.com/kubernetes-sigs/cluster-api/releases

clusterctl generate provider --core  cluster-api:v${CLUSTER_API_VERSION} --describe
clusterctl generate provider --core  cluster-api:v${CLUSTER_API_VERSION} > ./components/provider-core/resources.yaml

# currently, these providers live in the cluster-api repo
# https://github.com/kubernetes-sigs/cluster-api/tree/main/bootstrap/kubeadm
clusterctl generate provider --bootstrap  kubeadm:v${CLUSTER_API_VERSION} --describe
clusterctl generate provider --bootstrap  kubeadm:v${CLUSTER_API_VERSION} > ./components/provider-bootstrap-kubeadm/resources.yaml
# https://github.com/kubernetes-sigs/cluster-api/tree/main/controlplane/kubeadm
clusterctl generate provider --control-plane  kubeadm:v${CLUSTER_API_VERSION} --describe
clusterctl generate provider --control-plane  kubeadm:v${CLUSTER_API_VERSION} > ./components/provider-controlplane-kubeadm/resources.yaml

clusterctl generate provider --ipam in-cluster:v${IPAM_INCLUSTER_VERSION} --describe 
clusterctl generate provider --ipam in-cluster:v${IPAM_INCLUSTER_VERSION} >  ./components/provider-ipam/resources.yaml

clusterctl generate provider --infrastructure proxmox:v${CAPMOX_VERSION} --config clusterctl-config.yaml --describe
clusterctl generate provider --infrastructure proxmox:v${CAPMOX_VERSION} --config clusterctl-config.yaml > ./components/provider-capmox/resources.yaml
