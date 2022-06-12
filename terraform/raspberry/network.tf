resource "docker_network" "gateway_network" {
  name = "traefik-network"
  internal = true
}

resource "docker_network" "public_gateway_network" {
  name = "gateway-network"
}
