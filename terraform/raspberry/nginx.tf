############
# Variables
############

variable "debug_mode" {
  default = false
}

#########
# Locals
#########

locals {
  project = {
    config_path = "${path.root}/config/nginx.conf"
  }
  container = {
    dir_path    = "/etc/nginx"
    config_path = "/etc/nginx/nginx.conf"
  }
}

#######
# Data
#######

data "local_file" "nginx_config" {
  filename = local.project.config_path
}

############
# Resources
############

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "nginx-gateway"

  ports {
    internal = 80
    external = 8080
  }

  upload {
    file    = local.container.config_path
    content = data.local_file.nginx_config.content
  }

  networks_advanced {
    name = docker_network.nginx_network.name
  }

  volumes {
    container_path = local.container.dir_path
    host_path      = "/opt/terraform/nginx"
    volume_name    = "nginx-volume"
  }

}

