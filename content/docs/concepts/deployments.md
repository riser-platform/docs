# Deployments

A _Deployment_ in Riser describes the desired state of a deployed _App_ to a given
[Environment]({{< relref "/docs/concepts/environments.md" >}}).

## Creating a Deployment
The primary mechanism for deploying your _App_ is via the Riser CLI using the
`riser deploy` command from inside of your app folder. Like Kubernetes, Riser works with [Docker](https://www.docker.com/).
Riser does not build or publish Docker images for you. See the
[Docker]({{< relref "/docs/guidance/docker.md" >}}) section for more details.

Assuming that you have already
[created your app]({{< relref "/docs/concepts/apps.md" >}}) and built and published
your docker images, deploying an app with Riser is simple:

```shell
riser deploy (docker tag) (targetEnvironment)
```

For example, if your docker tag is `v1.0` and your [Environment]({{< relref "/docs/concepts/environments.md" >}})
is `prod`:

```shell
riser deploy v1.0 prod
```

{{< tip >}}
Most users will prefer to trigger a deployment from a CI/CD system
instead of manually executing the command. The Riser CLI is a single binary making
it easy to integrate with all popular CI/CD systems.
{{< /tip >}}

Once the _Deployment_ is complete, you may access it using the URL format:
`https://{deploymentName}.{namespace}.{riserdomain}`. Note that the _Deployment_ name is the same as your _App_ name by default.
(e.g. for an app named `testdummy` in the `apps` namespace with an _Environment_ configured with the `dev.mydomain.net` domain:
`https://testdummy.apps.dev.mydomain.net`).
See the [URL Routing]({{< relref "/docs/concepts/url_routing.md" >}})
section for more details.

## Deployment Status
Riser provides an app-centric view of your deployments across all
[Environments]({{< relref "/docs/concepts/environments.md" >}}) using the
`riser status` command. Its goal is to surface only the most pertinent information
regarding the state of your app.

![riser status](/riser_status.png)

### Status Columns

- _Deployment_: The name of the deployment
- _Env_: The name of the target [Environment]({{< relref "/docs/concepts/environments.md" >}})
- _Traffic_: The percentage of traffic being routed to a particular _Deployment_ in a target _Environment_
- _Rev_: The [Revision]({{< relref "/docs/concepts/deployments.md#revisions" >}}) number
- _Docker Tag_: The [Docker tag](https://docs.docker.com/glossary/#tag)
- _Status_: A status representing the state of the deployment:
  - **Ready**: The deployment is ready to accept traffic
  - **Waiting**: The deployment is waiting for an operation to complete
  - **Unhealthy**: The deployment is not healthy (e.g. can't pull the docker image, health check failed, etc)
  - **Unknown**: The deployment status is not known
- _Reason_: When applicable, provides a description of the current _Status_


## Revisions

A _Revision_ represents an immutable snapshot of your _Deployment_. A _Revision_ is
created whenever a _Deployment_ is created (e.g. via `riser deploy`). A _Revision_
contains the following state:
- The _App Config_ with any environment overrides applied
- The docker tag
- [Secrets]({{< relref "/docs/concepts/secrets.md" >}}) bound to your _App_

[Docker image]({{< relref "/docs/guidance/docker.md" >}}). A _Revision_ is
assigned a unique revision number for a given _Deployment_ and _Environment_. This
facilitates
[Traffic Management]({{< relref "/docs/concepts/deployments.md#traffic-management" >}})
scenarios such as canary deployments and rollbacks. Note that there is no correlation
between revision numbers in different environments or between different _Deployment_
names.

### Automatic Rollout

By default, traffic is rolled out automatically when a new _Deployment_ is created:

1) A new _Revision_ is created
1) The new _Revision_ is deployed using a
[Blue Green deployment](https://martinfowler.com/bliki/BlueGreenDeployment.html). At this time no traffic is being routed to the _Revision_
1) Once determined to be healthy, 100% of traffic is immediately routed to the new _Revision_
1) After a period of time the old _Revision_ is deemed inactive

### Manual Rollout

While an automatic rollout is sufficient for some use cases, there are reasons to
employ a manual rollout:

- [Canary Deployments](https://martinfowler.com/bliki/CanaryRelease.html): There is
a desire to test the new _Deployment_ on a subset of traffic before doing a full
rollout.
- Rollback: There is a critical problem with a deployment that cannot be quickly
fixed or "rolled forward"

{{< tip >}}
Remember that all operations that affect the state of your app
go through [Git]({{< relref "/docs/internals/gitops.md" >}}). As such, manual rollout
 changes will take a few moments to apply.
{{< /tip >}}

#### Canary Deployments
A Canary style deployment can be achieved by deploying with the `--manual-rollout` flag.

```shell
riser deploy (docker tag) (targetEnvironment) --manual-rollout
```
`riser status` will now show two active _Revisions_ for your _Deployment_. For example:

![riser status](/riser_status_manual_rollout_0.png)

At this point, the new _Revision_ is not receiving any traffic. In addition to
reviewing traditional metrics and logging, you may also access the _Revision_ directly
using the URL format: `https://r{revNumber}-{deployment}.{namespace}.{riserdomain}`
(e.g. `https://r2-testdummy.apps.dev.mydomain.net`).
See the [URL Routing]({{< relref "/docs/concepts/url_routing.md" >}})
section for more details.

You may now use the `riser rollout` command to route a percentage of traffic to the
new _Revision_. The following example routes 10% of traffic to a new _Revision_ (#11),
and 90% of traffic to the old _Revision_ (#10).

```shell
riser rollout dev r11:10 r10:90
```

You may rollout the new _Revision_ in as many or little steps as you wish. To route
100% of the traffic to the new _Revision_, simply specify a single traffic rule.
For example:

```shell
riser rollout dev r11:100
```

{{< tip >}}
While the information in this section implies manual steps, such
as validating health metrics and initiating several `riser rollout` commands, it is
encouraged to consider implementing these steps as part of an automated
[Deployment Pipeline](https://martinfowler.com/bliki/DeploymentPipeline.html).
{{< /tip >}}

#### Rollback

A rollback is useful when there is a fatal problem with a _Deployment_ that cannot be
quickly fixed or "rolled forward". Because a
[Revision]({{< relref "/docs/concepts/deployments.md#revisions" >}})
in Riser contains a snapshot of all configuration state, it provides a "true rollback"
of all state related to a _Deployment_.

Similar to a Canary style deployment, you may use
the `riser rollout` command to rollback to a previous _Revision_. Simply specify
the desired revision and route 100% of traffic to it. The following example
routes 100% of traffic to _Revision_ #10 in the `dev` environment:

```shell
riser rollout dev r10:100
```

{{< tip >}}
You may use the
`riser status --all-revisions` command to show all available revisions.
{{< /tip >}}

### Garbage Collection
While this history of each _Revision_ will always be present in the
[Git state repo]({{< relref "/docs/internals/gitops.md" >}}), the _Revision_ itself will
be garbage collected from the server based on criteria set by the platform operator.
Typically at least 10 _Revisions_ will be preserved. Once a _Revision_ is garbage
collected it is no longer visible to Riser.

## Named Deployments
Sometimes you'd like to test a different build of your _App_ without needing a
completely separate environment. To accommodate this, Riser supports a naming
your deployments. The name of your _Deployment_ must:
- Include your _App_ name as the prefix, followed by a dash, followed by one or more
lowercase letters, numbers, or dashes.
- Must not collide with any other _Deployment_ name regardless of the _App_ or
the _Environment_ that a _Deployment_ is deployed to.

Many deployment related operations carry the optional `--name` flag to specify the
name of your deployment. The following example creates a _Deployment_ named
`testdummy-pr-15` for the `testdummy` _App_:

```shell
riser deploy dev 0.1.2 --name testdummy-pr-15
```

You may access the named _Deployment_
using the URL format: `https://{deploymentName}.{namespace}.{riserdomain}`
(e.g. `https://testdummy-pr-15.apps.dev.mydomain.net`).
See the [URL Routing]({{< relref "/docs/concepts/url_routing.md" >}}) for more details.

`riser status` will show the status for all deployments associated with your _App_.
For example:

![riser status](/riser_status_named_deployment.png)

Some points to observe:
- A named _Deployment_ gets its own unique _Revision_ number. There is no correlation
between revision numbers between different _Deployment_ names.
- You may control traffic routing via the `riser rollout` command with the `--name`
parameter. Note that you may not route between deployments with different names.


## Deleting a Deployment
Some deployments, particularly for named deployments, are ephemeral. For example,
let's say that your deployment pipeline creates
a named deployment for every pull request. You may wish to add a automation to
automatically delete the deployment after the pull request is merged. Deleting
a deployment is simple:

```shell
riser deployments delete <deploymentName>
```

{{< hint danger >}}
:x: Danger Zone: _Deleting a Deployment deletes all associated
Revisions along with it. You will still be able to review the history in
[Git]({{< relref "/docs/internals/gitops.md" >}}), but Riser does not provide any
sort of "undelete" mechanism. You may always create a new Deployment with similar
configuration, realizing that there are no guarantees that the Deployment will be
in the same state_
{{< /hint >}}