data "azurerm_management_group" "LZ-ROOT" {
  name = "lzroot-MG"
}


locals {
  # allowed_location_params = (file("allowed_location.json"))
  #   diag_set_params = file("diag_set.json")
  policy_assignments = jsondecode(file("built_in_policy_assignments.json"))
}

module "terraform-azurerm-buit-in-pol" {
  source = "./modules/terraform-azurerm-buit-in-pol"
  for_each = {for key,value in local.policy_assignments.built_in_policy :
              key => value}
              
             name = each.value.name
             display_name = each.value.display_name
             policy_definition_id = each.value.policy_definition_id
             scope = data.azurerm_management_group.LZ-ROOT.id
             not_scopes = each.value.not_scopes
             location = var.location
             parameters = jsonencode(each.value.parameters)
             message = each.value.non_compliance_message
             description = each.value.description


             
}

