# Customise as required.

variable "region"				{ default = "nyc2" }
variable "ssh_private_key_file"	{ default = "~/.ssh/id_rsa" }
variable "ssh_public_key_file"	{ default = "~/.ssh/id_rsa.pub" }
variable "host_name"			{ default = "ddcloud-dev" }

# The OS image (only tested with Ubuntu 14.04).
variable "image" 				{ default = "ubuntu-14-04-x64" }

# Sizes smaller than 2GB will cause crash during Terraform build.
variable "size"					{ default = "2gb" }

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

	provisioner "file" {
		source			= "files/terraform.rc"
		destination		= "/root/.terraformrc"

		connection {
			type 		= "ssh"
			host 		= "${self.ipv4_address}"
			
			user 		= "root"
			private_key	= "${file(var.ssh_private_key_file)}"
		}
	}

	# Initial provisioning.
	provisioner "remote-exec" {
		scripts = [
			"files/init.sh",
			"files/ohmyz.sh"
		]

		connection {
			type 		= "ssh"
			host 		= "${self.ipv4_address}"
			
			user 		= "root"
			private_key	= "${file(var.ssh_private_key_file)}"
		}
	}
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
