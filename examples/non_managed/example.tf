# data "digitalocean_vpc" "example" {
#   name = "default-${var.region}"
# }

module "droplet" {
  source = "../../"

  project_name   = "example"
  manage_project = true
  hostname       = "dns3"
  domain         = "example.com"
  tags           = ["dns"]
  image          = "ubuntu-24-04-x64"
}

resource "digitalocean_firewall" "dns" {
  name = "dns-secondary"

  tags = ["dns"]

  inbound_rule {
    protocol         = "udp"
    port_range       = "53"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

output "fqdn" {
  value = module.droplet.fqdn
}

output "ipv4" {
  value = module.droplet.ipv4
}

output "ipv6" {
  value = module.droplet.ipv6
}
