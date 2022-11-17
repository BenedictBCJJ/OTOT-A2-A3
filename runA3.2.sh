kind create cluster --name kind-1 --config ./k8s/kind/cluster-config.yaml
kubectl cluster-info
docker ps

cd ./k8s/manifests
kind load docker-image a12server:v1 --name kind-1
kubectl apply -f ./backend-zone-aware.yaml
echo "wait for zone aware to finish deployment"
sleep 30
kubectl get deployment/backend

kubectl apply -f ./backend-service.yaml
kubectl get svc

kubectl apply -f ./ingress-deployment.yaml
kubectl get ingress

kubectl port-forward service/backend 8080:8080