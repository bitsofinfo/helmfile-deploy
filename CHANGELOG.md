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
