resource "azurerm_resource_group" "hello-vijay" {
    name = "hello-vijay" 
    location = "West Europe"
}

resource "azuread_user" "example" {
  user_principal_name = "mayur@vijaysakhare1outlook.onmicrosoft.com"
  display_name        = "mayur"
  password            = "Vijay@123#"
}

resource "azurerm_role_assignment" "examplerole" {
  scope                = azurerm_resource_group.hello-vijay.id
  role_definition_name = "Reader"
  principal_id         = azuread_user.example.id
}


# CUSTOM ROLE CREATE AND ASSIGN

data "azurerm_subscription" "customroleassginment" {
}

resource "azurerm_role_definition" "custom_role" {
  name        = "custom_role"
  scope       = data.azurerm_subscription.customroleassginment.id
  description = "This is a custom role created via Terraform"

  permissions {
    actions     =  [ "Microsoft.Compute/*/read",
    "Microsoft.Compute/virtualMachines/start/action",
    "Microsoft.Compute/virtualMachines/restart/action" ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.customroleassginment.id, # /subscriptions/00000000-0000-0000-0000-000000000000
  ]
}

resource "azurerm_role_assignment" "custome-role" {
  scope                = azurerm_resource_group.hello-vijay.id
  role_definition_name = "custom_role"
  principal_id         = azuread_user.example.id
}
