resource "digitalocean_project" "server" {
  count       = var.manage_project ? "1" : "0"
  name        = var.project_name
  environment = var.puppet_environment
}

data "digitalocean_projects" "server" {
  filter {
    key    = "name"
    values = [var.project_name]
  }
}

data "digitalocean_ssh_keys" "all" {
}

locals {
  userdata_vars = {
    hostname       = var.hostname
    fqdn           = "${var.hostname}.${var.domain}"
    datacenter     = var.region
    application    = var.puppet_application
    role           = var.puppet_role
    environment    = var.puppet_environment
    puppet_server  = var.puppet_server
    autosign_token = var.puppet_autosign_token
    install_puppet = var.puppet_install_agent
  }
}

resource "digitalocean_droplet" "server" {
  image      = var.image
  name       = "${var.hostname}.${var.domain}"
  region     = var.region
  size       = var.size
  ipv6       = var.enable_ipv6
  backups    = var.enable_backups
  monitoring = var.enable_monitoring
  vpc_uuid   = var.vpc_id
  tags       = sort(distinct(concat(["all"], var.tags)))
  ssh_keys   = length(var.ssh_keys) == 0 ? data.digitalocean_ssh_keys.all.ssh_keys[*].fingerprint : var.ssh_keys
  user_data  = templatefile("${path.module}/templates/userdata.tftpl", local.userdata_vars)
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
  project = var.manage_project ? digitalocean_project.server[0].id : data.digitalocean_projects.server.projects[0].id

  resources = [
    digitalocean_droplet.server.urn,
  ]
}
