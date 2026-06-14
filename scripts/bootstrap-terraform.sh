#!/bin/bash
set -e

mkdir -p terraform/environments/local
mkdir -p terraform/modules/namespace
mkdir -p terraform/modules/helm-release

cat > terraform/environments/local/providers.tf <<'PROVIDERS'
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.35"
    }

    helm = {
      source = "hashicorp/helm"
      version = "~> 2.16"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
PROVIDERS

cat > terraform/modules/namespace/main.tf <<'NAMESPACE'
resource "kubernetes_namespace" "this" {
  metadata {
    name = var.name
    labels = var.labels
  }
}
NAMESPACE

cat > terraform/modules/namespace/variables.tf <<'NAMESPACEVARS'
variable "name" {
  type = string
}

variable "labels" {
  type = map(string)
  default = {}
}
NAMESPACEVARS

cat > terraform/modules/namespace/outputs.tf <<'NAMESPACEOUT'
output "name" {
  value = kubernetes_namespace.this.metadata[0].name
}
NAMESPACEOUT

cat > terraform/modules/helm-release/main.tf <<'HELM'
resource "helm_release" "this" {
  name       = var.name
  repository = var.repository
  chart      = var.chart
  namespace  = var.namespace

  create_namespace = var.create_namespace

  values = var.values
}
HELM

cat > terraform/modules/helm-release/variables.tf <<'HELMVARS'
variable "name" { type = string }
variable "repository" { type = string }
variable "chart" { type = string }
variable "namespace" { type = string }

variable "create_namespace" {
  type = bool
  default = false
}

variable "values" {
  type = list(string)
  default = []
}
HELMVARS

cat > terraform/environments/local/main.tf <<'MAIN'
module "monitoring_namespace" {
  source = "../../modules/namespace"

  name = "monitoring"

  labels = {
    managed-by = "terraform"
  }
}

module "monitoring_stack" {
  source = "../../modules/helm-release"

  name       = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = module.monitoring_namespace.name
}
MAIN

echo "Terraform module structure created."
