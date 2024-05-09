# rce_app

## What does it do?

App exposes HTTP endpoint `/execute` which allows executing commands on the container

## How to run?

#### Build docker image (run inside the rce_app directory)

`docker build -t safe_app:1.0 .`

#### Deploy

`kubectl create ns dev`
`kubectl apply -f rce_app.pod.yaml`

#### Test

Manual special characters encoding:

`curl "http://vuln-app-svc.dev.svc.cluster.local:5000/execute?command=ls%20-la"`

Auto special characters encoding:

`curl -G "http://vuln-app-svc.dev.svc.cluster.local:5000/execute" --data-urlencode "command=ls -la"`