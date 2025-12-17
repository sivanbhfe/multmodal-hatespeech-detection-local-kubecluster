#!/bin/bash
set -e

curl -sfL https://get.k3s.io | sh -

chmod 644 /etc/rancher/k3s/k3s.yaml

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install Argo CD
kubectl create namespace argocd
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Install External Secrets
helm repo add external-secrets https://charts.external-secrets.io
helm repo update
helm install external-secrets \
  external-secrets/external-secrets \
  -n external-secrets \
  --create-namespace
