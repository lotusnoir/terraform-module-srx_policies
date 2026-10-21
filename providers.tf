terraform {
  required_version = ">= 1.9.7"
  required_providers {
    junos = {
      source  = "jeremmfr/junos"
      version = "2.21.0"
    }
    dns = {
      source = "hashicorp/dns"
    }
  }
}
