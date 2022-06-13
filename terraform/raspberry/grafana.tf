resource "docker_image" "grafana" {
  name = "grafana/grafana"
}

resource "docker_container" "grafana" {
  name  = local.grafana.name
  image = docker_image.grafana.latest

  ports {
    internal = local.grafana.port
  }

  volumes {
    container_path = "/var/lib/grafana"
    volume_name    = "grafana-volume"
  }

  networks_advanced {
    name = docker_network.gateway_network.name
  }

  restart = "unless-stopped"

  labels {
    label = "traefik.enable"
    value = true
  }

  labels {
    label = "traefik.http.routers.${local.grafana.name}.entrypoints"
    value = local.traefik.entrypoints.http
  }

  labels {
    label = "traefik.http.routers.${local.grafana.name}.rule"
    value = "Host(`${local.grafana.domain}`)"
  }

  labels {
    label = "traefik.http.routers.${local.grafana.name}.service"
    value = local.grafana.name
  }

  labels {
    label = "traefik.http.services.${local.grafana.name}.loadbalancer.server.port"
    value = local.grafana.port
  }

}
