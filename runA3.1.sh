kind create cluster --name kind-1 --config ./k8s/kind/cluster-config.yaml

cd ./k8s/manifests
kind load docker-image a12server:v1 --name kind-1
kubectl apply -f ./backend-deploy.yaml
kubectl apply -f ./backend-service.yaml
kubectl apply -f ./ingress-deployment.yaml

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl -nkube-system edit deploy/metrics-server
kubectl -nkube-system rollout restart deploy/metrics-server
echo "wait for metrics server to finish restarting"
sleep 60

kubectl get deploy,svc -n kube-system
kubectl apply -f ./autoscaling.yaml
echo "wait for hpa to deploy"
sleep 30
kubectl describe hpa

kubectl port-forward service/backend 8080:8080