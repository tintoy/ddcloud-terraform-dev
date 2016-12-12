# Dev environment for CloudControl Terraform provider

Create a file called `credentials.tf` in the same folder as `main.tf`, with the following contents:

```hcl
variable "digitalocean_token" {
    default = "Your_DigitalOcean_API_Token"
}
```

Then run:

* `cd terraform`
* `terraform apply`
