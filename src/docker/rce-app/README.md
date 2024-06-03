# rce_app

## What does it do?

App exposes HTTP endpoint `/run` which allows executing commands on the container

## How to run?

#### Build docker image (run inside the rce_app directory)

`docker build -t vuln_app:1.0 .`

#### Deploy

`kubectl create ns dev`
`kubectl apply -f rce_app.pod.yaml`

#### Test

Manual special characters encoding:

`curl "http://vuln-app-svc.dev.svc.cluster.local:6000/run?cmd=ls%20-la"`

Auto special characters encoding:

`curl -G "http://vuln-app-svc.dev.svc.cluster.local:6000/run" --data-urlencode "cmd=ls -la"`