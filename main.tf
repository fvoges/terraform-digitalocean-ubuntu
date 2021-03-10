resource "digitalocean_project" "server" {
  count       = var.manage_project ? "1" : "0"
  name        = var.project_name
  environment = var.environment
}

data "digitalocean_project" "server" {
  name = var.project_name
}

data "digitalocean_ssh_keys" "all" {
}

locals {
  userdata_vars = {
    hostname       = var.hostname
    fqdn           = "${var.hostname}.${var.domain}"
    datacenter     = var.region
    application    = var.application
    role           = var.role
    environment    = var.environment
    puppet_server  = var.puppet_server
    autosign_token = var.autosign_token
  }
}

resource "digitalocean_droplet" "server" {
  image     = var.image
  name      = "${var.hostname}.${var.domain}"
  region    = var.region
  size      = var.size
  ipv6      = true
  tags      = sort(distinct(concat(["all"], var.tags)))
  ssh_keys  = data.digitalocean_ssh_keys.all.ssh_keys.*.fingerprint
  user_data = templatefile("${path.module}/templates/userdata.tpl", local.userdata_vars)

}

resource "digitalocean_record" "server_ipv4" {
  domain = var.domain
  type   = "A"
  name   = var.hostname
  value  = digitalocean_droplet.server.ipv4_address
  ttl    = var.dns_ttl
}

resource "digitalocean_record" "server_ipv6" {
  domain = var.domain
  type   = "AAAA"
  name   = var.hostname
  value  = digitalocean_droplet.server.ipv6_address
  ttl    = var.dns_ttl
}

resource "digitalocean_project_resources" "server" {
  project = data.digitalocean_project.server.id

  resources = [
    digitalocean_droplet.server.urn,
  ]
}
