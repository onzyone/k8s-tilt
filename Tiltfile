# note that helm tempates are converted into yaml and a kubectl apply is run on the yaml object, ie `helm ls` will not show anything

# TODO move these to config files
settings = {
  "deploy_ambassador_api": False,
  "deploy_ambassador_edge_gateway": False,
  "deploy_consul": False,
  "deploy_metallb": False,
  "deploy_vault": False,
  "preload_images_for_kind": False,
  "start_kind": False,
}

demo_settings = {
  "deploy_demo_ambassador_quote": False,
  "deploy_demo_argo": False,
  "deploy_demo_basic_ingress": False,
  "deploy_demo_consul": False,
  "deploy_demo_oneup": True,
  "deploy_demo_polaris": False,
  "deploy_demo_vault": False, # BROKEN
  "deploy_demo_traefik": True,
}

# this assumes that you are running a local registry and your images are been pulled from "localhost:5000"
# example:     'repository: localhost:5000/datawire/ambassador'
# https://github.com/onzyone/k8s-kind#troubleshooting
app_settings = {
  "local_registry": "localhost:5000"
}

def deploy_metallb():
  # TODO only install metallb only if running in a local env like kind (metallb is used for a local LB)
  if settings.get("preload_images_for_kind"):
    get_images(registry = "docker.io", images = ["metallb/controller:v0.9.3", "metallb/speaker:v0.9.3"])

  include("metallb/Tiltfile")

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

  print('Installing Ambassador Edge Gateway')

  # donwload images:
  if settings.get("preload_images_for_kind"):
    get_images(registry = "quay.io", images = ["datawire/aes:1.4.2"])
  local("helm repo add datawire https://www.getambassador.io")
  local("kubectl create ns ambassador")
  #k8s_yaml("./helm-values/ambassador-chart/namespace.yaml")
  local("helm install ambassador --namespace ambassador datawire/ambassador --set image.repository=localhost:5000/datawire/aes --set image.tag=1.4.2")

def deploy_vault():
  print('Installing vault')
  if settings.get("preload_images_for_kind"):
    get_images(registry = "docker.io", images = ["hashicorp/vault-k8s:0.1.1", "vault:1.3.1"])

  k8s_yaml('helm-values/vault-helm/namespace.yaml')

  yaml_vault = helm(
    'charts/stable/vault-helm',
    # The release name, equivalent to helm --name
    name='vault-helm',
    # The namespace to install in, equivalent to helm --namespace
    namespace='vault',
    # The values file to substitute into the chart.
    values=['./helm-values/vault-helm/values-local.yaml'],
    )
  k8s_yaml(yaml_vault)

  watch_file('charts/stable/vault-helm')
  watch_file('./helm-values/vault-helm/values-local.yaml')

  local_resource('vault-init', cmd='vault-demo/sbin/vault-local.sh', resource_deps=['vault-helm'])

def deploy_consul():
  print('Installing consul')
  if settings.get("preload_images_for_kind"):
    get_images(registry = "docker.io", images = ["hashicorp/consul-k8s:0.10.1", "consul:1.6.2"])

  k8s_yaml('helm-values/consul-helm/namespace.yaml')
  yaml_consul = helm(
    'charts/stable/consul-helm',
    # The release name, equivalent to helm --name
    name='consul-helm',
    # The namespace to install in, equivalent to helm --namespace
    namespace='consul',
    # The values file to substitute into the chart.
    values=['./helm-values/consul-helm/values-local.yaml'],
    )
  k8s_yaml(yaml_consul)
  watch_file('charts/stable/consul-helm')
  watch_file('./helm-values/consul-helm/values-local.yaml')

  k8s_yaml("helm-values/consul-helm/ambassador-crd.yaml")

def get_images(registry, images):
  for image in images:
    local_resource('echo {}'.format(registry), cmd='echo %s, %s' % (registry, image))
    local_resource('docker pull {} from internet'.format(image.replace('/','_')), cmd='docker pull {}/{}'.format(registry, image))
    local_resource('docker tag {}'.format(image.replace('/','_')), cmd='docker tag {}/{} {}/{}'.format(registry, image, app_settings.get("local_registry"), image))
    local_resource('docker push {} to local registry'.format(image.replace('/','_')), cmd='docker push {}/{}'.format(app_settings.get("local_registry"), image))

#    local_resource("kind load docker-image {}/{}".format(registry, image))

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

if demo_settings.get("deploy_demo_ambassador_quote"):
  if settings.get("preload_images_for_kind"):
    get_images(registry = "quay.io", images = ["datawire/quote:0.2.7"])

  include("ambassador-quote/Tiltfile")

if demo_settings.get("deploy_demo_argo"):
  include("argo/Tiltfile")

if demo_settings.get("deploy_demo_basic_ingress"):
  include("basic-ingress/Tiltfile")

if demo_settings.get("deploy_demo_consul"):
  if settings.get("preload_images_for_kind"):
    get_images(registry = "docker.io", images = ["hashicorp/counting-service:0.0.2", "hashicorp/dashboard-service:0.0.4"])

#TODO ensure consul is running before running this
  include("consul-demo/Tiltfile")

if demo_settings.get("deploy_demo_oneup"):
  include("oneup/Tiltfile")

if demo_settings.get("deploy_demo_vault"):
  if settings.get("preload_images_for_kind"):
    get_images(registry = "docker.io", images = ["jweissig/app:0.0.1"])

  include("vault-demo/Tiltfile")

if demo_settings.get("deploy_demo_polaris"):
  if settings.get("preload_images_for_kind"):
    get_images(registry = "quay.io", images = ["fairwinds/polaris:0.6"])

  include("polaris/Tiltfile")

if demo_settings.get("deploy_demo_traefik"):
  if settings.get("preload_images_for_kind"):
    get_images(registry = "quay.io", images = ["fairwinds/polaris:0.6"])

  include("traefik/Tiltfile")
