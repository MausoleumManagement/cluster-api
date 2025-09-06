#!/bin/bash


# the comments next to versions are for renovate, pls keep
# the regex is rather pedantic, so make sure the layout stays the same
# see: renovate.json5

# https://github.com/kubernetes-sigs/cluster-api/releases/ 
CLUSTER_API_VERSION="1.11.0" # github-releases/kubernetes-sigs/cluster-api&versioning=semver

# https://github.com/kubernetes-sigs/cluster-api-ipam-provider-in-cluster/releases/
IPAM_INCLUSTER_VERSION="1.0.3" # github-releases/kubernetes-sigs/cluster-api-ipam-provider-in-cluster&versioning=semver

# https://github.com/ionos-cloud/cluster-api-provider-proxmox/releases/
CAPMOX_VERSION="0.7.4" # github-releases/ionos-cloud/cluster-api-provider-proxmox&versioning=semver

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
