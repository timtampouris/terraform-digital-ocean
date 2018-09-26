# terraform-digital-ocean
Terraform configuration for provisioning an instance on Digital Ocean with Floating IP and Firewall with the basic ports open (22,53,80,443)

```
# Create a tag
resource "digitalocean_tag" "tag-name" {
  name = "tag-name"
}

# Create an instance in AMS3 region
resource "digitalocean_droplet" "webserver" {
  count              = 1
  image              = "ubuntu-16-04-x64"
  name               = "webserver${count.index+1}"
  region             = "ams3"
  size               = "1024mb"
  backups            = false
  monitoring         = false
  ipv6               = false
  private_networking = true
  resize_disk        = false
  tags               = ["${digitalocean_tag.webserver.id}"]
  ssh_keys           = "${var.ssh_fingerprints}"
}

resource "digitalocean_floating_ip" "web-ip" {
  droplet_id = "${digitalocean_droplet.webserver.id}"
  region     = "${digitalocean_droplet.webserver.region}"
}

resource "digitalocean_firewall" "web-fw" {
  name = "common-ports"

  droplet_ids = ["${digitalocean_droplet.webserver.id}"]

  inbound_rule = [
    {
      protocol           = "tcp"
      port_range         = "22"
      source_addresses   = ["192.168.0.1/24", "X.XX.XX.XX/32"]
    },
    {
      protocol           = "tcp"
      port_range         = "80"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "443"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
 ] 
 
  outbound_rule = [
    {
      protocol                = "tcp"
      port_range              = "53"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                = "udp"
      port_range              = "53"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
  ]
}
```
