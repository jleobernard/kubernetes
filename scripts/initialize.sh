#!/usr/bin/env bash
set -e

minikube start

my_docker_dir=$(realpath ~/.docker)
path_to_file="$my_docker_dir/config.json"
docker login
kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=$path_to_file \
    --type=kubernetes.io/dockerconfigjson
#docker logout

minikube addons enable ingress

nohup  minikube mount /opt/containers/back-hekima/data:/opt/containers/back-hekima/data &
nohup  minikube mount /opt/containers/back-hekima/logs:/opt/containers/back-hekima/logs &
nohup  minikube mount /opt/data/korean-subs/store:/opt/data/korean-subs/store &
nohup  minikube mount /opt/k8sdata/postgres:/postgresdata &
nohup  minikube mount /opt/containers/postgres/conf:/postgresconf &


kubectl apply -f commons/commons-volumes.yaml

kubectl apply -f postgres/postgres-secret.yaml
kubectl apply -f postgres/postgres-volumes.yaml
kubectl apply -f postgres/postgres.yml

kubectl apply -f clipper/clipper.yaml
minikube service clipper-service
kubectl apply -f clipper/clipper-configmap.yaml

kubectl apply -f notes/notes-volumes.yaml
kubectl apply -f notes/notes-secret.yaml
kubectl apply -f notes/notes.yaml

/opt/leo/kubernetes/scripts/rp.sh