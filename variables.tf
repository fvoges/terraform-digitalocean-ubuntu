variable "manage_project" {
  type        = bool
  description = "Manage the DigitalOcean project"
  default     = false
}
variable "project_name" {
  type        = string
  description = "DigitalOcean project name"
  default     = "Default"
}
variable "hostname" {
  type        = string
  description = "Server short hostname (without domain name)"
}

variable "domain" {
  type        = string
  description = "Domaing name. Must be managed using DigitalOcean DNS"
}

variable "dns_ttl" {
  type        = number
  description = "Domaing name. Must be managed using DigitalOcean DNS"
  default     = "1800"
}

variable "region" {
  type        = string
  description = "DigitalOcean region (also used for Puppet's pp_datacenter trusted fact)"
  default     = "lon1"
}

variable "image" {
  type        = string
  description = "DigitalOcean Droplet image (do not change unless you know what you're doing)"
  default     = "ubuntu-24-04-x64"
  validation {
    condition     = can(regex("^ubuntu-", var.image))
    error_message = "The image value must be a valid image name, starting with 'ubuntu-'."
  }
}

variable "size" {
  type        = string
  description = "DigitalOcean Droplet size"
  default     = "s-1vcpu-1gb"
}

variable "tags" {
  type        = list(string)
  description = "List of existing DigitalOcean tags (he module will not create them)"
  default     = []
}

variable "enable_ipv6" {
  type        = bool
  description = "Enable ipv6 for the droplet"
  default     = true
}

variable "enable_backups" {
  type        = bool
  description = "Enable backups for the droplet"
  default     = true
}

variable "enable_monitoring" {
  type        = bool
  description = "Enable monitoring for the droplet"
  default     = true
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to use for the droplet private network"
  default     = null
}

variable "ssh_keys" {
  type        = list(string)
  description = "List of SSH keys allowed to login (**WARNING**: if empty, it will add all your configured SSH keys)"
  default     = []
}

variable "puppet_install_agent" {
  type        = bool
  description = "Install Puppet Agent (you need to set all the other Puppet related input variables if true)"
  default     = false
}

variable "puppet_autosign_token" {
  type        = string
  description = "Puppet SSL cert autosign token"
  default     = null
}

variable "puppet_server" {
  type        = string
  description = "Puppet server FQDN"
  default     = null
}

variable "puppet_environment" {
  type        = string
  description = "Puppet environment (pp_environment trusted fact)"
  default     = "production"
}

variable "puppet_application" {
  type        = string
  description = "Puppet Application (pp_application trusted fact)"
  default     = null
}

variable "puppet_role" {
  type        = string
  description = "Puppet Role (pp_role trusted fact)"
  default     = "server"
}

variable "tailscale_install_client" {
  type        = bool
  description = "Install Tailscale VPN Client (you need to set at least the tailscale_auth_key input variable if true)"
  default     = false
}

variable "tailscale_auth_key" {
  type        = string
  description = "Tailscale VPN authentication key used to register the node"
  default     = null
}

variable "tailscale_ssh" {
  type        = bool
  description = "Enable Tailscale VPN SSH"
  default     = false
}

variable "tailscale_exit_node" {
  type        = bool
  description = "Publish this Tailscale node as an exit node"
  default     = false
}

