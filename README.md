# Overview

The goal for this is to setup a local env with a few tools like an ingress controller deployed with helm and hello world app

# Table of contents
=================
<!--ts-->
   * [Overview](#Overview)
   * [Table of contents](#table-of-contents)
   * [Usage](#usage)
      * [Start](#Start)
   * [Troubleshooting](#Troubleshooting)
   * [Reference Documentation](#Reference-Documentation)
   * [Dependency](#dependency)
<!--te-->
=================

# Usage

1. Add a helm chart to the helm folder. I have added a stable folder too to indecate the state of the chart, this allows you to the have an incubator or test folder too.
1. Add an app, in this example `basic-ingress`(basic go app), `oneup` ([from tilt examples](https://github.com/windmilleng/tilt/tree/master/integration/oneup)), and `ambassador-tour` ([from ambassador examples](https://www.getambassador.io/user-guide/getting-started/))
1. vault demo is based off this page: [injecting-vault-secrets-into-kubernetes-pods-via-a-sidecar](https://www.hashicorp.com/blog/injecting-vault-secrets-into-kubernetes-pods-via-a-sidecar/)
1. consul deploy is based off this page: [consul kubernetes minikube](https://learn.hashicorp.com/consul/kubernetes/minikube)

## Start

1. *note* that helm tempates are converted into yaml and a kubectl apply is run on the yaml object, ie `helm ls` will not show anything
1. Navigate to the root of this repo after you have cloned it and run `tilt up`

## Load Balancer

1. get the lb's (currently there should be two, one for consul and one for services behind ambassador)
1. ```bash 
   $ kubectl get services -A | grep -i loadbalancer
   consul        tilt-consul-helm-consul-ui                     LoadBalancer   10.104.97.99     172.17.255.1   80:31878/TCP                                                              35m
   default       tilt-ambassador                                LoadBalancer   10.98.106.110    172.17.255.2   80:31181/TCP,443:31665/TCP                                                35m
   ```
1. open your fav web client and past in the consul external ip. At the url root, you will see consul
1. open your fav web client and past in the ambassador external ip. At the root, you should see the `ambassador tour` app. At http://<ip>/basicingress, you should see the `basic-ingress` app

# Troubleshooting 

1. If you are having issues with local ingress on Mac OS, please look at this: [k8s-kind Troubleshooting](https://github.com/onzyone/k8s-kind#Troubleshooting)

# Reference Documentation:

* [kind](https://kind.sigs.k8s.io/) installed
* [Helm Quickstart](https://helm.sh/docs/intro/quickstart/)
* [tilt](https://docs.tilt.dev/)
* [ambassador](https://www.getambassador.io/docs/)
* [metallb](https://metallb.universe.tf/)

# Dependency

1. linux vm
1. docker installed, as well as the ability to pull images from the internet
1. [kind](https://kind.sigs.k8s.io/) installed
  * If you want a kind quick start you can look at my other repo: [k8s-kind](https://github.com/onzyone/k8s-kind) 
1. k8s tools (kubectl, helm 3 or greater)
1. [tilt](https://docs.tilt.dev/) installed
