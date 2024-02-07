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
data "azurerm_resource_group" "rg1" {
    name = "Demo-RG"
}

data "azurerm_virtual_network" "vnet1" {
    name =  "Demo-Vnet"
    resource_group_name =  data.azurerm_resource_group.rg1.name
}

data "azurerm_subnet" "subnet1" {
    name =  Demo-Subnet1
    resource_group_name =  data.azurerm_resource_group.rg1.name   
    virtual_network_name =  data.azurerm_virtual_network.vnet1.name
}

resource "azurerm_network_security_group" "nsg1" {
    name = "Demo-Nsg1"
    resource_group_name = "${data.azurerm_resource_group.rg1.name}"
    location = "${data.azurerm_resource_group.rg1.location}"  
}

#NOTE: this allow RDP from any network
resource "azurerm_network_security_rule" "rdp" {
    name = "rdp"
    resource_group_name = "${data.azurerm_reource_group.rg1.name}"
    network_security_group_name = "${azurerm_network_security_group.nsg1.name}"
    priority =  102
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "3389"
    source_address_prefix = "*"
    destination_address_prefix = "*"
}

resource "azurerm_subnet_network_security_group_association" "nsg_subnet_assoc" {
    subnet_id = data.azurerm_subnet.subnet1.id
    network_security_group_id = azurerm_network_security_group.nsg1.id
}

resource "azurerm_network_interface" "nic1" {
    name = "${var.prefix}-nic"
    resource_group_name = azurerm_resource_group.rg1.name
    location = azurerm_resource_group.rg1.location

    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.subnet1.id
      private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_windows_virtual_machine" "main" {
    name = "Demo-VM1"
    resource_group_name = data.azurerm_resource_group.rg1.name
    location = data.azurerm_resource_group.rg1.location
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

