resource "docker_image" "pihole" {
  name         = "pihole/pihole"
  keep_locally = false
}

locals {
  pihole_dir = "/opt/terraform/pihole"

  ports = {
    dns  = 53
    http = 80
    dhcp = 67
  }
}

resource "docker_container" "pihole" {
  name  = "pihole-terra"
  image = docker_image.pihole.latest

  env = ["TZ=Europe/Warsaw"]

  ports {
    external = local.ports.dhcp
    internal = local.ports.dhcp
    protocol = "udp"
  }

  ports {
    external = local.ports.dns
    internal = local.ports.dns
    protocol = "udp"
  }

  ports {
    external = local.ports.dns
    internal = local.ports.dns
  }

  ports {
    external = local.ports.http
    internal = local.ports.http
  }

  volumes {
    container_path = "/etc/pihole"
    host_path      = "${local.pihole_dir}/etc-pihole"
  }

  volumes {
    container_path = "/etc/dnsmasq.d"
    host_path      = "${local.pihole_dir}/etc-dnsmasq.d"
  }

  volumes {
    container_path = "/var/log/pihole"
    host_path      = "${local.pihole_dir}/logs"
  }

  capabilities {
    add = ["NET_ADMIN"]
  }

  restart = "unless-stopped"

}
