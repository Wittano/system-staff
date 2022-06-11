resource "docker_network" "nginx_network" {
  name     = "nginx-gateway-network"
  internal = false
}
