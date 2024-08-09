variable "rgname" {
    type = string
    description = "Resuourse group name"
    
}

variable "rglocation" {
    type = string
    description = "Resuourse group location"
    default = "East US"
  
}

variable "prefix" {
    type = string
    description = "Venet name"
  
}

variable "vnet_cidr_prefix" {
    type = string
    description = "cidr adress range"
  
}

variable "subnet" {
    type = string
    description = "name of the subnet"
  
}

variable "subnet_cidr_prefix" {
    type = string
    description = "Subnet cidr prefix"
  
}

variable "vm_nic" {
    type = string
    description = "VM Nic name"
  
}