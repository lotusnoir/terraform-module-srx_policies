// for debug only, the input vars
#output "var_ports" { value = var.ports }
#output "var_vms_list" { value = var.vms_list }
#output "var_policy_rules" { value = var.policy_rules }

// locals transformations
// policies
#output "global_rules" { value = local.global_rules }
#output "zone_rules" { value = local.zone_rules }
#output "zone_list_policy_rules" { value = local.zone_list_policy_rules }

// objects
#output "application_fromrules" { value = local.application_fromrules }
#output "application_fromset" { value = local.application_fromset }
#output "application_list" { value = local.application_list }
#output "addressbook_fromrules_src" { value = local.addressbook_fromrules_src }
#output "addressbook_fromrules_dst" { value = local.addressbook_fromrules_dst }
#output "addressbook_fromset" { value = local.addressbook_fromset }
#output "addressbook_list" { value = local.addressbook_list }
