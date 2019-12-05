##############################
# Openshift Command aliases
##############################


OCP_USERNAME=''
OCP_DEV_URL=''
OCP_QA_URL=''

alias ocdev='oc login ${OCP_DEV_URL} -u ${OCP_USERNAME} '
alias ocqa='oc login ${OCP_QA_URL} -u ${OCP_USERNAME} '

alias ologin='oc rsh'
# OC get resources
alias og='oc get'
alias odc='oc get dc -o wide'
alias osts='oc get sts -o wide'
alias ohpa='oc get hpa'
alias opod='oc get pod -o wide '
alias osvc='oc get svc -o wide '
alias opvc='oc get pvc -o wide '
alias ois='oc get is -o wide '
alias obc='oc get bc -o wide '
alias oall='oc get all -l run='
alias oalln='_(){ oc get all -l run=$1 -o name ;};_'

alias opodo='_(){ oc get pod -l app=$1 -o wide ;};_'
alias opd='_(){ oc get pod -l app=$1 -o jsonpath="{ .metadata.name }" ;};_'
alias oimg='oc get pods -o jsonpath="{..image}" |tr -s "[[:space:]]" "\n" |sort |uniq -c'
alias olcp='oc get pods -o=jsonpath=''{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}'' |sort'
alias olp='oc get pods  -o=jsonpath="{..image}" -l app='

alias odesc='oc describe'
alias odhist='oc rollout history dc'
alias odep='oc apply -f '
alias oroll='_(){ oc rollout latest dc/$1 ;};_'
alias orhist='_(){ oc rollout history dc/$1 ;};_'
alias olog='oc logs -f'
alias osync='oc rsync'
alias ocp='oc cp'
alias ovol='oc volume dc --all'

# Delete Resources
alias odel='oc delete'
alias odelo='_(){ oc delete $1 -l app=$2 ;};_'
alias odela='_(){ oc delete all -l app=$1 ;};_'
alias odeldc='oc delete dc'
alias odelsts='oc delete sts'
alias odelpod='oc delete pod'
alias odelsvc='oc delete svc'
alias odelbc='oc delete bc'
alias odelpvc='oc delete pvc'

# Export yaml config
alias oexp='_(){ oc get $@ -o yaml --export ;};_'
alias opexp='_(){ oc get pod $1 -o yaml --export ;};_'
alias odexp='_(){ oc get dc $1 -o yaml --export ;};_'
alias osexp='_(){ oc get sts $1 -o yaml --export ;};_'
alias ocexp='_(){ oc get cm $1 -o yaml --export ;};_'
alias ovexp='_(){ oc get pvc $1 -o yaml --export ;};_'

# Scaling
alias oscaled='_(){ oc scale --replicas=$1 dc $2 ;};_'
alias oscales='_(){ oc scale --replicas=$1 statefulsets $2 ;};_'
alias ostopd='oc scale --replicas=0 dc'
alias ostartd='oc scale --replicas=1 dc'
alias ostarts='oc scale --replicas=1 statefulsets'
alias ostops='oc scale --replicas=0 statefulsets'

alias opclean='for p in $(oc get pods | grep Terminating | awk ''{print $1}''); do oc delete pod $p --grace-period=0 --force;done'
alias opodr='oc get pods -o jsonpath=''{.items[?(@.status.phase=="Running")].metadata.name}'''
alias opodt='oc get pods -o jsonpath=''{.items[?(@.status.phase=="Terminating")].metadata.name}'''

pod()
{ local selector=$1; local query='?(@.status.phase=="Running")';
oc get pods -l $selector -o jsonpath="{.items[$query].metadata.name}"; }

alias obackup='\
 oc get -o yaml --export all > project.yaml;
 for object in rolebindings serviceaccounts secrets imagestreamtags cm egressnetworkpolicies rolebindingrestrictions limitranges resourcequotas pvc templates cronjobs statefulsets hpa deployments replicasets poddisruptionbudget endpoints
do
  oc get -o yaml --export $object > $object.yaml
done ; \'

# Scale by 1
oincs()
{
rep=$(oc get statefulset $1 -o jsonpath='{.spec.replicas}{"\n"}')
replica=`echo $(($rep+1))`
oc scale --replicas=$replica statefulsets $1
}

oincd()
{
rep=$(oc get dc $1 -o jsonpath='{.spec.replicas}{"\n"}')
replica=`echo $(($rep+1))`
oc scale --replicas=$replica dc $1
}

odecs()
{
rep=$(oc get statefulset $1 -o jsonpath='{.spec.replicas}{"\n"}')
replica=`echo $(($rep-1))`
oc scale --replicas=$replica statefulsets $1
}

odecd()
{
rep=$(oc get dc $1 -o jsonpath='{.spec.replicas}{"\n"}')
replica=`echo $(($rep-1))`
oc scale --replicas=$replica dc $1
}
