minikube stop
ps -ef | grep 'minikube mount' | grep -v grep  | awk '{print $2}' | xargs kill 