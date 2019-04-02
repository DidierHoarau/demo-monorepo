#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${SCRIPT_DIR}

kubectl -n dev-env get all | grep nats | cut -f1 -d" " | xargs kubectl -n dev-env delete

../../start-service-kubernetes.sh .

sleep 15

kubectl -n dev-env logs $(kubectl -n dev-env get pods | grep nats | head -n1 | cut -f1 -d" ") demo-multitech-nats-node -f 
