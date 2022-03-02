# terraform-digitalocean-ubuntu

Module to manage Ubuntu droplets in DigitalOcean with Puppet optionally handling the OS configuration.

## Overview

This Terraform module will:

- Manage a [DigitalOcean](https://m.do.co/c/bb184ec400b6) (referral link) Droplet
  - Add all available [SSH keys in DigitalOcean account](https://cloud.digitalocean.com/account/security) to the Droplet
  - Assign the following tags to the Droplet
    - `all`
    - Specified list of tags
- Manage A and AAAA DNS records for the Droplets using DigitalOcean's DNS
- Include the droplet in the specified DigitalOcean project (default project name: `Default`)
- Optional:
  - Manage the DigitalOcean Project (default: true)
  - Install [Puppet Agent](https://puppet.com) from a Puppet Enterprise server, and:
    - Pass data to the Agent to configure the following Trusted Facts
      - `pp_application` (required)
      - `pp_role` (default: `server`)
      - `pp_environment` (default: `production`)
      - `pp_datacenter` (using the droplet region value)
    - Pass an auto-sign token to the Puppet Agent installer

> **NOTE:** The module uses the Puppet Enterprise agent installer to keep things simple. You can change it to use the open source repos by modifying the [user data template](./templates/userdata.tpl) in the templates directory.

### DNS and firewall rules

The module doesn't manage the DNS domain, nor the DigitalOcean firewall rules.

I use these DigitalOcean tags for the firewall rules:

- `all` does the basic firewall rules (deny all, allows ping, allows SSH from certain IPs/subnets)

The code in the examples directory includes code to setup additional rules linked to a tag.

### Application installation

This is done by Puppet using the trusted facts to assign a Puppet role class to the droplet.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | ~> 2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | 2.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [digitalocean_droplet.server](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet) | resource |
| [digitalocean_project.server](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/project) | resource |
| [digitalocean_project_resources.server](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/project_resources) | resource |
| [digitalocean_record.server_ipv4](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/record) | resource |
| [digitalocean_record.server_ipv6](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/record) | resource |
| [digitalocean_projects.server](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/projects) | data source |
| [digitalocean_ssh_keys.all](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/ssh_keys) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_ttl"></a> [dns\_ttl](#input\_dns\_ttl) | Domaing name. Must be managed using DigitalOcean DNS | `number` | `"1800"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Domaing name. Must be managed using DigitalOcean DNS | `string` | n/a | yes |
| <a name="input_enable_backups"></a> [enable\_backups](#input\_enable\_backups) | Enable backups for the droplet | `bool` | `true` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Enable ipv6 for the droplet | `bool` | `true` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Enable monitoring for the droplet | `bool` | `true` | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | Server short hostname (without domain name) | `string` | n/a | yes |
| <a name="input_image"></a> [image](#input\_image) | DigitalOcean Droplet image (do not change unless you know what you're doing) | `string` | `"ubuntu-20-04-x64"` | no |
| <a name="input_manage_project"></a> [manage\_project](#input\_manage\_project) | Manage the DigitalOcean project | `bool` | `false` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | DigitalOcean project name | `string` | `"Default"` | no |
| <a name="input_puppet_application"></a> [puppet\_application](#input\_puppet\_application) | Puppet Application (pp\_application trusted fact) | `string` | `null` | no |
| <a name="input_puppet_autosign_token"></a> [puppet\_autosign\_token](#input\_puppet\_autosign\_token) | Puppet SSL cert autosign token | `string` | `null` | no |
| <a name="input_puppet_environment"></a> [puppet\_environment](#input\_puppet\_environment) | Puppet environment (pp\_environment trusted fact) | `string` | `"production"` | no |
| <a name="input_puppet_install_agent"></a> [puppet\_install\_agent](#input\_puppet\_install\_agent) | Install Puppet Agent (you need to set all the other Puppet related input variables if true) | `bool` | `false` | no |
| <a name="input_puppet_role"></a> [puppet\_role](#input\_puppet\_role) | Puppet Role (pp\_role trusted fact) | `string` | `"server"` | no |
| <a name="input_puppet_server"></a> [puppet\_server](#input\_puppet\_server) | Puppet server FQDN | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | DigitalOcean region (also used for Puppet's pp\_datacenter trusted fact) | `string` | `"lon1"` | no |
| <a name="input_size"></a> [size](#input\_size) | DigitalOcean Droplet size | `string` | `"s-1vcpu-1gb"` | no |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | List of SSH keys allowed to login (**WARNING**: if empty, it will add all your configured SSH keys) | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of existing DigitalOcean tags (he module will not create them) | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to use for the droplet private network | `bool` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | n/a |
| <a name="output_ipv4"></a> [ipv4](#output\_ipv4) | n/a |
| <a name="output_ipv6"></a> [ipv6](#output\_ipv6) | n/a |
<!-- END_TF_DOCS -->