#########
# Locals
#########

locals {
  nginx_config_path = "${path.root}/config/nginx.conf"
}

#######
# Data
#######

data "local_file" "nginx-config" {
  filename = local.nginx_config_path
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
    file    = "/etc/nginx/nginx.conf"
    content = data.local_file.nginx-config.content
  }
}

