#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function display_help {
  echo "./$(basename "$0") [ -d | --directory DIRECTORY ] [ -q | --quiet ] [ -h | --help | --vpc-keypair | --lab | --teardown | --redeploy | --clear-logs ] [ OPTIONAL ANSIBLE OPTIONS ]
Script to validate the OpenShift manifests
Where:
  -d  | --directory DIRECTORY  Base directory containing content
  -e  | --enforce-all-schemas  Enable enforcement of all schemas
  -h  | --help                 Display this help text
  -sl | --schema-location      Location containing schemas"
}

IGNORE_MISSING_SCHEMAS="--ignore-missing-schemas"
SCHEMA_LOCATION="${DIR}/openshift-json-schema"
DIRS="${DIR}/../clusters/"

for i in "$@"
do
  case $i in
    -d=* | --directory=* )
      DIRS="${i#*=}"
      shift
      ;;
    -e | --enforce-all-schemas )
      shift
      IGNORE_MISSING_SCHEMAS=""
      shift
      ;;
    -sl=* | --schema-location=* )
      SCHEMA_LOCATION="${i#*=}"
      shift
      ;;
    -h | --help )
      display_help
      exit 0
      ;;
  esac
done

for i in `find "${DIRS}" -name "kustomization.yaml" -exec dirname {} \;`; 
do
  echo
  echo "Validating Kustomization: $i"
  echo

  oc kustomize $i | kubeval ${IGNORE_MISSING_SCHEMAS} --schema-location="file://${SCHEMA_LOCATION}" --force-color

  validation_response=$?

  if [ $validation_response -ne 0 ]; then
    echo "Error validating $i"
    exit 1
  fi
done

for i in `find "${DIRS}" -name "Chart.yaml" -exec dirname {} \;`; 
do
  echo
  echo "Validating Helm Chart: $i"
  echo

  helm template $(basename $i) $i | kubeval ${IGNORE_MISSING_SCHEMAS} --schema-location="file://${SCHEMA_LOCATION}" --force-color

  validation_response=$?

  if [ $validation_response -ne 0 ]; then
    echo "Error validating $i"
    exit 1
  fi
done


echo
echo "Manifests successfully validated!"