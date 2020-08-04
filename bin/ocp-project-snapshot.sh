#!/bin/bash
#

# check oc/login
oc whoami 1> /dev/null 2>&1
if [ $? -ne 0 ]; then
   echo "ERROR: You need to be logged in the cluster with 'oc' before running this."
   exit 1
fi

# check parameters
if [ -z "$1" ]; then
   echo "Use: $(basename $0) <project-name>"
   exit 1
fi

function msg() {
  echo "[$(date +%F\ %T)] $@"
}

# check if project exists
PROJECT="$1"
oc get project $PROJECT 1> /dev/null 2>&1
if [ $? -ne 0 ]; then
   echo "ERROR: Project $PROJECT not found."
   exit 1
fi

TMP_DIR=$(mktemp -d --suffix=-ocp-project-snapshot)
TIMESTAMP=$(date +%Y%m%d%H%M%S)
DEST_DIR=${TMP_DIR}/${PROJECT}-${TIMESTAMP}
mkdir -p ${DEST_DIR}

# summary
msg "Getting namespace and summary of all objects"
oc get namespace $PROJECT -o yaml 1> ${DEST_DIR}/project.txt 2>&1
OBJECTS="all,ds,pvc,hpa,quota,limits,sa,rolebinding,replicasets,statefulsets,cm,secret"
oc get $OBJECTS -n $PROJECT -o wide 1> ${DEST_DIR}/summary.txt 2>&1

# events
msg "Getting events"
oc get events 1> ${DEST_DIR}/events.txt 2>&1

# pods and logs
msg "Getting pods and their logs"
mkdir -p ${DEST_DIR}/pods
PODS=$(oc get pods -n $PROJECT -o name | sed -r 's;^pod/;;')
for POD in $PODS; do
  CONTAINERS=$(oc get pod $POD -n $PROJECT --template='{{range .spec.containers}}{{.name}} {{end}}')
  for CONTAINER in $CONTAINERS; do
    mkdir -p ${DEST_DIR}/pods/${POD}
    oc get pod $POD -n $PROJECT -o yaml > ${DEST_DIR}/pods/${POD}.yaml
    oc logs $POD -n $PROJECT --container=$CONTAINER --timestamps 1> ${DEST_DIR}/pods/${POD}/${CONTAINER}.current.log 2>&1
    oc logs -p $POD -n $PROJECT --container=$CONTAINER --timestamps 1> ${DEST_DIR}/pods/${POD}/${CONTAINER}.previous.log 2>&1
  done
done

# all other objects
msg "Getting all object descriptions"
OBJECTS="cronjobs jobs builds bc deployments dc ds imagestreams pvc hpa quota limits sa rolebinding replicasets replicationcontrollers cm services rout
es endpoints"
for OBJECT in $OBJECTS; do
   oc get $OBJECT -n $PROJECT -o yaml 1> ${DEST_DIR}/${OBJECT}.yaml 2>&1
done

# compacting
DEST_FILE=${PROJECT}-${TIMESTAMP}.tar.gz
msg "Compacting to ${DEST_FILE}"
tar -C $TMP_DIR -zcf $DEST_FILE ${PROJECT}-${TIMESTAMP}

# delete tmp dir
msg "Removing temporary dir"
rm -rf $TMP_DIR

msg "Done."

