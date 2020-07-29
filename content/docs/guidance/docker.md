# Docker

Since Riser is built on [Kubernetes](https://kubernetes.io/), it uses
[Docker](https://docker.com) to package and run your application.
Building and publishing your own
Docker images is outside the scope of the Riser project. If you're unfamiliar with
Docker, you should review the [Docker documentation](https://docs.docker.com/get-started/)
before proceeding with Riser.

## Private Registries

Riser does not yet support pod level `ImagePullSecrets`. If you have a private registry, you must use one of the following mechanisms:
- If you're using a managed Kubernetes cluster on a popular cloud provider, most provide a registry authentication
mechanism which does not require the use of `ImagePullSecrets`. This is the recommended approach from both
a maintainability as well as a security perspective.
- If you control the Kubernetes cluster, consider [configuring the nodes to authenticate with the registry](https://kubernetes.io/docs/concepts/containers/images/#configuring-nodes-to-authenticate-to-a-private-registry)
- You may also consider [attaching credentials to a service account](https://knative.dev/docs/serving/deploying/private-registry/). Note
that this must be done for each Kubernetes namespace which requires access to the private registry.

