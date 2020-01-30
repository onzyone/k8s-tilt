# note that helm tempates are converted into yaml and a kubectl apply is run on the yaml object, ie `helm ls` will not show anything

# TODO move these to config files
settings = {
  "start_kind": False,
  "preload_images_for_kind": False,
  "deploy_metallb": True,
  "deploy_ambassador_api": False,
  "deploy_ambassador_edge_gateway": True,
  "deploy_vault": False,
  "deploy_consul": False,
}

demo_settings = {
  "deploy_demo_ambassador_tour": True,
  "deploy_demo_argo": False,
  "deploy_demo_basic_ingress": False,
  "deploy_demo_consul_demo": False,
  "deploy_demo_oneup": False,
  "deploy_demo_vault_demo": False,
}

def deploy_metallb():
  # TODO only install metallb only if running in a local env like kind (metallb is used for a local LB)
  if settings.get("preload_images_for_kind"):
    get_images(registry = "docker.io", images = ["metallb/controller:v0.8.3", "metallb/speaker:v0.8.3"])

  print('Installing metallb')

  yaml_metallb = helm(
    'charts/stable/metallb',
    # The release name, equivalent to helm --name
    name='metallb',
    # The namespace to install in, equivalent to helm --namespace
    # if namesapce is updated, update "helm-values/metallb/km-config.yaml" too    
    namespace='metallb',
    # The values file to substitute into the chart.
    values=['./helm-values/metallb/values-local.yaml'],
    )
  k8s_yaml(yaml_metallb)
  watch_file('charts/stable/metallb')
  watch_file('./helm-values/metallb/values-local.yaml')

  # this is needed to ensure that 
  k8s_yaml('helm-values/metallb/km-config.yaml')

def deploy_ambassador_api():
  ## This is Ambassador API Gateway
  if settings.get("preload_images_for_kind"):
    get_images(registry = "quay.io", images = ["datawire/ambassador:0.86.1"])

  print('Installing Ambassador')

  ambassador_crds = listdir("charts/stable/ambassador/crds/")
  for each in ambassador_crds:
    k8s_yaml(each)

  yaml_ambassador = helm(
    'charts/stable/ambassador',
    # The release name, equivalent to helm --name
    name='ambassador',
    # The namespace to install in, equivalent to helm --namespace
    namespace='ambassador',
    # The values file to substitute into the chart.
    values=['./helm-values/ambassador/values-local.yaml'],
    )
  k8s_yaml(yaml_ambassador)

def deploy_ambassador_edge_gateway():
  # This is Ambassador Edge Gateway
  if settings.get("preload_images_for_kind"):
    get_images(registry = "quay.io", images = ["datawire/aes:1.0.0"])

  print('Installing Ambassador Edge Gateway`')

  ambassador_edge_crds = listdir("charts/stable/ambassador-chart/crds/")
  for each in ambassador_edge_crds:
    k8s_yaml(each)

  #TODO findout why this runs before the crd yaml ^^
  #local("kubectl wait --for=condition=established --timeout=500s customresourcedefinition.apiextensions.k8s.io/authservices.getambassador.io")

  yaml_ambassador_edge = helm(
    'charts/stable/ambassador-chart',
    # The release name, equivalent to helm --name
    name='ambassador',
    # The namespace to install in, equivalent to helm --namespace
    namespace='ambassador',
    # The values file to substitute into the chart.
    values=['./helm-values/ambassador-chart/values-local.yaml'],
    )
  k8s_yaml(yaml_ambassador_edge)
  
#  watch_file('charts/stable/ambassador-chart')
#  watch_file('./helm-values/ambassador-chart/values-local.yaml')

def deploy_vault():
  if settings.get("preload_images_for_kind"):
    get_images(registry = "docker.io", images = ["hashicorp/vault-k8s:0.1.1", "vault:1.3.1"])

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

def deploy_consul():
  if settings.get("preload_images_for_kind"):
    get_images(registry = "docker.io", images = ["hashicorp/consul-k8s:0.10.1", "consul:1.6.2"])

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


def get_images(registry, images):
  for image in images:
      local("docker pull {}/{}".format(registry, image))
      local("kind load docker-image {}/{}".format(registry, image))

def start_kind():
  print('what a great idea')

##############################
# Actual work happens here
##############################

if settings.get("start_kind"):
  start_kind()

if settings.get("deploy_metallb"):
  deploy_metallb()

if settings.get("deploy_ambassador_api"):
  deploy_ambassador_api()

if settings.get("deploy_ambassador_edge_gateway"):
  deploy_ambassador_edge_gateway()

if settings.get("deploy_vault"):
  deploy_vault()
  
if settings.get("deploy_consul"):
  deploy_consul()

##############################
# demo apps
##############################

if demo_settings.get("deploy_demo_ambassador_tour"):
  include("ambassador-tour/Tiltfile")

if demo_settings.get("deploy_demo_argo"):
  include("argo/Tiltfile")

if demo_settings.get("deploy_demo_basic_ingress"):
  include("basic-ingress/Tiltfile")

if demo_settings.get("deploy_demo_consul_demo"):
  include("consule-demo/Tiltfile")

if demo_settings.get("deploy_demo_oneup"):
  include("oneup/Tiltfile")

if demo_settings.get("deploy_demo_vault_demo"):
  include("vault-demo/Tiltfile")

# this will deploy with helm, need to put a switch in place to check for start / stop 
# start:
# local("helm install -f helm-values/metallb/values-local.yaml tilt-metallb stable/metallb")
# if change:
# local("helm upgrade -f helm-values/metallb/values-local.yaml tilt-metallb stable/metallb")
# if stop:
# local("helm uninstall -f helm-values/metallb/values-local.yaml tilt-metallb stable/metallb")
