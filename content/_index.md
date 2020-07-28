---
title: Introduction
type: docs
---

# Riser Platform

Riser is an opinionated app platform built on [Kubernetes](https://kubernetes.io/) and [Knative](https://knative.dev). It provides a radically simplified application deployment and management experience without vendor lock-in.

[![asciicast](https://asciinema.org/a/277448.svg)](https://asciinema.org/a/277448?autoplay=1&cols=160&rows=40)

{{< hint warning >}} :warning: _This is an experimental project. You're invited to look around and provide feedback.
It is not yet advised to use Riser in production. Breaking changes may occur frequently and without warning._
{{< /hint >}}

## Key Features

- Radically simplified deployment and management of [12 factor apps](https://12factor.net/)
- PaaS experience without vendor or cloud lock-in
- Single view of apps across multiple environments (e.g. dev/test/prod)
- Simplified secrets management
- GitOps: All state changes happen through git
- App developers only need access to Riser. Kubernetes cluster access is optional for advanced debugging or operational tasks


## Limitations

The Riser project is focused on exploring high value differentiating functionality.
As a result, there are some limitations that you should be aware of. The plan is to
address these limitations once a sufficient baseline of differentiating functionality
has been explored.

- While any git server should work, Riser has only been tested with GitHub.
- The Riser CLI provides a Windows build but it is not actively being tested.
- Authentication is limited to a single API key.
- See the [Docker Images]({{< relref "/docs/concepts/docker_images.md" >}}) section for limitations regarding private Docker registries.




{{< button relref="docs/quickstart" >}}Check out the Quickstart{{< /button >}}
{{< button href="https://github.com/riser-platform/riser" >}}Visit us on Github{{< /button >}}
