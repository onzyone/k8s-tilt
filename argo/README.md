Argo

https://github.com/argoproj/argo-helm

*note* that Argo currently can't run in KIND: https://github.com/kubernetes-sigs/kind/issues/1002

You would have to spin out a minikube local to test this ... (This project currently assumes KIND)

I am trying to get Arog to run with Ambassador ingress, so there is a `k8s/ui-mapping.yaml` to apply ui ingress mapping config

*note* to get the ui working, you have to update the `argo/templates/ui-deployment.yaml` line 52
```bash
  - name: BASE_HREF
    value: /tilt-argo-ui/
```