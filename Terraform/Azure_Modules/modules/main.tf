terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "2.46.0"
        }
    }
}

#Configure the Microsoft Azure Provider
provider "azurerm" {
    features {}
    subscription_id = ""
    client_id = ""
    client_secret = ""
    tenant_id = ""
}

#create resource group
resource "azurerm_resource_group" "rg" {
    name = "${var.rgname}"
    location = "${var.location}"
    tags = {
        Environment = "Terraform Demo"
    }
}

resource "azurerm_virtual_network" "vnet1" {
    name = "${var.prefix}-10"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    location = "${azurerm_resource_group.rg.location}"
    address_space = ["${var.vnet_cidr_prefix}"]
}

resource "azurerm_subnet" "subnet1" {
    name = var.subnet
    virtual_network_name = "${azurerm_virtual_network.vnet1.name}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    address_prefixes = ["${var.subnet1_cidr_prefix}"]
}

resource "azurerm_network_security_group" "nsg1" {
    name ="${var.prefix}-nsg1"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    location ="${azurerm_resource_group.rg.location}"  
}

#NOTE: this allow RDP from any network
resource "azurerm_network_security_rule" "rdp" {
    name = "rdp"
    resource_group_name = "${azurerm_reource_group.rg.name}"
    network_security_group_name = "${azurerm_network_security_group.nsg1.name}"
    priority = "102"
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "3389"
    source_address_prefix = "*"
    destination_address_prefix = "*"
}

resource "azurerm_subnet_network_security_group_association" "nsg_subnet_assoc" {
    subnet_id = azurerm_subnet.subnet1.id
    network_security_group_id = azurerm_network_security_group.nsg1.id
}

resource "azurerm_network_interface" "nic1" {
    name = "${var.prefix}-nic"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location

    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.subnet1.id
      private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_windows_virtual_machine" "main" {
    name = "${var.prefix}-vmt01"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    size = "Standard_B1s"
    admin_username = "adminuser"
    admin_password = "P@ssword1234"
    network_interface_ids = [azurerm_network_interface.nic1.id]

    source_image_reference {
      publisher = "MicrosoftWindowsServer"
      offer = "WindowsServer"
      sku = "2019-Datacenter"
      version = "latest"
    }

    os_disk{
        storage_account_type = "Standard_LRS"
        caching = "ReadWrite"
    }
}

