resource "docker_image" "grafana" {
  name = "grafana"
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

  restart = "unless-stopped"
}
