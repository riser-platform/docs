# GitOps

Riser is built on the [principles of GitOps](https://www.weave.works/technologies/gitops/). Every change that Riser makes happens via a _State Repo_, a Git repository which holds a versioned account of all Kubernetes state. Whenever you issue a command in Riser (e.g. to make a [Deployment]({{< relref "/docs/concepts/deployments.md" >}})), Riser makes a commit to the _State Repo_ with the desired changes on your behalf. Each Kubernetes cluster watches for changes in the GitOps repo and applies those changes on a continuous basis.

{{< tip >}}
You do not need to interact with the State Repo as part of normal Riser operations. The State Repo is useful for auditing (e.g. who changed what and when) and for debugging (e.g. what is the current state of my Deployment)
{{< /tip >}}

## The State Repo

### Folder Structure

Riser manages the folder structure of the _State Repo_ for you. This section is useful to help you navigate the _State Repo_ for auditing or debugging purposes, or if you wish to use the _State Repo_ for Kubernetes state that is not managed by Riser.

{{< hint warning >}}
:warning: _Riser is the source of truth for all resources managed by Riser. Riser makes no attempt to merge any changes with Riser's desired state and the state of the repo. Do not modify any Riser managed resources in the State Repo._
{{< /hint >}}

#### Annotated Example
The following is an example of a _State Repo_ with two environments, "dev" and "prod", and an _App_ with a _Deployment_ named "testdummy" in the "apps" namespace.

```sh
├── riser-config # <- Configuration used to generate the state. This folder exists for auditing and debugging purposes
│    ├── dev # <- The environment
│    │    └── apps # <- The namespace
│    │         └── testdummy.yaml # <- The App config for "testdummy"
│    └── prod # <- The environment
│         └── ... # <- Same as "dev" above, but with configuration for the "prod" environment
└── state # <- Kubernetes state goes here
     ├── dev # <- The environment. A Kubernetes cluster (for the "dev" environment) applies all resources from this folder
     │    └── riser-managed # <- Resources that are managed by Riser.
     │          ├── apps # <- The namespace
     │          │    ├── deployments # <- deployment resources
     │          │    │    ├── testdummy # <- The deployment name
     │          │    │    │    └── ...*.yaml # <- One or more deployment resource files
     │          │    └── secrets # <- App encrypted secrets
     │          │         └── testdummy # <- The app name
     │          │               └── ...*.yaml # <- One or more secret resource files
     │          └── namespace.apps.yaml # <- The namespace ya
     └── prod # <- The environment. A Kubernetes cluster (for the "prod" environment) applies all resources from this folder
          └── ... # <- Same as "dev" above, but with resources for the "prod" environment
```

#### riser-config
The top level `riser-config` folder is a top level folder that contains all configuration used to generate Kubernetes state for each _App_, in each _Environment_, and for each _Deployment_ in that _Environment_. It contains the final configuration used with any overrides applied. This folder is only used for auditing and debugging purposes. It makes it easy to observe what changes happened in a given environment over time. It also makes it trivial to compare differences between environments. For example, the following command shows the differences between the current final state of the `testdummy` deployment between the `dev` and the `prod` environment.

```sh
diff -c riser-config/dev/apps/testdummy.yaml riser-config/prod/apps/testdummy.yaml
```
With this approach, there is no need to do any mental gymnastics with template variables or complicated overlays to determine your _App's_ configuration.

#### state
The top level `state` folder contains all resources that represent state in Kubernetes. Each _Environment_ has its own sub folder which contains the resources that are continuously applied to the Kubernetes cluster. The `riser-managed` folder container resources that are strictly managed by Riser. You should treat this as a _readonly_ folder. If you have non Riser resources that you would also like to manage via GitOps, you may create a sibling folder and manage those resources as you wish.

