# 1.4.1
* Upgraded to `appdeploy:1.4.7` (minor update)
* Upgraded to `appconduits:1.1.4` (minor update)

# 1.4.0
* Upgraded to `appdeploy:1.4.6`
* Upgraded to `appconduits:1.1.3`

# 1.3.0
* Upgraded to `appconduits:1.1.2`

# 1.2.0
* Upgraded to `appdeploy:1.4.3`

# 1.1.0
* Upgraded to `appdeploy:1.4.2` 
* Upgraded to `appconduits:1.1.1` 

# 1.0.20
* Update `helmDefaults.yaml` for new `stable` chart location

# 1.0.19

* Support for `appdeploy:1.3.0` pod disruption budgets: https://github.com/bitsofinfo/helmfile-deploy/pull/2

# 1.0.18

* Support for `appdeploy:1.2.0` autoscaling: https://github.com/bitsofinfo/helmfile-deploy/pull/1

# 1.0.17

* Add support for toggling helmfile's `helmDefaults.createNamespace: true|false` per `statevalues/[cluster].yaml` failes. Relevant for helm 3.2+, you can force this and override cluster settings via `--state-values-set forceHelmCreateNamespace=<true|false>`
 
# 1.0.16

* Upgraded to `appdeploy:1.1.16` 

# 1.0.15

* Change `helmDefaults.yaml` to use `targetCluster` variables for `verify, force, recreatePods`

# 1.0.14

* Upgraded to `appdeploy:1.1.15` 
  
# 1.0.13

* Upgraded to `appdeploy:1.1.14` 
  
# 1.0.12

* If `hooks.custom.[n]` blocks are declared in `chartconfigs.yaml` under `chartConfigs.appdeploy.chartValues.values` no longer assume the existance of the `enabled` and or `variables` sub-keys.
  
# 1.0.11

* Upgraded to `appdeploy:1.1.13` 
* Added support for `releaseBaseName` in environment context files, which will be used in preference to `appname` if present when generating each `helmfile` `release.name`

# 1.0.10

* Upgraded to `appdeploy:1.1.12` 
  
# 1.0.9

* Upgraded to `appdeploy:1.1.11` 
* Added option for per-invocation override for: `--state-values-set forceHelmTimeout=[N seconds]`
  
# 1.0.8

* `deployments.helmfile.yaml` fix `version` (`currentService.version`) to have invalid characters replaced w/ dashes `-` see: https://github.com/roboll/helmfile/issues/970
  
# 1.0.7

* `deployments.helmfile.yaml` added `version` (`currentService.version`) and `name` (`currentService.name`) as additional helmfile `release` labels:`

# 1.0.6

* Added new helmfile state value `forceHelmTillerNamespace` to permit per-invocation overrides of the default helm `tillerNamespace` as defined in `helmDefaults.yaml`. This can be set via `--state-values-set forceHelmTillerNamespace=<whatever>`. This will result in `tillerNamespace: <whatever>` being defined for each generated release under `releases:` by `[deployments|conduits].helmfile.yaml`

# 1.0.5

* Fix `deployments|conduits.helmfile.yaml` to leverage `deepCopy` to properly permit `chartConfigs` overrides to not mutate global `chartConfigs` and only the current iteration. Requires `helmfile` `v0.86.0+`

# 1.0.4

* Fix `conduits.helmfile.yaml` to process annotations/labels for `appconduits:1.0.12` 

# 1.0.3

* Upgraded to `appconduits:1.0.12` 

# 1.0.2

* Upgraded to `appdeploy:1.1.10` 

# 1.0.1

* Works with `appdeploy:1.1.9+` and `appconduits:1.0.11+` which introduced breaking changes

# 1.0.0

Initial version, works with `appdeploy:1.1.8` and `appconduits:1.0.10`
