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

Add a helm chart to the helm folder. I have added a stable folder too to indecate the state of the chart, this allows you to the have an incubator or test folder too.

## Start

# Troubleshooting 

# Reference Documentation:

* [Helm Quickstart](https://helm.sh/docs/intro/quickstart/)

# Dependency

1. linux vm
1. docker installed, as well as the ability to pull images from the internet
1. [kind](https://kind.sigs.k8s.io/)
  * If you want a kind quick start you can look at my other repo: [k8s-kind](https://github.com/onzyone/k8s-kind) 
1. k8s tools (kubectl, helm 3 or greater)
