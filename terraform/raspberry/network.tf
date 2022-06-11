resource "docker_network" "nginx-network" {
  name     = "nginx-gateway-network"
  internal = false
}

resource "docker_network" "gateway-interanl" {
  name     = "nginx-gateway-internal-network"
  internal = true
}

output "public_network_id" {
  value = docker_network.nginx-network.id
}

output "internal_network_id" {
  value = docker_network.gateway-interanl.id
}
