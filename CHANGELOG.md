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
