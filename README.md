# k8s-manifest-validation

Contains resources to assist in the validation of Kubernetes and OpenShift manifests.
## Components

The following components are found in this repository

* [scripts](scripts) - Tooling to help build a custom Schema catalog and validation of manifests
* [ci](ci) - Examples of how to implement manifest validation as part of a CI/CD pipeline
* [examples](examples) - Sample manifests in order to demonstrate schema validation
* [schemas](schemas) - OpenAPI schemas 

# Key Tools

* [kubeval](https://github.com/instrumenta/kubeval) - Tool for validating Kubernetes manifests
* [openapi2jsonschema](https://github.com/instrumenta/openapi2jsonschema) - Tool for converting from OpenAPI to JSON Schema

## Demonstrations

The following demonstrations are found within this repository
### CI Validation using Tekton

Validation of manifests using [Tekton](https://tekton.dev/) / [OpenShift Pipelines](https://docs.openshift.com/container-platform/4.6/pipelines/understanding-openshift-pipelines.html)

Create the resources:

```
$ oc new-project manifest-validation
$ oc apply -f ci/tekton/storage/pvc.yml
$ oc apply -f ci/tekton/tasks/kubeval-task.yml
$ oc apply -f ci/tekton/pipelines/kubeval-pipeline.yml
```

Using the Tekton CLI, start the pipeline and follow the logs

```
$ tkn pipeline start kubeval-pipeline --use-param-defaults --workspace name=git-source,claimName=git-tekton --showlog
```

### Example applications

With the manifests validated in the prior section, Argo CD can be used to deploy resources into the cluster. Use the following steps to deploy Argo CD and manage an example application

Deploy the Operator into a new project called `argocd`

```
$ oc apply -k examples/argocd-operator/base
```

Create the instance of Argo CD and an Application to manage the example application

```
$ oc apply -k examples/argocd/base
```

In a few moments, Argo CD will be provisioned along with series of applications that build and deploy an instance of Apache HTTPD:

* [Kustomize based](examples/example-app)
* [Helm based](examples/example-app-helm)