#!/bin/bash

# Generate manifests for deployment on Kubernetes
# A tag name _must_ be supplied as the first argument
# For example: hack/release-yaml.sh v0.1.3

TAG=$1

if [ -z "$TAG" ]
then
    echo "Tag name to release must be supplied as the first argument"
    echo "e.g. $ hack/release-yaml.sh v0.1.3"
fi

RELEASES="pkg/linode-bs/deploy/releases/"
TAGGED_RELEASE="linode-blockstorage-csi-driver-${TAG}.yaml"
GENERIC_RELEASE="linode-blockstorage-csi-driver.yaml"

for manifest in pkg/linode-bs/deploy/kubernetes/0*; do
	echo "# $manifest"
	sed -e "s|{{ .Values.image.tag }}|${TAG}|" "$manifest"
	echo -e "\n---"
done > "$RELEASES/$TAGGED_RELEASE"
cp "$RELEASES/$TAGGED_RELEASE" "$RELEASES/$GENERIC_RELEASE"
