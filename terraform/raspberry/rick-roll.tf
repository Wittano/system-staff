data "docker_registry_image" "rickroll" {
  name = "kale5/rickroll:arm64"
}

resource "docker_image" "rickroll" {
  name         = data.docker_registry_image.rickroll.name
  keep_locally = false
}

resource "docker_container" "rick-roll" {
  image = docker_image.rickroll.latest
  name  = "rick-and-roll"

  restart = "unless-stopped"

  ports {
    internal = 80
    external = 4269
  }
}
