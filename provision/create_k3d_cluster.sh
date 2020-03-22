#!/bin/sh

cluster_name="$1"
public_ip="$2"

# setup k3d
curl -s https://raw.githubusercontent.com/rancher/k3d/master/install.sh | bash

# start server node
#	--enable-registry --registry-name docker.registry --registry-volume registry --registries-file ./registry.yml \
k3d create \
	--name "$cluster_name" \
	--auto-restart \
	--workers 0 \
	--server-arg "--no-deploy=traefik" \
	--server-arg "--no-deploy=local-storage" \
	--server-arg "--no-deploy=metrics-server" \
	--server-arg "--tls-san=$public_ip" \
	--publish "443:444" \
	--api-port 6443 \
	--wait 0
