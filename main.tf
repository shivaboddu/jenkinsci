provider "azurerm" {
  features {}
}

provider "azuread" {
  tenant_id = "57d876f5-444c-465f-b8c9-b2c243391724"
}

terraform { 
 required_providers { 
     azurerm = { 
         source = "hashicorp/azurerm"
         version = ">= 2.96.0" 
     } 
 } 
}

locals {

tag_names = [
    "Application Name",
    "Cost Center",
    "Environment",
  ]
  resourceGrpId = [ "/subscriptions/48a110e7-ce15-46d2-b83a-e0fe9552d996/resourceGroups/myfirstrg",
     "/subscriptions/48a110e7-ce15-46d2-b83a-e0fe9552d996/resourceGroups/mysecondrg"]
  policy_set = {for val in setproduct(local.tag_names, local.resourceGrpId):
                "${val[0]}-${val[1]}" => val}

  subscriptionId = [ "/subscriptions/48a110e7-ce15-46d2-b83a-e0fe9552d996"]
  policy_set1 = {for val in setproduct(local.tag_names, local.subscriptionId):
                "${val[0]}-${val[1]}" => val}
}


resource "azurerm_subscription_policy_assignment" "RequireTagsRg" { 
	for_each     = local.policy_set1
	name         = "Require_rg_tag_${lower(replace(each.value[0], " ", "_"))}"
	subscription_id = each.value[1]
	policy_definition_id = var.policyidReqTagSub
	description = "Require each.value[0] tag on resource group" 
	display_name = "Require Tags on resource group "
	location = "central India"
	identity {
		type = "SystemAssigned"
	}
	parameters = <<PARAMS
		{
		"tagName": {
			"value": "${each.value[0]}"
		}
		}
	PARAMS
}

resource "azurerm_resource_group_policy_assignment" "inheritTagsRg" { 
	for_each     = local.policy_set
	name         = "inherit_rg_tag_${lower(replace(each.value[0], " ", "_"))}"
	resource_group_id = each.value[1]
	policy_definition_id = var.policyidInTagRg 
	description = "Inherit application tag from resource group for newly created resources" 
	display_name = "Inherit Tags from resource group "
	location = "central India"
	identity {
		type = "SystemAssigned"
	}
	parameters = <<PARAMS
		{
		"tagName": {
			"value": "${each.value[0]}"
		}
		}
	PARAMS
}
