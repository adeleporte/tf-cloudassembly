terraform {
  required_providers {
    velocloud = {
      source = "adeleporte/velocloud"
      version = "0.2.6"
    }
  }
}

variable "host" {
  type = string
}

variable "token" {
  type = string
}

variable "bw" {
  type = string
}

variable "link" {
  type = string
}

variable "ip" {
  type = string
}


provider "velocloud" {
  vco     = var.host
  token    = var.token
}

data "velocloud_profile" "tf_vra" {
  name         = "vra"
}

resource "velocloud_business_policies" "tf_vra_bp" {

  profile = data.velocloud_profile.tf_vra.id

  rule {
    name            = "My vRA App"
    dip             = var.ip
    dsm             = "255.255.255.255"
    dport_low       = 80
    dport_high      = 80
    proto           = 6
    rxbandwidthpct  = var.bw
    txbandwidthpct  = var.bw
    serviceclass    = "transactional"
    linksteering    = var.link //"ALL"
  }
  
}
