// resource group
resource "azurerm_resource_group" "rg" {
  location = "swedencentral"
  name = "${var.resource_group_prefix}-aci"
}

// ----------- [ Create Container Registry ] ------------
resource "azurerm_container_registry" "acr" {
  name                = "containerRegistry0131234123"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Premium"
  admin_enabled       = true
}
