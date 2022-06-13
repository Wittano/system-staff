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

#########
# Locals
#########

locals {
  ssh = {
    username        = "raspberry"
    host            = "192.168.1.8"
    port            = 22
    access_key_path = "$HOME/.ssh/raspberry"
  }

  docker_socket_path = "/var/run/docker.sock"

  pihole = {
    root_dir = "/opt/terraform/pihole"
    name     = "pihole-terraform"
    ports = {
      dns         = 53
      http        = 80
      public_http = 81
      dhcp        = 67
    }
    domain = "pihole.me"
  }

  grafana = {
    name   = "grafana-terraform"
    port   = 3000
    domain = "grafana.me"
  }

  portainer = {
    name          = "portainer-terraform"
    volume_name   = "poratiner-data-volume"
    domain        = "portainer.me"
    frontend_port = 8000
    edge_port     = 9000
  }

  traefik = {
    name        = "traefik-gateway"
    config_path = "${path.root}/config/traefik.yml"
    entrypoints = {
      http  = "web"
      https = "websecure"
    }
  }
}

############
# Providers
############

provider "docker" {
  host     = "ssh://${local.ssh.username}"
  ssh_opts = ["-i", local.ssh.access_key_path, "-p", local.ssh.port]
}
