variable "host" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
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
  host     = var.host
  username = var.username
  password = var.password
  operator = false
}

data "velocloud_configuration" "tf_config" {
  name         = "tf_profile2"
  enterpriseid = 123
}

resource "velocloud_qos_rule" "tf_qos_rule" {
  enterpriseid    = 123
  configurationid = data.velocloud_configuration.tf_config.id
  qosmodule       = data.velocloud_configuration.tf_config.qosmodule

  rule {
    name            = "My VCN App"
    dip             = var.ip
    dmask           = "255.255.255.255"
    dport           = 80
    proto           = 6
    bandwidthpct    = var.bw
    class           = "transactional"
    servicegroup    = var.link //"ALL"
  }
  
}
