#cloud-config
hostname: "${hostname}"
fqdn: "${fqdn}"
manage_etc_hosts: true
package_update: true
package_upgrade: true
packages:
  - curl
runcmd:
  - export HOME=/root
  - curl -s -k https://${puppet_server}:8140/packages/current/install.bash | bash -s -- extension_requests:pp_environment=${environment} extension_requests:pp_datacenter=${datacenter} extension_requests:pp_application=${application} extension_requests:pp_role=${role} custom_attributes:challengePassword=${autosign_token}
