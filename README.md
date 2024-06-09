# Self Hosted Cloud

## Goals

This repo is intended to be forked in order to provide you a simple enough way of creating your own self hosted cloud. It come with a small baseline of applications to get you up and running, but it's meant to be customzed with your own apps.

## Intended features:

- Single Authentication for all apps
- Scalabilty
- Schedulability of ressources (to reduce costs when it's not used)

## Getting started

### Google Cloud

- Install the google-cloud-sdk
- Authenticate to googl: `gcloud auth login`
- Install the kubectl component with `gcloud component install kubectl`

### Github

- Install the `gh` client
- Authenticate to github: `gh auth login`

### Cloudflare

## Terraforming

### Settings the variables

### Kubernetes Config

> [!WARNING]
> if you set the "kubenretes_save_in_main_config" variable, it will override exsiting ~/.kube/config file !
