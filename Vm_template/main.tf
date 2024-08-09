terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.115.0"
    }
  }
}

resource "azurerm_resource_group" "devrg" {
  name     = "${var.rgname}"
  location = "${var.rglocation}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}--10"
  address_space       = ["${var.vnet_cidr_prefix}"]
  location            = "${var.rglocation}"
  resource_group_name = "${var.rgname}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.subnet}"
  resource_group_name  = "${var.rgname}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefixes     = ["${var.subnet_cidr_prefix}"]
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_nic}"
  location            = "${var.rglocation}"
  resource_group_name = "${var.rgname}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.devrg.location
  resource_group_name   = azurerm_resource_group.devrg.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}