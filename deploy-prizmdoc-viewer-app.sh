#!/bin/sh
set -ex

kubectl create ns prizmdoc
kubectl apply --filename ./prizmdoc-viewer-app --namespace prizmdoc
