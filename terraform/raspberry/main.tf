terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
  }
}

############
# Variables
############

locals {
  ssh = {
    username        = "raspberry"
    host            = "192.168.1.8"
    port            = 22
    access_key_path = "$HOME/.ssh/raspberry"
  }
}

############
# Providers
############

provider "docker" {
  host     = "ssh://${local.ssh.username}"
  ssh_opts = ["-i", local.ssh.access_key_path, "-p", local.ssh.port]
}