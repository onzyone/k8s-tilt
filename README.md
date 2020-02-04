# Overview

The goal for this is to setup a local env with a few tools like an ingress controller deployed with helm and hello world app

1. Add a helm chart to the helm folder. I have added a stable folder too to indecate the state of the chart, this allows you to the have an incubator or test folder too.
1. Each demo app has its own folder and there is a Tiltfile located in there ... as well as a main Tiltfile at the root of this repo

# Table of Contents
<!--ts-->
  * [Overview](#Overview)
  * [Table of contents](#Table-of-Contents)
  * [Usage](#Usage)
    * [Start](#Start)
    * [Stop](#Stop)  
  * [Demos](#Demos)
  * [Troubleshooting](#Troubleshooting)
  * [Reference Documentation](#Reference-Documentation)
    * [Demo More Reading](#Demo-More-Reading)
  * [Dependency](#Dependency)
<!--te-->
# Usage
1. In the main Tiltfile there is a group of settings objects
   * `settings` is used to select what base infra to deploy, such as metallb, ambassador, valut, consul, etc
   * `demo_settings` is used to select what demo app you want to deploy
1. *note* that helm tempates are converted into yaml and a kubectl apply is run on the yaml object, ie `helm ls` will not show anything
1. *note* this Tiltfile assumes that you are running a local docker regestriy that is setup by this [kind start script](https://github.com/onzyone/k8s-kind)

## Start
1. Navigate to the root of this repo after you have cloned it and run `tilt up`

## Stop
1. Either navigate to the root of this repo, or `ctr x` out of the tilt consule, and run `tilt down`

# Demos
## Ambassador (Ingress controller)
1. get ingess ip `kubectl get svc --namespace ambassador ambassador -o jsonpath='{.status.loadBalancer.ingress[0].ip}'`
1. if running ambassador edge stack `https://SERVICE_IP/edge_stack_admin/#dashboard`
## Ambassador (Quote App)
1. get ingess ip `INGRESS_IP=$(kubectl get svc --namespace ambassador ambassador -o jsonpath='{.status.loadBalancer.ingress[0].ip}')`
1. check the quote :)  
    ```bash 
    curl -k https://${INGRESS_IP}/quote/
    {
        "server": "cavernous-grapefruit-wqjnlbct",
        "quote": "A small mercy is nothing at all?",
        "time": "2020-02-04T15:21:55.1482125Z"
    }
    ```
## Basic Ingress Demo
1. This demo builds the code located in the `basic-ingress/src` folder with the Dockerfile located in `basic-ingress/`
1. Once the docker build is completed, Tilt will push the image into KIND, and deploy to k8s based on the files located in `basic-ingress/k8s`
1. get ingess ip `INGRESS_IP=$(kubectl get svc --namespace ambassador ambassador -o jsonpath='{.status.loadBalancer.ingress[0].ip}')`
1. check the basicingress :)  
    ```bash 
    curl -k https://${INGRESS_IP}/basicingress/
    <!DOCTYPE html>
    <html>
    <head>
    <title>Basic Ingress Demo</title>
    </head>
    <body>
    <p>The data today is 04-02-2020</p>
    <p>The time right now is 15:30:03</p>
    <p>The pod IP is 10.244.3.5</p>
    </body>
    ```

# Troubleshooting 

1. If you are having issues with local ingress on Mac OS, please look at this: [k8s-kind Troubleshooting](https://github.com/onzyone/k8s-kind#Troubleshooting)
1. If local docker builds are working, but tilt builds are failing. Try to build the image with the following:
  ```bash
   $ tilt docker build .
   Running Docker command as:
   DOCKER_BUILDKIT=1 docker build . 
   ---
   ...
   ```
   * If it still failed, you may need to `export BOCKER_BUILDKIT=0`

# Reference Documentation:

* [kind](https://kind.sigs.k8s.io/) installed
* [Helm Quickstart](https://helm.sh/docs/intro/quickstart/)
* [tilt](https://docs.tilt.dev/) installed
* [ambassador](https://www.getambassador.io/docs/)
* [metallb](https://metallb.universe.tf/)

## Demo More Reading
### Ambassador
* [quote](https://www.getambassador.io/user-guide/getting-started/)
### Vault
* [vault](https://learn.hashicorp.com/vault/getting-started-k8s/sidecar)
* [vault-annotations](https://www.vaultproject.io/docs/platform/k8s/injector/index.html#annotations)
* [injecting-vault-secrets-into-kubernetes-pods-via-a-sidecar](https://www.hashicorp.com/blog/injecting-vault-secrets-into-kubernetes-pods-via-a-sidecar/)
### consul
* [consul kubernetes minikube](https://learn.hashicorp.com/consul/kubernetes/minikube)

# Dependency

1. linux vm
1. docker installed, as well as the ability to pull images from the internet
1. [kind](https://kind.sigs.k8s.io/) installed
  * If you want a kind quick start you can look at my other repo: [k8s-kind](https://github.com/onzyone/k8s-kind) 
1. k8s tools (kubectl, helm 3 or greater)
1. [tilt](https://docs.tilt.dev/) installed
