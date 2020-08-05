# URL Routing

Riser offers simple routing for a few common scenarios. The examples on this page assume the following configuration unless otherwise specified:

- Deployment Name: `testdummy`
- Namespace: `apps`
- Domain name: `dev.myplatform.net`


## Domain Name
Each _Environment_ can have its own domain name. It is recommended, although not required, to use the same base domain name across all _Environments_ with a subdomain named the same as the _Environment_ name. For example, for the domain name `myplatform.net`, the `dev` _Environment_ should have the domain `dev.myplatform.net`, and the `prod` _Environment_ should have the domain `prod.myplatform.net`.

### For Operators
Review the [Knative docs](https://knative.dev/docs/serving/using-a-custom-domain/) for setting up a domain in each cluster. Riser reads the Knative configuration in each cluster and maps the domain to the environment. At this time Riser only supports a single domain per _Environment_.

## External URLs
By default, _Apps_ are exposed _externally_, meaning outside of the cluster's [service mesh](https://istio.io/latest/docs/concepts/what-is-istio/#what-is-a-service-mesh). Depending on how your network architecture is set up, this could mean
exposing your _App_ to your private network or to the general public (note: See the [Vanity URLs](#vanity-urls) section below for additional recommendations on public exposure)

**URL Pattern**: `https://{deploymentName}.{namespace}.{riserDomain}`

**Example**: `https://testdummy.apps.dev.myplatform.net`

{{< tip >}}
The Deployment name is the App name by default
{{< /tip >}}

{{< tip >}}
If you do not wish to expose your App externally, set the `expose.scope` property to `cluster` in your [App Config](https://github.com/riser-platform/riser/blob/main/examples/app.yaml)
{{< /tip >}}

## Cluster URLs
The cluster URL is useful if you have an _App_ that takes a dependency on another _App_ in the same Kubernetes cluster. Currently there is a 1:1 relationship between a Riser _Environment_ and a Kubernetes cluster.

**URL Pattern**: `http://{deploymentName}.{namespace}.svc.cluster.local`

**Example**: `http://testdummy.apps.svc.cluster.local`

{{< tip >}}
A future version of Riser may require security policy changes in order to communicate between Apps in different namespaces
{{< /tip >}}

## Revision URLs
Riser provides the ability to access a specific _Deployment Revision_ directly.

**URL Pattern**: `https://r{revisionNumber}-{deploymentName}.{namespace}.{riserDomain}` _or_ `http://r{revisionNumber}-{deploymentName}.{namespace}.svc.cluster.local`

**Example**: `https://r2-testdummy.apps.dev.myplatform.net`

See the [Revisions]({{< relref "/docs/concepts/deployments.md#revisions" >}}) section for more details.

## Vanity URLs

Because there are many different approaches to managing URLs and frontend proxies, Riser does not have explicit support for Vanity URls. The following section provides examples of various approaches but is not intended to be exhaustive.

### DNS CNAME

If your load balancer is accessible to the network in which you plan to expose your app (e.g. the public internet or your company intranet), you may wish to use a simple [CNAME record](https://en.wikipedia.org/wiki/CNAME_record) in your DNS server. For example:

```
testdummy.org.        CNAME  testdummy.apps.prod.myplatform.net.
```

For public websites, you may wish to consider a CDN such as [Cloudflare](https://www.cloudflare.com/) or [Akamai](https://www.akamai.com/).

### Reverse Proxies

Reverse proxies can provide more sophisticated routing scenarios such as additional authentication options, path based routing, etc. Since Riser prescribes the use of [Istio](https://istio.io/), you may consider leveraging it for your routing needs. Alternatively, some find proxies such as [Nginx](https://www.nginx.com/) or [Kong](https://konghq.com/) or better suited to their needs.