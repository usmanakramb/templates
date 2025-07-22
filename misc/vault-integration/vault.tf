terraform {
  required_providers {
    env0 = {
      source = "env0/env0"
      version = "1.29.3"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "4.7.0"
    }
  }
}

variable "env0_api_key" {
  type    = string
}

variable "env0_api_secret" {
  type    = string
}

provider "env0" {
  api_key    = var.env0_api_key
  api_secret = var.env0_api_secret
}

provider "vault" {
  address          = "http://13.221.115.246:8200"
#  skip_child_token = true
  auth_login_jwt {
    role           = "vault_role"
  }
}

resource "env0_vault_oidc_credentials" "demo" {
  name                  = "demo"
  address               = "http://13.221.115.246:8200"
  version               = "1.20.0"
  role_name             = "vault_role"
  jwt_auth_backend_path = "jwt"
}

resource "vault_mount" "kvv2" {
  path        = "secret"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

resource "vault_kv_secret_v2" "example" {
  mount               = vault_mount.kvv2.path
  name                = "provider"
  delete_all_versions = true
  data_json = jsonencode(
    {
      zip = "zap",
      foo = "bar"
    }
  )
}

data "vault_kv_secret_v2" "example" {
  mount = vault_mount.kvv2.path
  name  = vault_kv_secret_v2.example.name
}
