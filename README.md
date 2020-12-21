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