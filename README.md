# terraform-digitalocean-ubuntu

Module to manage Ubuntu droplets in DigitalOcean with Puppet handling the OS configuration.

## Overview

This Terraform module will:

- Manage a [DigitalOcean](https://m.do.co/c/bb184ec400b6) (referral link) Droplet
  - Add all available [SSH keys in DigitalOcean account](https://cloud.digitalocean.com/account/security) to the Droplet
  - Assign the following tags to the Droplet
    - `all`
    - Specified list of tags
- Install [Puppet Agent](https://puppet.com) from a Puppet Enterprise server, and:
  - Pass data to the Agent to configure the following Trusted Facts
    - `pp_application` (required)
    - `pp_role` (default: `server`)
    - `pp_environment` (default: `production`)
    - `pp_datacenter` (using the droplet region value)
  - Pass an auto-sign token to the Puppet Agent installer
- Manage A and AAAA DNS records for the Droplets using DigitalOcean's DNS
- Include the droplet in the specified DigitalOcean project (default project name: `Default`)
- Optional:
  - Manage the DigitalOcean Project (default: true)

> **NOTE:** The module uses the Puppet Enterprise agent installer to keep things simple. You can change it to use the open source repos by modifying the [user data template](./templates/userdata.tpl) in the templates directory.

### DNS and firewall rules

The module doesn't manage the DNS domain, nor the DigitalOcean firewall rules.

I use these DigitalOcean tags for the firewall rules:

- `all` does the basic firewall rules (deny all, allows ping, allows SSH from certain IPs/subnets)

The code in the examples directory includes code to setup additional rules linked to a tag.

### Application installation

This is done by Puppet using the trusted facts to assign a Puppet role class to the droplet.

## Inputs

See [`variables.tf`](variables.tf).

You'll also have to specify the [DigitalOcean API Token](https://cloud.digitalocean.com/account/api/tokens). Just use the `DIGITALOCEAN_TOKEN` environment variable, or add it in TFC/TFE as a sensitive environment variable in your workspace configuration.

## Outputs

The module returns the IP v4 (`ipv4`), IP v6 (`ipv6`), and FQDN (`fqdn`) of the provisioned server.
