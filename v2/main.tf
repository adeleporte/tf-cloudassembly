terraform {
  required_providers {
    velocloud = {
      source = "adeleporte/velocloud"
      version = "0.2.9"
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

variable "hostname" {
  type = string
}


variable "fw_wifi" {
  type = string
  default = "allow"
}

variable "fw_shops" {
  type = string
  default = "allow"
}

variable "fw_fabrics" {
  type = string
  default = "allow"
}


provider "velocloud" {
  vco     = var.host
  token    = var.token
}

data "velocloud_profile" "tf_vra" {
  name         = "vra"
}

data "velocloud_address_group" "tf_wifi_customers" {
  name = "wifi-customers"
}

data "velocloud_address_group" "tf_fabrics" {
  name = "fabrics"
}

data "velocloud_address_group" "tf_shops" {
  name = "shops"
}

resource "velocloud_business_policies" "tf_vra_bp" {

  profile = data.velocloud_profile.tf_vra.id

  rule {
    name            = "My vRA App"
    hostname        = var.hostname
    dport_low       = 80
    dport_high      = 80
    proto           = 6
    rxbandwidthpct  = var.bw
    txbandwidthpct  = var.bw
    serviceclass    = "transactional"
    linksteering    = var.link //"ALL"
  }
  
}

resource "velocloud_firewall_rules" "tf_vra_fw" {

  profile = data.velocloud_profile.tf_vra.id
  
  firewall_status   = true
  firewall_logging  = true
  firewall_stateful = true
  firewall_syslog   = true

  rule {
    name            = "vRa access for Wifi Customers"
    
    s_address_group = data.velocloud_address_group.tf_wifi_customers.logicalid
    hostname         = var.hostname
    d_port_low       = 80
    d_port_high      = 80
    proto            = 6
    
    action           = var.fw_wifi
  }
  
  
  rule {
    name            = "vRa access for Shops"
    
    s_address_group  = data.velocloud_address_group.tf_shops.logicalid
    hostname         = var.hostname
    d_port_low       = 80
    d_port_high      = 80
    proto            = 6
    
    action          = var.fw_shops
  }
  
  
  rule {
    name            = "vRa access for Fabrics"
    
    s_address_group  = data.velocloud_address_group.tf_fabrics.logicalid
    hostname         = var.hostname
    d_port_low       = 80
    d_port_high      = 80
    proto            = 6
    
    action           = var.fw_fabrics
  }
  
}

