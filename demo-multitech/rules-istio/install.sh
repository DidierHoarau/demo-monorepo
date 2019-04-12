#!/bin/bash

# See: [https://istio.io/docs/setup/kubernetes/install/helm/]

# kubectl create namespace istio-system
# helm template install/kubernetes/helm/istio-init --name istio-init --namespace istio-system | kubectl apply -f -
# kubectl get crds | grep 'istio.io\|certmanager.k8s.io' | wc -l
helm template install/kubernetes/helm/istio \
    --name istio \
    --namespace istio-system \
    --set gateways.istio-ingressgateway.type=NodePort \
    \
    --set gateways.istio-ingressgateway.ports[0].name=http2 \
    --set gateways.istio-ingressgateway.ports[0].targetPort=80 \
    --set gateways.istio-ingressgateway.ports[0].port=80 \
    \
    --set gateways.istio-ingressgateway.ports[1].name=https \
    --set gateways.istio-ingressgateway.ports[1].targetPort=443 \
    --set gateways.istio-ingressgateway.ports[1].port=443 \
    \
    --set gateways.istio-ingressgateway.ports[2].name=tcp \
    --set gateways.istio-ingressgateway.ports[2].targetPort=33400 \
    --set gateways.istio-ingressgateway.ports[2].port=33400 \
    | kubectl apply -f -

kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=prometheus -o jsonpath='{.items[0].metadata.name}') 9090:9090 
