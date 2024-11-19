provider "aws"{
    region     = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}
resource "aws_isntance" "ec2"{
    ami = "ami-073998ba87e205747"
    instance_type = "t2.micro"
}

terraform {
    required_providers {
        digitalocean = {
            source = "digitalocean/digitalocean"
            version = "~> 2.0"
        }
    }
}

provider "azurerm"{

}