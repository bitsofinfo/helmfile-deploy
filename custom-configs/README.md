# custom-configs

Within this directory you can place custom directories for your `environments` and `statevalues` yamls.

You don't have to place them here, but this directory is a convenient place to drop them as it is relative from the root of the helmfile-deploy project and nothing in here will ever be committed.

## How to make use of this:

You will need to declare some ENVIRONMENT variables pointing to the custom configuration locations within this directory for `helmfile-deploy`.

Note that currently these locations referred to by the following variables must be *RELATIVE* from the root of the `helmfile-deploy` project (see [743](https://github.com/roboll/helmfile/issues/743))

### HELMFILE_DEPLOY_STATE_VALUES_DIR
This variable designates where your custom `helmfile` *state values* can be found. Within this directory you can have one or more custom `*.yaml` that override and customize known `helmfile-deploy` state values defined in [statevalues/](../statevalues) Its important to note that these values are not `helm` chart values, but rather values that are consumed by the helmfile release templates themselves ([deployments.helmfile.yaml](../deployments.helmfile.yaml) & [conduits.helmfile.yaml](../conduits.helmfile.yaml))
```
export HELMFILE_DEPLOY_STATE_VALUES_DIR=custom-configs/[pathOfYourStateValuesDir]
```

### HELMFILE_DEPLOY_ENVIRONMENTS_DIR
This variable designates where your custom `helmfile` *environments* can be found. This directory should declare a single `index.yaml` that declares your helmfile `environments:` block. For the purposes of the `helmfile-deploy` framework, each helmfile *environment* represents a target application that can be deployed.
```
export HELMFILE_DEPLOY_ENVIRONMENTS_DIR=custom-configs/[pathOfYourEnvironmentsDir]
```
