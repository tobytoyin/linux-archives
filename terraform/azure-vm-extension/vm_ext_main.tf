// setting up commands to run after deployment is completed
resource "azurerm_virtual_machine_extension" "vm_ext" {
  name                 = "create_myDirectory_at_root"
  virtual_machine_id   = azurerm_linux_virtual_machine.my_terraform_vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  // run some mkdir commands
  // JSON format see: https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-linux
  settings = <<SETTINGS
    {
    "commandToExecute": "mkdir /home/${var.username}/myDirectory"
    }
    SETTINGS

}
