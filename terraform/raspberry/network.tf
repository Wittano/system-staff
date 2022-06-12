resource "docker_network" "gateway_network" {
  name = "tarfik-network"
}

resource "docker_network" "public_gateway_network" {
  name = "gateway-network"
}
