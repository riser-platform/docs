# Namespaces

A Riser _Namespace_ has a one to one correlation with a [Kubernetes Namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/). _Namespaces_ provide a scope for names. _App_ names of need to be unique within a _Namespace_, but not across _Namespaces_. Most Riser operations do not require specifying a _Namespace_. The default _Namespace_ in Riser is named `apps`.

## Creating a Namespace

Use `riser namespaces new (namespace name)` to create a new _Namespace_.
