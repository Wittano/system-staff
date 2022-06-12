resource "docker_image" "grafana" {
  name = "grafana/grafana"
}

resource "docker_container" "grafana" {
  name  = "grafana-terraform"
  image = docker_image.grafana.latest

  ports {
    external = 3000
    internal = 3000
  }

  volumes {
    container_path = "/var/lib/grafana"
    volume_name    = "grafana-volume"
  }

  networks_advanced {
    name = docker_network.gateway_network.name
  }

  restart = "unless-stopped"
}
