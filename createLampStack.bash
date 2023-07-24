#!/bin/bash

export RESOURCE_GROUP_NAME=wisResourceGroup
export LOCATION=eastus
export VM_NAME=wisLamp
export VM_IMAGE=Ubuntu2204
export ADMIN_USERNAME=wissuper

az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

az vm create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $VM_NAME \
    --image $VM_IMAGE \
    --admin-username $ADMIN_USERNAME \
    --generate-ssh-keys \
    --public-ip-sku Standard

export IP_ADDRESS=$(az vm show --show-details --resource-group $RESOURCE_GROUP_NAME --name $VM_NAME --query publicIps --output tsv)

az vm open-port --port 80 --resource-group $RESOURCE_GROUP_NAME --name $VM_NAME

#ssh $ADMIN_USERNAME@$IP_ADDRESS -oStrictHostKeyChecking=no

export SCRIPT_NAME=customScript

az vm extension set \
  --resource-group $RESOURCE_GROUP_NAME \
  --vm-name $VM_NAME \
  --name $SCRIPT_NAME \
  --publisher Microsoft.Azure.Extensions \
  --settings '{"commandToExecute": "apt-get update && apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql"}'