terraform {
  required_version = ">= 1.1.0"
  required_providers {
    junos = {
      source  = "jeremmfr/junos"
      version = "2.4.0"
    }
  }
}
