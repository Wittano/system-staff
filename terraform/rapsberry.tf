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
  nginx_config_path = "${path.module}/nginx.conf"
  nginx_dest_path   = "/opt/terraform/nginx"
  ssh = {
    username        = "raspberry"
    host            = "192.168.1.8"
    port            = 22
    access_key_path = "/home/wittano/.ssh/raspberry"
  }
}

############
# Providers
############

provider "docker" {
  host     = "ssh://${local.ssh.username}"
  ssh_opts = ["-i", local.ssh.access_key_path, "-p", local.ssh.port]
}

#######
# Data
#######

data "docker_registry_image" "nginx" {
  name = "nginx:latest"
}

data "docker_registry_image" "rickroll" {
  name = "kale5/rickroll:arm64"
}

data "local_file" "nginx-config" {
  filename = local.nginx_config_path
}

############
# Resources
############

resource "docker_network" "nginx-network" {
  name     = "nginx-gateway-network"
  internal = true
}

resource "docker_image" "nginx" {
  name = data.docker_registry_image.nginx.name
}

resource "docker_image" "rickroll" {
  name         = data.docker_registry_image.rickroll.name
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "nginx-gateway"

  ports {
    internal = 80
    external = 8080
  }

  upload {
    file = "/etc/nginx/nginx.conf"
    content = data.local_file.nginx-config.content
  }
}

resource "docker_container" "rick-roll" {
  image = docker_image.rickroll.latest
  name  = "rick-and-roll"

  restart = "unless-stopped"

  ports {
    internal = 80
    external = 4269
  }

}
