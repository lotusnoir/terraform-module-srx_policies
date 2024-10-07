// for debug only, the input vars
#output "var_ports" { value = var.ports }
#output "var_vms_list" { value = var.vms_list }
#output "var_policy_rules" { value = var.policy_rules }

// locals transformations
// policies
output "global_rules" { value = local.global_rules }
output "zone_rules" { value = local.zone_rules }
#output "all_physical_interfaces" { value = data.junos_interfaces_physical_present.this }
#output "all_logical_interfaces" { value = local.all_logical_interfaces }
#output "all_logical_interfaces_filtered" { value = local.all_logical_interfaces_filtered }
#output "all_zones" { value = local.all_zones }
output "zone_rules_direction_transposed" { value = local.zone_rules_direction_transposed }
output "zone_rules_grouped" { value = local.zone_rules_grouped }

// objects applications
output "application_fromrules" { value = local.application_fromrules }
output "application_fromset" { value = local.application_fromset }
output "applications_present_on_file" { value = local.applications_present_on_file }
#output "applications_present_on_srx"  { value = local.applications_present_on_srx }
#output "applications_to_add" { value = local.applications_to_add }

// objects addressbooks
#output "addressbook_fromrules_src" { value = local.addressbook_fromrules_src }
#output "addressbook_fromrules_dst" { value = local.addressbook_fromrules_dst }
#output "addressbook_fromset" { value = local.addressbook_fromset }
#output "addressbook_list" { value = local.addressbook_list }

// data
#output "all_zones" { value = data.junos_interfaces_physical_present.all_zones.interfaces}
#output "all_zones" { value = local.allzones}
