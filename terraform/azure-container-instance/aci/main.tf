resource "random_string" "container_name" {
  length  = 25
  lower   = true
  upper   = false
  special = false
}

// create virtual network
resource "azurerm_virtual_network" "aci_vnet" {
  name = "myVNet"
  address_space = ["10.0.0.0/16"]
  location = var.rg.location
  resource_group_name =  var.rg.name
}

// create subnet for the private container
resource "azurerm_subnet" "aci_subnet" {
  name                 = "mySubnet"
  resource_group_name  = var.rg.name
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

// Containers Group
resource "azurerm_container_group" "container" {
  name                = "${var.container_group_name_prefix}-${random_string.container_name.result}"
  location            = var.rg.location
  resource_group_name = var.rg.name
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
  image_registry_credential {
    username = var.acr_username
    password = var.acr_password
    server = "containerregistry0131234123.azurecr.io"
  }
}
