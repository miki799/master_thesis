# MASTER_THESIS

## Description

This project is a part of my diploma thesis. It is an simple application used for testing Kubernetes security mechanisms (Security Context, Network Policies, Pod Security Admission, RBAC, Audit logging) and open source security tools like Falco and Kubesec.  

Used Kubernetes version: 1.29.2 

## Architecture

![architecture_diagram](/docs/App_architecture_eng.png)

## How to run?

K8s kind cluster can be created with script `create_cluster`. It can create two kinds of clusters: `secured` and `basic`. The main diffrences is that `secured` one contains config needed for audit logs and Pod Security Admission. This script besides creating cluster, installs also Calico (CNI plugin) and loads app Docker images if they are present on the user machine.

With `deploy_app` script you can deploy app in two modes: `basic` or `secured`. `secured` deploys app with extra configured security mechanism and `basic` deploys only App Pods with few necessary resources. Falco is deployed in both modes.

Below are basic set of commands for running cluster and deploying app:

```bash
# Creating/deleting of secured cluster and app

$ create_cluster secured

$ build_images # can be done before or after creating cluster

$ deploy_app secured

...

$ clean_up

$ delete_cluster
```

```bash
# Creating basic kind cluster and deploying basic app

$ build_images

$ create_cluster basic

$ deploy_app basic
```

## Repository Structure

This document describes the structure of the repository.

### `/docs`

Contains rules, descriptions and diagrams.

### `/scan_results`

Contains scan results done with configured tools.

### `/scripts`

Contains needed scripts (only zsh) for using app.

- `/docker`: scripts for handling app and tools Docker images
  - `build_images.zsh`: builds all images. App images are loaded to the kind k8s cluster (if it runs)
  - `delete_images.zsh`: deletes every image

- `/k8s`: scripts used for deploying app in the kind k8s cluster
  - `clean_up.zsh`: deletes app namespaces, artifacts (certs and keys) and k8s users from kubeconfig
  - `create_kubeconfig.zsh`: creates kubeconfig with specified values
  - `deploy_app.zsh`: deploys secured or basic (without security mechanisms) app
  - `deploy_falco.zsh`: deploys Falco in dev namespace. It is already called in deploy_app script
  - `export_audit_logs.zsh`: exports audit logs and saves them to `artifacts\logs` directory
  - `users.zsh`: creates k8s users and adds their config to kubeconfig in `~/.kube/config`

- `/kind`: scripts for handling kind k8s cluster
  - `create_cluster.zsh`: creates secured or basic cluster (with or without config needed for Audit logging and Pod Security Admission).
  - `delete_cluster.zsh`: deletes cluster and saves artifacts
  - `export_cluster_logs.zsh`: exports all cluster logs to artifacts

- `/scans`: scripts for using scanning tools
  - `kubebench_scan.zsh`: runs kubebench scan on cluster nodes and saves results to artifacts
  - `kubesec_scan.zsh`: scans app Pods yaml manifests with kubesec installed on docker container
  - `trivy_images_scan.zsh`: scans app docker images for vulnerabilities and saves results to artifacts

- `init_aliases.zsh`: contains useful aliases to scripts
- `variables.zsh`: contains global variables used by other scripts

### `/src`

Contains the main source code / config for the project.

- `/docker`: Dockerfiles and code of application components and utilities
  - `/alpine-dev`: Sends http request to the nginx server

  - `/vuln-app`: Web app with RCE vulnerability written in Flask

  - `/nginx`, `/nginx_unprivileged`: NGINX HTTP servers serving static HTML file

  - `/kubesec`: utility image for running Kubesec analysis

- `/k8s`: Kubernetes resources YAML manifests used for deploying application and tests

  - ``/attacks`` - YAMLs defining resources used for simulating attacks

  - `/tests` - YAMLs defining resources used for security mechanisms tests

  - `/secured_app` - YAMLs for deploying app with security mecahanisms
    - `/alpine-dev` - YAML with resources used for deploying `alpine-dev` app component
    - `/api-server` - resources used for configuring etcd encryption at rest [FINALLY_NOT_USED]
    - `/audit-policy` - audit logging configuration
    - `/falco_rules` - Falco custom rules configuration
    - `/network-policies` - Application Network Policies
    - `/pod-security-admission` - Pod Security Admission configuration
    - `/rbac` - Role-Based Access control configuration YAMLs

  - `/vulnerable_app` - YAMLs for deploying app without security mecahanisms
    - `/alpine-dev` - YAML with resources used for deploying `alpine-dev` app component
    - `/nginx` - YAML with resources used for deploying `nginx` app component
    - `/vuln-app` - YAML with resources used for deploying `vuln-app` app component

  - `namespaces.yaml` - describes app namespaces

## Tools

- [Helm](https://helm.sh/) - package manager for k8s

- [Calico](https://github.com/projectcalico/calico) - CNI plugin

- [kubesec](https://kubesec.io/) - for manifests static analysis

- [Falco](https://falco.org/) - k8s and syscall real time security events detection

- [Trivy](https://github.com/aquasecurity/trivy) - for images vulnerabilites scanning [FINALLY_NOT_USED]

- [kube-bench](https://github.com/aquasecurity/kube-bench) - for k8s cluster security scan [FINALLY_NOT_USED]