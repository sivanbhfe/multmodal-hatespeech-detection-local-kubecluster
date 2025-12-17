#!/bin/bash
set -e

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

echo "Creating namespaces..."
kubectl create namespace argocd || true
kubectl create namespace external-secrets || true

echo "Installing Argo CD..."
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for Argo CD to be ready..."
kubectl wait --for=condition=Available deployment/argocd-server \
  -n argocd --timeout=300s

echo "Exposing Argo CD via NodePort..."
kubectl patch svc argocd-server -n argocd \
  -p '{"spec": {"type": "NodePort"}}'

echo "Installing External Secrets Operator..."
helm repo add external-secrets https://charts.external-secrets.io
helm repo update

helm install external-secrets \
  external-secrets/external-secrets \
  -n external-secrets \
  --create-namespace || true

echo "Argo CD and External Secrets installed successfully."
