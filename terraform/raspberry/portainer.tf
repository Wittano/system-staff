resource "docker_image" "poratiner" {
  name         = "portainer/portainer-ce"
  keep_locally = true
}

resource "docker_container" "portianer" {
  name  = local.portainer.name
  image = docker_image.poratiner.latest

  restart = "unless-stopped"

  ports {
    internal = local.portainer.frontend_port
  }

  ports {
    internal = local.portainer.edge_port
    external = local.portainer.edge_port
  }

  volumes {
    container_path = local.docker_socket_path
    host_path      = local.docker_socket_path
  }

  volumes {
    container_path = "/data"
    volume_name    = local.portainer.volume_name
  }

}
