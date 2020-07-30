

# Secrets

Riser _Secrets_ is built on [Bitnami Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets), a project which takes advantage of [Public Key Infrastructure](https://en.wikipedia.org/wiki/Public_key_infrastructure) to provide a mechanism that allows for the secure management of sensitive values within a GitOps environment. The Riser Controller watches the public key on each cluster and keeps the Riser Server up-to-date. This way the app developer never has to worry about what keys to use for which cluster.

More details to follow.