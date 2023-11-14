output "rg_name" {
  value = azurerm_resource_group.rg.name
}

output "rg_location" {
    value = azurerm_resource_group.rg.location
}

output "rg_acr" {
    value = {
        "name": azurerm_container_registry.acr.name,
        "id": azurerm_container_registry.acr.id
    }
}
