# TOOD: Add this to an include so that it will be common for each app

# note that helm tempates are converted into yaml and a kubectl apply is run on the yaml object, ie `helm ls` will not show anything

# TODO only install metallb only if running in a local env like kind (metallb is used for a local LB)
print('Installing metallb')
yaml_metallb = helm(
  'charts/stable/metallb',
  # The release name, equivalent to helm --name
  name='tilt-metallb',
  # The namespace to install in, equivalent to helm --namespace
  namespace='default',
  # The values file to substitute into the chart.
  values=['./helm-values/metallb/values-local.yaml'],
  # Values to set from the command-line
  # set=['service.port=1234', 'ingress.enabled=true']
  )
k8s_yaml(yaml_metallb)
k8s_yaml('helm-values/metallb/km-config.yaml')

print('Installing Ambassador')
yaml_ambassador = helm(
  'charts/stable/ambassador',
  # The release name, equivalent to helm --name
  name='tilt-ambassador',
  # The namespace to install in, equivalent to helm --namespace
  namespace='default',
  # The values file to substitute into the chart.
  values=['./helm-values/ambassador/values-local.yaml'],
  # Values to set from the command-line
  # set=['service.port=1234', 'ingress.enabled=true']
  )
k8s_yaml(yaml_ambassador)

print('Installing vault')
yaml_vault = helm(
  'charts/stable/vault-helm',
  # The release name, equivalent to helm --name
  name='tilt-vault-helm',
  # The namespace to install in, equivalent to helm --namespace
  namespace='vault',
  # The values file to substitute into the chart.
  values=['./helm-values/vault-helm/values-local.yaml'],
  )
k8s_yaml(yaml_vault)

print('Init Vault')
local_resource('vault-init', cmd='vault-demo/sbin/vault-local.sh', resource_deps=['tilt-vault-helm'])

print('Installing vault demo app')
k8s_yaml('vault-demo/k8s/app.yaml')

print('Installing consul')
yaml_consul = helm(
  'charts/stable/consul-helm',
  # The release name, equivalent to helm --name
  name='tilt-consul-helm',
  # The namespace to install in, equivalent to helm --namespace
  namespace='consul',
  # The values file to substitute into the chart.
  values=['./helm-values/consul-helm/values-local.yaml'],
  )
k8s_yaml(yaml_consul)

# oneup app with no ingress, just port mapping
print('Deplying the oneup app')
# HACK: load namespaces on `tilt up` but not on `tilt down`
# this is taken from: https://github.com/windmilleng/tilt/blob/master/integration/Tiltfile
load_namespace = not os.environ.get('SKIP_NAMESPACE', '')
if load_namespace:
  k8s_yaml('oneup/k8s/namespace.yaml')

docker_build('oneup', './oneup')
k8s_yaml('oneup/k8s/oneup.yaml')
k8s_resource('oneup', port_forwards=8100)

# ambassador tour example
k8s_yaml('ambassador-tour/k8s/tour.yaml')

# basic go app that returns Data, Time and IP address using Ambassador as ingress
print('Deplying the basic-ingress app')
# The name of the image here needs to match what is in your deployment.yaml file
docker_build('basicingress-ui', './basic-ingress')
k8s_yaml('basic-ingress/k8s/deployment.yaml')
k8s_yaml('basic-ingress/k8s/service.yaml')
# TODO: there is a error related to CRD's, I am not sure how to get tilt to pull in other schemas right now
# k8s_yaml('basic-ingress/k8s/ingress.yaml')
# Uncomment to let tilt created a portforward to the service for debuggging
# k8s_resource('basicingress', port_forwards=8101)