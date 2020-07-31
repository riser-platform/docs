# Secrets

A _Secret_ allows you to manage the lifecyle of sensitive information inside of Riser. Riser takes advantage of [Public Key Infrastructure](https://en.wikipedia.org/wiki/Public_key_infrastructure) to provide a mechanism that allows for the secure management of sensitive values within a GitOps environment.

To learn more about the architecture of this feature, review the [Secrets Internals]({{< relref "docs/internals/secrets.md" >}}) section.

{{< hint info >}}
:information_source: _Other than a brief moment during the encryption phase, Riser does not have access to your Secrets. Riser does not need access to your secrets or your private keys on your Kubernetes clusters._
{{< /hint >}}

## Saving a Secret
There are some important considerations to consider when using this feature:

- _Secrets_ are stored per _App_ and per _Environment_
- _Secrets_ may not be shared between _Apps_ or _Environments_
- For security reasons, there is intentionally no mechanism to read or copy a _Secret_
- You should not consider Riser _Secrets_ as the canonical store for sensitive information

Use `riser secrets save (name) (plaintextsecret) (targetEnvironment)` from inside your app folder to save a secret. For example, to save a postgres URL to the `dev` environment:

```sh
riser secrets save POSTGRES_URL "postgres://user:s3cr3t@postgres.net/mydb" dev
```

You should now see your secret using the command `riser secrets list (environment)`

## Accessing Secrets from your App

Once one or more _Secrets_ are saved to an _Environment_, they are automatically bound to your _App_ on each subsequent [Deployment]({{< relref "docs/concepts/deployments.md#creating-a-deployment" >}}) in that _Environment_. _Secrets_ are securely bound to your app using environment variables. For example, a _Secret_ named `POSTGRES_URL` is bound to the environment variable `POSTGRES_URL` in your app.

## Secret Revisions
When you wish to update a _Secret_, simply save a secret with the same name and a new value for the target _Environment_ using `riser secrets save...`. Like saving a new _Secret_, the new value is not applied until after a
new [Deployment]({{< relref "docs/concepts/deployments.md#creating-a-deployment" >}}) in that _Environment_ takes place. Additionally, Riser will assign a revision number to the _Secret_. The _Secret Revision_ is tied to your [Deployment's Revision]({{< relref "docs/concepts/deployments.md#revisions" >}}). This means that if you ever rollback your _Deployment_ that your Secret values will rollback along with it.


### Advanced Example
Most of the time it's just as simple as saving a _Secret_ and creating a _Deployment_. The following is a more complex example where we save multiple revisions of the _Secret_ and rollback our _Deployment_. Let's start with an _App_ with no _Secrets_ and we wish to save a secret `FOO` and access it from our code:

```sh
riser secrets save FOO fooval1 dev
```

**Current State:** The secret has been encrypted and saved in the _State Repo_, but the environment variable `FOO` does not exist until we create a new _Deployment_ to the `dev` _Environment_.

```sh
riser deploy v1 dev
```

**Current State:** The environment variable `FOO` now has the value `fooval1` in the `dev` _Environment_. The _Deployment_ _Revision_ is `2`.

```sh
riser secrets save FOO fooval2 dev
```

**Current State:** The new secret value has been encrypted and saved in the _State Repo_. The environment variable `FOO` will still have the value `fooval1` until we create a new _Deployment_ to the `dev` _Environment_.

```sh
riser deploy v1 dev
```

{{< hint info >}}
:information_source: _It's okay to deploy the same Docker tag multiple times (e.g. `v1` in this example). Riser considers all configuration as code, including secrets. Riser will still create a new Deployment Revision even though you are deploying with the same Docker tag._
{{< /hint >}}

**Current State:** The environment variable `FOO` now has the value `fooval2` in the `dev` _Environment_. The _Deployment_ _Revision_ is `3`.

We've discovered a problem with our _App_ and we've decided to rollback the _Deployment_ back to _Revision_ `2`

```sh
riser rollout dev r2:100
```

**Current State:** The environment variable `FOO` now has the value `fooval1` in the `dev` _Environment_. The _Deployment_ _Revision_ is `2`.

Riser always uses the most recent _Secret Revision_ for a _Deployment_, regardless whether or not a rollback ocurred. If we were to redeploy our app again:

```sh
riser deploy v1 dev
```

**Current State:** The environment variable `FOO` now has the value `fooval2` in the `dev` _Environment_. The _Deployment_ _Revision_ is `4`.


{{< hint info >}}
:information_source: _You never need to worry about the specific Secret Revisions. Riser manages which Deployment Revision maps to which Secret Revision for you so that you don't have to._
{{< /hint >}}

## Deleting a Secret

Deleting a _Secret_ has not yet been implemented.






