#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
INFRA_PATH=$(realpath "${SCRIPT_DIR}/../infrastructure")
ZONE_NAME="contoso.tech"
URI='*'
CMD='kubectl --namespace aks-istio-ingress get service aks-istio-ingressgateway-internal --output jsonpath={.status.loadBalancer.ingress[].ip}'

source ${SCRIPT_DIR}/setup-env.sh

IP_ADDRESS=`az aks command invoke -n ${AKS_NAME} -g ${RG} -o tsv --command "${CMD}" | awk '{print $4}'`
az network private-dns record-set a add-record -g ${RG} -z ${ZONE_NAME} -n "${URI}" -a ${IP_ADDRESS} --verbose
