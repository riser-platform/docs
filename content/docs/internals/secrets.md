

# Secrets

Riser _Secrets_ is built on [Bitnami Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets), a project which takes advantage of [Public Key Infrastructure](https://en.wikipedia.org/wiki/Public_key_infrastructure) to provide a mechanism that allows for the secure management of sensitive values within a GitOps environment.

## Architecture

![secrets](/internals_secrets.png)

The Riser Controller watches the public key on each cluster and keeps the Riser Server up-to-date. Riser never needs access to the private keys. Riser only has access to the plaintext secret in memory for the brief moment of time that is necessary to encrypt the secret with the public key. Private keys, including rotation and archival, are managed by the Sealed Secrets controller. See the [Sealed Secrets documentation](https://github.com/bitnami-labs/sealed-secrets#user-secret-rotation) for more details. There is [work in progress](https://github.com/bitnami-labs/sealed-secrets/pull/416) to support AWS KMS as well as a general plug-in architecture for other key management solutions in the future.

