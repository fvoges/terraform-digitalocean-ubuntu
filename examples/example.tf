module "do-ubuntu" {
  source = "../"

  project_name   = "DNS"
  manage_project = true
  puppet_server  = "puppet.example.com"
  hostname       = "ns2"
  application    = "dns"
  role           = "secondary"
  domain         = "example.com"
  autosign_token = "hunter2"
  tags           = [ "dns" ]
  image          = "ubuntu-18-04-x64"
}

resource "digitalocean_firewall" "dns" {
  name = "dns-secondary"

  tags = [ "dns"]

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
  value = module.do-ubuntu.fqdn
}

output "ipv4" {
  value = module.do-ubuntu.ipv4
}

output "ipv6" {
  value = module.do-ubuntu.ipv6
}
