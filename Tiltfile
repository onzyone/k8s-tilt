# TOOD: Add this to an include so that it will be common for each app

# note that helm tempates are converted into yaml and a kubectl apply is run on the yaml object, ie `helm ls` will not show anything

# TODO only install metallb only if running in a local env like kind (metallb is used for a local LB)
print('Installing metallb')

# this will deploy with helm, need to put a switch in place to check for start / stop 
# start:
# local("helm install -f helm-values/metallb/values-local.yaml tilt-metallb stable/metallb")
# if change:
# local("helm upgrade -f helm-values/metallb/values-local.yaml tilt-metallb stable/metallb")
# if stop:
# local("helm install -f helm-values/metallb/values-local.yaml tilt-metallb stable/metallb")

yaml_metallb = helm(
  'charts/stable/metallb',
  # The release name, equivalent to helm --name
  name='tilt-metallb',
  # The namespace to install in, equivalent to helm --namespace
  namespace='default',
  # The values file to substitute into the chart.
  values=['./helm-values/metallb/values-local.yaml'],
  )
k8s_yaml(yaml_metallb)
watch_file('charts/stable/metallb')
watch_file('./helm-values/metallb/values-local.yaml')

# this is needed to ensure that 
k8s_yaml('helm-values/metallb/km-config.yaml')

print('Installing Ambassador')
# See above ^^
# local("helm install -f helm-values/ambassador/values-local.yaml tilt-ambassador stable/ambassador")

yaml_ambassador = helm(
  'charts/stable/ambassador',
  # The release name, equivalent to helm --name
  name='tilt-ambassador',
  # The namespace to install in, equivalent to helm --namespace
  namespace='ambassador',
  # The values file to substitute into the chart.
  values=['./helm-values/ambassador/values-local.yaml'],
  )
k8s_yaml(yaml_ambassador)
watch_file('charts/stable/ambassador')
watch_file('./helm-values/ambassador/values-local.yaml')

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
watch_file('charts/stable/vault-helm')
watch_file('./helm-values/vault-helm/values-local.yaml')

print('Init Vault')
local_resource('vault-init', cmd='vault-demo/sbin/vault-local.sh', resource_deps=['tilt-vault-helm'])

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
watch_file('charts/stable/consul-helm')
watch_file('./helm-values/consul-helm/values-local.yaml')
