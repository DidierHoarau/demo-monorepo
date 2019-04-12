#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${SCRIPT_DIR}"

export ENV=dev

kubectl -n ${ENV}-env get gateway | grep demo-multitech | cut -f1 -d" " | xargs kubectl -n ${ENV}-env delete gateway 
kubectl -n ${ENV}-env get virtualservice | grep demo-multitech | cut -f1 -d" " | xargs kubectl -n ${ENV}-env delete virtualservice 

export INGRESS_HOST=$(kubectl get po -l istio=ingressgateway -n istio-system -o jsonpath='{.items[0].status.hostIP}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')

kubectl -n ${ENV}-env apply -f gateway.yaml