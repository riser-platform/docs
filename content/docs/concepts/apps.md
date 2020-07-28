# Apps

An _App_ in Riser represents a stateless workload such as websites, REST APIs, GraphQL, or GRPC style APIs.
Riser aims to be compliant with little to no code changes for apps that follow the [12 Factor App](https://12factor.net/) methodology.


## Creating an App
An _App_ is identified by its _Name_ and its
[Namespace]({{< relref "/docs/concepts/namespaces.md" >}}). To create a new _App_,
create a new folder and/or cd into a folder of an existing application and type
`riser apps init (app name)`. This will create an app in the default _Namespace_ `apps`
with an initial _App Config_ saved to `app.yaml`.


{{< hint warning >}}
:warning: _You may not change the name or namespace of your App after it is created._
{{< /hint >}}

## Configuring your App

The initial _App Config_ contains a couple of TODO's:

{{< expand "Example initial app.yaml" "..." >}}
```yaml
name: demo
namespace: apps
id: dd707c85-bf6c-48ac-9f13-4d663f3c0885
# TODO: Update to use your docker image registry/repo (without tag) here
image: your/image
expose:
  # TODO: Update the container port that gets exposed to the HTTPS gateway
  containerPort: 8000
```
{{< /expand >}}

- `image` should be set to the registry/repository of your docker image.
Do not include the docker tag. See the
[docker images]({{< relref "/docs/concepts/docker_images.md" >}}) section for more
information.
- `expose.containerPort` should be set to the port that your app is listening on.
Note that your app is exposed over 443 and TLS regardless of what port your app
is listening on.

While you may name the _App Config_ any way you like, for convenience the Riser CLI
will look for an `app.yaml` in the current folder. If you choose to name it something
else, or if you are in a different folder, commands that require the _App Config_
require passing a `-f path/to/app.yaml` parameter.

Riser is opinionated with smart defaults to cover the most common scenarios. As
such, you may not need to configure anything else for your _App_. Nevertheless, you
may review the configuration options documented in the
[fully annotated app.yaml](https://github.com/riser-platform/riser/blob/main/examples/app.yaml)
in Github.

Once you're app is configured, you're ready to move move in to [Deployments]({{< relref "/docs/concepts/deployments.md" >}})




