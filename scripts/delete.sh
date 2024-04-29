#!/bin/sh

#1 Delete namespaces with resources

echo "Deleting namespaces..."

kubectl delete ns mt-development

kubectl delete ns mt-monitor

echo "Namespaces deleted!"