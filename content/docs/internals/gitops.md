# GitOps

Riser is built on the [principles of GitOps](https://www.weave.works/technologies/gitops/). Every change that Riser makes happens via a _State Repo_, a Git repository which holds a versioned account of all Kubernetes state. Whenever you issue a command in Riser (e.g. to make a [Deployment]({{< relref "/docs/concepts/deployments.md" >}})), Riser makes a commit to the _State Repo_ with the desired changes on your behalf. Each Kubernetes cluster watches for changes in the GitOps repo and applies those changes on a continuous basis.

{{< tip >}}
You do not need to interact with the State Repo as part of normal Riser operations. The State Repo is useful for auditing (e.g. who changed what and when) and for debugging (e.g. what is the current state of my Deployment)
{{< /tip >}}

## The State Repo

### Environments and Branches
Each _Environment_ gets their own branch in the _State Repo_. The branch name is the same as the _Environment_ name. For example, if you create an _Environment_ named "dev", Riser will create a branch named "dev" in the _State Repo_.

### Folder Structure

Riser manages the folder structure of the _State Repo_. This section is useful to help you navigate the _State Repo_ for auditing or debugging purposes, or if you wish to use the _State Repo_ for Kubernetes state that is not managed by Riser.

{{< warn >}}
Riser is the source of truth for all resources managed by Riser. Riser makes no attempt to merge any changes with Riser's desired state and the state of the repo. Do not manually modify any Riser managed resources in the State Repo.
{{< /warn >}}

#### Annotated Example
The following is an example of a _State Repo_ with an _App_ with a _Deployment_ named "testdummy" in the "apps" namespace.

```sh
├── riser-config # <- Configuration used to generate the state. This folder exists for auditing and debugging purposes
│    ├── apps # <- The namespace
│    │    └── testdummy.yaml # <- The App config for "testdummy"
└── state # <- Kubernetes state goes here
     ├── riser-managed # <- Resources that are managed by Riser.
     │    ├── apps # <- The namespace
     │    │    ├── deployments # <- deployment resources
     │    │    │    ├── testdummy # <- The deployment name
     │    │    │    │    └── ...*.yaml # <- One or more deployment resource files
     │    │    └── secrets # <- App encrypted secrets
     │    │         └── testdummy # <- The app name
     │    │               └── ...*.yaml # <- One or more secret resource files
     │    └── namespace.apps.yaml # <- The namespace ya
     └── ??? # <- You may create your own folders for managing non Riser k8s resources if you wish
```

#### riser-config
The top level `riser-config` folder is a top level folder that contains all configuration used to generate Kubernetes state for each _App_, and for each _Deployment_ . It contains the final configuration used with any overrides applied. This folder is only used for auditing and debugging purposes. It makes it easy to observe what changes happened over time. It also makes it trivial to compare differences between _Environments_.

#### state
The top level `state` folder contains all resources that represent state in Kubernetes. The `riser-managed` folder contains resources that are strictly managed by Riser. You should treat this as a *read only* folder. If you have other resources that you would also like to manage via GitOps, you may create sibling folders.

