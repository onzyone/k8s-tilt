#!/bin/bash
#set -o errexit

VAULT_PO='tilt-vault-helm-0'
VAULT_NS='vault'

VAULT_INIT_SCRIPT='vault-init.sh'

echo "enable v2"
kubectl exec ${VAULT_PO} -n ${VAULT_NS} -- /bin/vault secrets enable -path=internal kv-v2

echo "copy hcl file"
kubectl cp vault-demo/sbin/app-policy.hcl ${VAULT_NS}/${VAULT_PO}:/home/vault/app-policy.hcl
#TODO look to make this a fucntion
kubectl exec ${VAULT_PO} -n ${VAULT_NS} -- ls -lrta /home/vault

# FOR DEV ONLY!!! Do not use for production
echo "write app policy"
kubectl exec ${VAULT_PO} -n ${VAULT_NS} -- /bin/vault policy write vault-app /home/vault/app-policy.hcl

echo "enable kubernetes auth"
kubectl exec ${VAULT_PO} -n ${VAULT_NS} -- /bin/vault auth enable kubernetes

echo "wirte kubernetes config"
# this needs to be there to ensure that the auth config works
kubectl exec ${VAULT_PO} -n ${VAULT_NS} -- cat /var/run/secrets/kubernetes.io/serviceaccount/token
kubectl exec ${VAULT_PO} -n ${VAULT_NS} -- /bin/vault write auth/kubernetes/config token_reviewer_jwt=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token) kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:443 kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

echo "apply role"
kubectl exec ${VAULT_PO} -n ${VAULT_NS} -- /bin/vault write auth/kubernetes/role/myapp bound_service_account_names=app bound_service_account_namespaces=vault policies=vault-app ttl=1h

echo "create a dummy secret"
kubectl exec ${VAULT_PO} -n ${VAULT_NS} -- /bin/vault kv put secret/helloworld username=foobaruser password=foobarbazpass
kubectl exec ${VAULT_PO} -n ${VAULT_NS} -- /bin/vault kv get secret/helloworld
