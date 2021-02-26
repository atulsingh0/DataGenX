# Check If Internal Registry is installed or not
oc get route -n openshift-image-registry -o jsonpath='{.items[*].spec.host}{"\n"}'


# Double check the python image location in internal by below command - 
oc get is/python -n openshift -o jsonpath='{.status.publicDockerImageRepository}{"\n"}'


# Expose Internal Image registry 
oc patch config cluster -n openshift-image-registry --type merge -p '{"spec":{"defaultRoute":true}}'


# Once exposed, You can access the image registry by below commands - 
OCPUSER=$(oc whoami)
TOKEN=$(oc whoami -t)

INTERNAL_REGISTRY=$(oc get route -n openshift-image-registry -o jsonpath='{.items[*].spec.host}{"\n"}')
podman login ${INTERNAL_REGISTRY} -u ${OCPUSER} -p ${TOKEN}


# To Test
podman pull ${INTERNAL_REGISTRY}/openshift/python:latest