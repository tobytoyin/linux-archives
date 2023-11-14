resource "random_string" "container_name" {
  length  = 25
  lower   = true
  upper   = false
  special = false
}

// resource group
resource "azurerm_resource_group" "rg" {
  location = "swedencentral"
  name = "${var.resoource_group_prefix}-aci"
}

// create virtual network
resource "azurerm_virtual_network" "aci_vnet" {
  name = "myVNet"
  address_space = ["10.0.0.0/16"]
  location = azurerm_resource_group.rg.location
  resource_group_name =  azurerm_resource_group.rg.name
}

// create subnet for the private container
resource "azurerm_subnet" "aci_subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.aci_vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  // allow the container network to access the subnet's networks
  delegation {
    name = "aci_delegation"
    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
    }
  }
}

// Create public IPs
resource "azurerm_public_ip" "aci_public_ip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# // Create network interface
# resource "azurerm_network_interface" "aci_nic" {
#   name                = "myNetworkInterface"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "my_nic_configuration"
#     subnet_id                     = azurerm_subnet.aci_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.aci_public_ip.id
#   }
# }

// Create Network Security Group to allow SSH into the container only
# resource "azurerm_network_security_group" "aci_sg" {
#   name                = "myNetworkSecurityGroup"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   security_rule {
#     name                       = "SSH"
#     priority                   = 1001
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

# // Connect the security group to the network interface
# resource "azurerm_network_interface_security_group_association" "example" {
#   network_interface_id      = azurerm_network_interface.aci_nic.id
#   network_security_group_id = azurerm_network_security_group.aci_sg.id
# }

// Containers Group
resource "azurerm_container_group" "container" {
  name                = "${var.container_group_name_prefix}-${random_string.container_name.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Private"
  subnet_ids = [ azurerm_subnet.aci_subnet.id ]
  os_type             = "Linux"
  restart_policy      = var.restart_policy

  container {
    name   = "${var.container_name_prefix}-${random_string.container_name.result}"
    image  = var.image
    cpu    = var.cpu_cores
    memory = var.memory_in_gb

    ports {
      port     = var.port
      protocol = "TCP"
    }
  }
}
