# Self Hosted Cloud

## Goals

This repo is intended to be forked in order to provide you a simple enough way of creating your own self hosted cloud. It come with a small baseline of applications to get you up and running, but it's meant to be customzed with your own apps.

## Intended features:

- Single Authentication for all apps
- Scalabilty
- Schedulability of ressources (to reduce costs when it's not used)
- App store

### Scalabilty

To keep ressources usage as low as possible, this cluster is designed to host applications that will run at a predefined schedule. This means that if you don't need your applications to run at night they can be scaled down to 0 and let the Kubernetes node autoscaler remove unneeded nodes.

## Getting started

### Google Cloud

<!--TODO: Expand on initial setup-->
- Install the google-cloud-sdk
- Authenticate to googl: `gcloud auth login`
- Install the kubectl component with `gcloud component install kubectl`

### Github

- Install the `gh` client
- Authenticate to github: `gh auth login`

### Cloudflare

## Terraforming

### Settings the variables

#### Nodes

In order to prevent costs from skyrocketing, two types of nodes can be set. One for the permantent nodes hosting the bare minimum workload, and one for the extra nodes.

To allow kubernetes to scale down efficiently, set the `kubneretes_permantent_node_type` to a powerful enough type to hold constant running apps, but light enough to be ressource efficient. Also set the `kubernetes_extra_node_type` to fit your needs as close as possible.


### Kubernetes Config

> [!WARNING]
> if you set the "kubenretes_save_in_main_config" variable, it will override exsiting ~/.kube/config file !
