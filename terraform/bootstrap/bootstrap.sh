#!/bin/bash
set -e

echo "Installing k3s..."
curl -sfL https://get.k3s.io | sh -

sleep 20

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
chmod 644 /etc/rancher/k3s/k3s.yaml

echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "Installing Argo CD..."
kubectl create namespace argocd || true
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for Argo CD..."
kubectl rollout status deployment/argocd-server -n argocd --timeout=300s

echo "Exposing Argo CD via NodePort..."
kubectl patch svc argocd-server -n argocd \
  -p '{"spec": {"type": "NodePort"}}'
