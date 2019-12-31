# TOOD: Add this to an include so that it will be common for each app

# TODO only intall metallb if running in a local env like kind (metallb is used for a local LB)
print('Installing metallb')
yaml = helm(
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
k8s_yaml(yaml)
k8s_yaml('helm-values/metallb/km-config.yaml')

print('Installing Ambassador')
yaml = helm(
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
k8s_yaml(yaml)

print('Installing App')
# HACK: load namespaces on `tilt up` but not on `tilt down`
# this is taken from: https://github.com/windmilleng/tilt/blob/master/integration/Tiltfile
load_namespace = not os.environ.get('SKIP_NAMESPACE', '')
if load_namespace:
  k8s_yaml('k8s/namespace.yaml')

docker_build('oneup', '.')
k8s_yaml('k8s/oneup.yaml')
k8s_resource('oneup', port_forwards=8100)