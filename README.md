# helmfile-deploy

This project provides a framework of *helmfiles* using the amazing tool [helmfile](https://github.com/roboll/helmfile) for declaring intended Kubernetes state for apps deployed with the [appdeploy](https://github.com/bitsofinfo/appdeploy) Helm chart and accessed via Ingress "conduits" installed by the [appconduits](https://github.com/bitsofinfo/appconduits) Helm chart.

*helmfile-deploy* is a opinionated *framework* (for lack of a better term) that provides a set of *helmfiles* that generate *releases* for the [appdeploy](https://github.com/bitsofinfo/appdeploy) and [appconduits](https://github.com/bitsofinfo/appconduits) charts. To generate those releases, *helmfile-deploy* defines its own YAML syntax for summarizing the desired state for applications it manages. This desired "state" is expressed as *helmfile* `environments:`, one per named target application.

* [Overview](#overview)
* [Examples](examples/)
* [Install/Setup](#setup)
* [Dry running & debugging](#dry)
* [helmfile concepts](#helmfile-term)
* [helmfile-deploy concepts](#helmfile-dep-term)
* [What this provides](#provide)

## <a id="overview"></a>Overview

What does `helmfile-deploy` do? How does it work?

Basically `helmfile-deploy` provides a set of *helmfiles* that can generate releases for the [appdeploy](https://github.com/bitsofinfo/appdeploy) and [appconduits](https://github.com/bitsofinfo/appconduits) helm charts. Out of the box they provided helmfiles are a bit useless and in order to actually be able to do anything with the *helmfiles* this project provides, you have to provide configuration expressed in the form of helmfile `environments:` so that `helmfile` can apply those environment values against the helmfile templates.

![diag](/doc/diag1.png "Diagram1")

Before you venture off to do any of this we, need to cover some basics and get on the same page w/ our terminology.

## <a id="helmfile-term"></a>Helmfile specific concepts

First, some basic *helmfile* concepts you need to understand:

(for full documentation on this see: https://github.com/roboll/helmfile)

**helmfile**:  
A *helmfile* is a YAML file that declares one or more *releases* for Helm charts. You use the [helmfile](https://github.com/roboll/helmfile) command against a target *helmfile yaml file*. Helmfiles themselves can contain [golang template](https://golang.org/pkg/text/template/) markup as well as utilize many [extended functions provided by Sprig.](http://masterminds.github.io/sprig/)

**release**:  
A Helmfile *release* is an expression in YAML for an installation/upgrade of a specific Helm chart and its desired `values`. With [helmfile](https://github.com/roboll/helmfile), the goal is to be able to define many *releases* and then ensure all or some of the defined *releases* are applied against a target Kubernetes cluster.

**state values**:  
Helmfile *state values* are variables/values that are only relevant during the execution of `helmfile` while it is processing a target *helmfile yaml*. *State values* are distinctly different than Helm chart values. *State values* can be referenced in helmfiles in golang templates to dynamically generate helmfile *releases*.

**environment values**:  
When you invoke the `helmfile` command against a target *helmfile yaml file*, you also specify a target `--environment [name]`. Doing so will instruct *helmfile* to load a set of *environment values* specific to that target `--environment`. These values (in combination with *state values*) can be used as variables to also drive the generation of *releases* in the target *helmfile yaml file* that the `helmfile` command will process. It is important to NOT confuse *helmfile environment values* with traditional OS ENVIRONMENT variables... they are NOT the same thing. It is also important to note that a target *environment* can mean *anything* and does NOT necessarily have to mean something like "stage" or "production", but could simply be a target *application* to generate a release for etc.

## <a id="helmfile-dep-term"></a>helmfile-deploy concepts

... and some basic *helmfile-deploy* concepts to understand:

**appdeploy and appconduits helm charts**:    
To even begin using *helmfile-deploy* you first need to be familiar with the concepts and functionality of the [appdeploy](https://github.com/bitsofinfo/appdeploy) and [appconduits](https://github.com/bitsofinfo/appconduits) Helm charts. If you have not already done so, now would be a good time to review them and run through their examples:
* https://github.com/bitsofinfo/appdeploy
* https://github.com/bitsofinfo/appconduits

**environments**:    
When using *helmfile-deploy*, each helmfile *environment* that you target with `--environment [name]` is considered to be a named **"application"** you want to both deploy with [the appdeploy chart](https://github.com/bitsofinfo/appdeploy) and manage customized Ingress routes (conduits) for with [the appconduits chart](https://github.com/bitsofinfo/appconduits). With *helmfile-deploy* each *target application* IS expressed through a *helmfile environment*. (*helmfile environments* = *application desired state definitions*) [See examples](https://github.com/bitsofinfo/helmfile-deploy/tree/master/examples/environments)

**applications**:    
With *helmfile-deploy* each *target application* IS expressed through a *helmfile environment*. To configure a new *application* that *helmfile-deploy* can manage, you define a new helmfile *environment* and express it's desired state in a custom YAML syntax that lets you define an `appname`, its app `environments`, `contexts` and most importantly `services` and `ingresses` within each app's environment/context. For definitions of app *environments/contexts* [see the appdeploy chart README](https://github.com/bitsofinfo/appdeploy) which describes these terms. [Click here for example environment definitions](https://github.com/bitsofinfo/helmfile-deploy/tree/master/examples/environments)

**services**:  
Within each application's helmfile *environment* YAML files ([see examples](https://github.com/bitsofinfo/helmfile-deploy/tree/master/examples/environments)), the key element that you must declare per each `appname's` app `environment` and app `context` are `services`. Each `service` is a super simplified expression of what you really want to express; *"here are all versions of 'appname' that I want running on my target cluster"*. This data drives the [deployments.helmfile.yaml](deployments.helmfile.yaml) helmfile.

**ingress**:  
Likewise, within each application's helmfile *environment* YAML files ([see examples](https://github.com/bitsofinfo/helmfile-deploy/tree/master/examples/environments)), the other key element that you can *optionally* declare per each `appname's` app `environment` and app `context` are `ingresses`. Each `ingress` contains one or more `mappings` and each is a simplified expression of what you really want to express; *"Here are some custom Host/Path definitions I want exposed as Ingress and here is the list of services to bind the traffic to"*. This data drives the [conduits.helmfile.yaml](conduits.helmfile.yaml) helmfile.

**target cluster**:  
When you execute the `helmfile` command against a *helmfile-deploy provided helmfile*, you also need to specify a `targetCluster` via the `--state-values-set targetCluster=[clusterName]`. This tells `helmfile` which cluster to apply the desired releases against. You can define your own `clusters` in custom *helmfile state values files* see [here](https://github.com/bitsofinfo/helmfile-deploy/blob/master/statevalues/001-clusters.yaml) and [here](https://github.com/bitsofinfo/helmfile-deploy/blob/master/examples/statevalues/customized-cluster.yaml). [See documentation here](https://github.com/bitsofinfo/helmfile-deploy/blob/master/statevalues/001-clusters.yaml)

**You may be asking... "where do all the other chart values come from??!"**

Good question. Each application's helmfile *environment* can also declare its own `chartConfigs.appdeploy` and/or `chartConfigs.appconduits` sections. Here is where you can tailor `chartValues` for each app directly inline and even reference shared `baseValues` per chart for common configuration shared across many apps. `chartConfigs` blocks can be defined and/or overridden and supplemented at various levels all the way down to the `service` level. See examples [here](https://github.com/bitsofinfo/helmfile-deploy/blob/master/examples/environments/catapp/chartconfigs.yaml), [here](https://github.com/bitsofinfo/helmfile-deploy/blob/master/examples/statevalues/customized-chartconfigs.yaml), [here](https://github.com/bitsofinfo/helmfile-deploy/blob/master/examples/chartvalues/appdeploy/values/testapps/values.yaml) and [here](https://github.com/bitsofinfo/helmfile-deploy/blob/master/statevalues/000-globals.yaml). For more details on this see: https://github.com/bitsofinfo/helmfile-deploy/blob/master/statevalues/000-globals.yaml

## <a id="provide"></a>What does helmfile-deploy provide?

**helmfiles**:  
Two [helmfile](https://github.com/roboll/helmfile) *helmfiles* are provided:
* [deployments.helmfile.yaml](deployments.helmfile.yaml): Generates a unique helmfile **release** of the [appdeploy Helm chart](https://github.com/bitsofinfo/appdeploy) for each declared `service` within a target helmfile `environment`
* [conduits.helmfile.yaml](conduits.helmfile.yaml): Generates a unique helmfile **release** of the [appconduits Helm chart](https://github.com/bitsofinfo/appdeploy) for each declared `service` within a target helmfile `environment`

**core state values**:  
The project also provides some core helmfile state values files which define the core `chartConfigs` (which you can override at lower levels), and a basic `cluster` definition for minikube. [See here for more info](https://github.com/bitsofinfo/helmfile-deploy/tree/master/statevalues)

**custom configs**:  
As noted above, in order to actually be able to do anything with this project you need to provide your own configuration. Since currently `helmfile` depends on relative path references, we've added a [custom-configs/](custom-configs/) directory where you can build out your custom configuration. Due to `.gitignore` changes will never be committed here, however you can clone your own configs within this sub-directory and manage independently.

## <a id="setup"></a>Install & Setup

Note: before you try your own custom configuration its highly recommended that [you take a look at the examples/](examples/)

Pre-requisites:

1. have the latest [helm](https://helm.sh/) installed
1. have the latest [helmfile](https://github.com/roboll/helmfile) installed **>= 0.79.4**

**Clone the helmfile-deploy project**

You need to clone the `helmfile-deploy` project:
```
git clone --branch [TAG] https://github.com/bitsofinfo/helmfile-deploy.git
```

**Create your own configs**

Next lets create a place for your own configuration (custom *state values*, *base chart values* and *environments*):

*NOTE: change `myconfig` to whatever name you want, in fact any of the directories here can be named anything you want.*

```
cd helmfile-deploy/custom-configs

mkdir -p myconfigs/environments
mkdir -p myconfigs/statevalues
```

These are optional, but handy if you will be taking advantage of the `chartConfigs.[chartname].chartValues.baseValues` functionality. See [statevalues/000-globals.yaml](statevalues/000-globals.yaml) for more info.
```
mkdir -p myconfigs/chartvalues/appdeploy
mkdir -p myconfigs/chartvalues/appconduits
```

*Note you can OPTIONALLY manage your own configs in a separate git project*
```
cd helmfile-deploy/custom-configs/myconfigs
git init
...
```

**Configure helmfile-deploy ENVIRONMENT variables**

These variables tell the *helmfile-deploy* templates where to find your custom configuration. Note this is relative from the ROOT of the helm-deploy project.
```
export HELMFILE_DEPLOY_STATE_VALUES_DIR=custom-configs/myconfigs/statevalues
export HELMFILE_DEPLOY_ENVIRONMENTS_DIR=custom-configs/myconfigs/environments
```

**Optionally configure your targetCluster**

Out of the box, [helmfile-deploy](https://github.com/bitsofinfo/helmfile-deploy) declares one named *cluster* that it can target [named minikube](https://github.com/bitsofinfo/helmfile-deploy/blob/master/statevalues/001-clusters.yaml) which you can reference for local development.

Additional *clusters* can be defined by declaring them in YAML state values under the configured `HELMFILE_DEPLOY_STATE_VALUES_DIR`.

When you invoke `helmfile` the argument that specifies the cluster you want to apply the declared state to is:
```
--state-values-set targetCluster=[clustername]
```

**Invoke helmfile against one of your custom app environments**

We need to be running the `helmfile` commands from the root of the helmfile-deploy project
```
cd path/to/helmfile-deploy/
```

Apply deployments:
```
helmfile \
  --file deployments.helmfile.yaml \
  --state-values-set targetCluster=minikube \
  --namespace [YOUR NAMESPACE] \
  --environment [TARGET APP ENVIRONMENT] \
  --state-values-set chartConfigs.appdeploy.chartValues.baseValuesRootDir=custom-configs/myconfigs/chartvalues/appdeploy \
  apply
```

Apply conduits:
```
helmfile \
  --file conduits.helmfile.yaml \
  --state-values-set targetCluster=minikube \
  --namespace [YOUR NAMESPACE] \
  --environment [TARGET APP ENVIRONMENT] \
  --state-values-set chartConfigs.appdeploy.chartValues.baseValuesRootDir=custom-configs/myconfigs/chartvalues/appdeploy \
  apply
```

## <a id="dry"></a>Dry running & debugging

*helmfile-deploy* can generate a lot of YAML. It can often be useful to both get more information on what its constructing as well as simply output the raw YAML to STDOUT/disk and save it and NOT send it to Kubernetes.

**template mode**:  
The `helmfile` command supports the `template` argument. Simply changing `apply | sync etc` to `template` will output all generated YAML to stdout. Due to the nature of helm charts and generating some extra whitespace, it can also be useful to use something like [python-yq](https://formulae.brew.sh/formula/python-yq) to reformat the the YAML

```
helmfile \
  --file deployments.helmfile.yaml \
  --state-values-set targetCluster=minikube \
  --namespace [YOUR NAMESPACE] \
  --environment [TARGET APP ENVIRONMENT] \
  --state-values-set chartConfigs.appdeploy.chartValues.baseValuesRootDir=custom-configs/myconfigs/chartvalues/appdeploy \
  --quiet \
  template | yq --yaml-output .
```

**enable debugging**:  
Simply adding the `--log-level debug` flag to helmfile can also aid in figuring out whats going on:
