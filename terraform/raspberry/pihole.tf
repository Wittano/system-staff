resource "docker_image" "pihole" {
  name         = "pihole/pihole"
  keep_locally = false
}

resource "docker_container" "pihole" {
  name  = local.pihole.name
  image = docker_image.pihole.latest

  env = ["TZ=Europe/Warsaw"]

  ports {
    external = local.pihole.ports.dhcp
    internal = local.pihole.ports.dhcp
    protocol = "udp"
  }

  ports {
    external = local.pihole.ports.dns
    internal = local.pihole.ports.dns
    protocol = "udp"
  }

  ports {
    external = local.pihole.ports.dns
    internal = local.pihole.ports.dns
  }

  ports {
    external = local.pihole.ports.public_http
    internal = local.pihole.ports.http
  }

  volumes {
    container_path = "/etc/pihole"
    host_path      = "${local.pihole.root_dir}/etc-pihole"
  }

  volumes {
    container_path = "/etc/dnsmasq.d"
    host_path      = "${local.pihole.root_dir}/etc-dnsmasq.d"
  }

  volumes {
    container_path = "/var/log/pihole"
    host_path      = "${local.pihole.root_dir}/logs"
  }

  capabilities {
    add = ["NET_ADMIN"]
  }

  restart = "unless-stopped"

}
