// get all logical interfaces
#data "junos_interfaces_physical_present" "this" {
#  match_name     = var.cluster ? "^reth.*$" : "^ge-.*$"
#  match_admin_up = true
#  match_oper_up  = true
#}
#
#// get details of all
#data "junos_interface_logical" "this" {
#  for_each         = local.all_logical_interfaces_filtered
#  config_interface = each.value
#}

# Find all apps
#data "junos_applications" "all" {
#  match_name = "^(TCP|UDP|TCP-UDP)_[0-9]+"
#}
