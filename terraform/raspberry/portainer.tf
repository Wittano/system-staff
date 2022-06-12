resource "docker_image" "poratiner" {
  name         = "portainer/portainer-ce"
  keep_locally = true
}

resource "docker_container" "portianer" {
  name  = "protainer-ce"
  image = docker_image.poratiner.latest

  restart = "unless-stopped"

  ports {
    external = 8000
    internal = 8000
  }

  ports {
    external = 9443
    internal = 9443
  }

  volumes {
    container_path = local.docker_socket_path
    host_path      = local.docker_socket_path
  }

  volumes {
    container_path = "/data"
    volume_name    = "poratiner-data-volume"
  }

  networks_advanced {
    name = docker_network.gateway_network.name
  }

}
