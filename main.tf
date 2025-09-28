# Set the variable value in *.tfvars file
# or using the -var="hcloud_token=..." CLI option
variable "hcloud_token" {}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
    token = "${var.hcloud_token}"
}

# Create a server
resource "hcloud_server" "baphomet-services" {
    name        = "baphomet-services"
    image       = "ubuntu-24.04"
    server_type = "cx22"
    datacenter  = "fsn1-dc14"
    user_data = file("cloud-init.yaml")
    
    # CRITICAL ADDITION: Explicitly link the SSH key resource
    ssh_keys = [hcloud_ssh_key.main.name] 
    
    public_net {
        ipv4_enabled = true
        ipv6_enabled = true
  }
}

resource "hcloud_ssh_key" "main" {
  name       = "macbook"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIBYt98G/lAhpNxBLY1JAGZcHSbMTuBJHwFFwMTkt/my sandro@sandros-MacBook-Pro.local"
}

resource "hcloud_rdns" "master" {
  server_id  = hcloud_server.baphomet-services.id
  ip_address = hcloud_server.baphomet-services.ipv4_address
  dns_ptr    = "services.baphomet.cloud"
}

resource "aws_route53_record" "ipv4" {
  zone_id = Z00476003F8RX1KPNHHY4
  name    = "services.baphomet.cloud"
  type    = "A"
  ttl     = 300
  records = hcloud_server.baphomet-services.ipv4_address
}

resource "aws_route53_record" "ipv6" {
  zone_id = Z00476003F8RX1KPNHHY4
  name    = "services.baphomet.cloud"
  type    = "AAAA"
  ttl     = 300
  records = hcloud_server.baphomet-services.ipv6_address
}