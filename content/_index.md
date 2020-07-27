---
title: Introduction
type: docs
---

# Riser Platform

Riser is an opinionated app platform built on [Kubernetes](https://kubernetes.io/) and [Knative](https://knative.dev). It provides a radically simplified application deployment and management experience without vendor lock-in.

[![asciicast](https://asciinema.org/a/277448.svg)](https://asciinema.org/a/277448?autoplay=1&cols=160&rows=40)

{{< hint danger >}} This is an experimental project with the goal of improving how we deploy and manage common application workloads. You're invited to look around and provide feedback. It is not yet advised to use Riser in production. Breaking changes may occur frequently and without warning.
{{< /hint >}}

## Key Features

- Radically simplified deployment and management of [12 factor apps](https://12factor.net/)
- PaaS experience without vendor or cloud lock-in
- Single view of apps across multiple environments (e.g. dev/test/prod)
- Simplified secrets management
- GitOps: All state changes happen through git
- App developers only need access to Riser. Kubernetes cluster access is optional for advanced debugging or operational tasks


## Known Issues and Limitations

- GitHub is the only validated git provider at this time. This is no GitHub specific code so it's likely that other providers will function reliably.
- The documentation is very sparse. As features mature more documentation will be added.



{{< button relref="docs/quickstart" >}}Check out the Quickstart{{< /button >}}
{{< button href="https://github.com/riser-platform/riser" >}}Visit us on Github{{< /button >}}
