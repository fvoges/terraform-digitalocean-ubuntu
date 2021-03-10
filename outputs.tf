output "fqdn" {
  value = "${var.hostname}.${var.domain}"
}

output "ipv4" {
  value = digitalocean_droplet.server.ipv4_address
}

output "ipv6" {
  value = digitalocean_droplet.server.ipv6_address
}