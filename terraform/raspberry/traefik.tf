data "local_file" "traefik_config" {
  filename = "${path.root}/config/traefik.yml"
}

resource "docker_image" "traefik" {
  name = "traefik"
}

resource "docker_container" "traefik" {
  name  = "traefik-gateway"
  image = docker_image.traefik.latest

  networks_advanced {
    name = docker_network.public_gateway_network.name
  }

  networks_advanced {
    name = docker_network.gateway_network.name
  }

  ports {
    external = 8080
    internal = 8080
  }

  ports {
    external = 80
    internal = 80
  }

  upload {
    content = data.local_file.traefik_config.content
    file    = "/etc/traefik/traefik.yml"
  }

  volumes {
    container_path = local.docker_socket_path
    host_path      = local.docker_socket_path
  }

}
