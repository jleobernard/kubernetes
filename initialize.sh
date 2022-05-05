#!/usr/bin/env bash
set -e

docker login
kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=/home/debian/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson
docker logout

minikube addons enable ingress

nohup  minikube mount /opt/containers/back-hekima/data:/opt/containers/back-hekima/data &
nohup  minikube mount /opt/containers/back-hekima/logs:/opt/containers/back-hekima/logs &
nohup  minikube mount /opt/data/korean-subs/store:/opt/data/korean-subs/store &


kubectl apply -f commons/commons-volumes.yaml

kubectl apply -f clipper/clipper.yaml

minikube service clipper-service

kubectl apply -f notes/notes-volumes.yaml
kubectl apply -f notes/notes-secret.yaml
kubectl apply -f notes/notes.yaml

minikube service notes-service