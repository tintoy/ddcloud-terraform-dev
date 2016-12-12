# Customise as required.

variable "ssh_public_key_file"  { default = "~/.ssh/id_rsa.pub" }
variable "host_name"			{ default = "ddcloud-dev" }
variable "image" 				{ default = "ubuntu-14-04-x64" }
variable "size"					{ default = "1gb" }
variable "region"				{ default = "nyc2" }

provider "digitalocean" {
	# Create a separate credentials.tf file that declares this variable.
	token 		= "${var.digitalocean_token}"
}

resource "digitalocean_droplet" "dev" {
	image		= "${var.image}"
	name		= "${var.host_name}"
	region		= "${var.region}"
	size		= "${var.size}"
	ipv6		= true

	ssh_keys	= ["${digitalocean_ssh_key.tintoy.fingerprint}"]
}

resource "digitalocean_ssh_key" "tintoy" {
	name		= "ddcloud-terraform-dev@${var.host_name}.local"
	public_key	= "${file(var.ssh_public_key_file)}"
}

output "host_name" {
	value = "${var.host_name}"
}
output "host_ipv4" {
	value = "${digitalocean_droplet.dev.ipv4_address}"
}
output "host_ipv6" {
	value = "${digitalocean_droplet.dev.ipv6_address}"
}
