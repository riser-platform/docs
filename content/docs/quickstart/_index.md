---
title: Quickstart
type: docs
weight: 1
---

# Quickstart

The Riser demo allows you to easily experiment with Riser using a local Kubernetes cluster.

## Prerequisites

Ensure that you have a recent version of the following:
- [Docker](https://www.docker.com/get-started) (Note: just for client tooling - the Docker daemon does not need to be running)
- [Minikube](https://github.com/kubernetes/minikube)
- [Git CLI](https://git-scm.com/downloads)
- [Kubectl](https://github.com/kubernetes/kubectl)

You must also have a GitHub account for the state repo. Riser will support other git providers in the future.

{{< tip >}}
These dependencies are specifically for running a local demo of a full Riser stack. A typical app developer only needs the Riser client binary.
{{< /tip >}}

{{< warn >}}
**Windows Users**: A Windows release is available but has not yet been tested. It's recommended that you use the
[Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/faq) for
the Riser CLI.
{{< /warn >}}

## Demo Installation

- Enable the minikube ingress addon: `minikube addons enable ingress`
- Create a minikube cluster. For the best results use the recommended settings: `minikube start --cpus=4 --memory=6144 --kubernetes-version=1.17.7`.
- Create a GitHub repo for Riser's state (e.g. `https://github.com/your-name/riser-state`).
  - Create a branch named `main` (Riser allows you to customize the branch name but the demo does not)
  - Riser requires write access to the repo. It is recommended that you use SSH with a [GitHub deploy key](https://developer.github.com/v3/guides/managing-deploy-keys/) with write access. Riser supports using HTTPS git URLs with authentication such as [GitHub personal access token's](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) as well.
- Download the [latest Riser CLI](https://github.com/riser-platform/riser/releases/) for your platform and put it in your path.
- Ensure that your minikube is started. In a new terminal window, run `minikube tunnel`. Ensure it establishes the tunnel and let it run in the background.
- Run `riser demo install` and follow the instructions.

## Things to try

- Use `riser apps init` to create a minimal app config.
- Check out the annotated [app config](https://github.com/riser-platform/riser/blob/main/examples/app.yaml) for a full list of configuration options.
- Review the [emojivoto microservices example](https://github.com/riser-platform/riser/blob/main/examples/emojivoto)
- Use `riser help` or check out the table of contents to explore other help topics.
