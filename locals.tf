locals {
  // if one of from_zone and to_zone are equal to any or more than 2 items
  global_rules = { for k, v in var.policy_rules : k => v if((length(v.from_zone) > 1 || flatten(v.from_zone) == ["any"]) || (length(v.to_zone) > 1 || flatten(v.to_zone) == ["any"])) }

  // if from_zone AND to_zone have just 1 item not equal to any
  zone_rules = { for k, v in var.policy_rules : k => v if(length(v.from_zone) == 1 && length(v.to_zone) == 1 && flatten(v.from_zone) != ["any"] && flatten(v.to_zone) != ["any"]) }

  // build list of all security zones from the logical interfaces
  //all_logical_interfaces          = flatten([for k, v in data.junos_interfaces_physical_present.this.interfaces : v.logical_interface_names])
  //all_logical_interfaces_filtered = toset([for val in local.all_logical_interfaces : val if length(regexall("32767", val)) == 0])
  //all_zones                       = flatten([for k in local.all_logical_interfaces_filtered : data.junos_interface_logical.this[k].security_zone])

  // build all zones combinations
  //zones_to_zones_combinaison = toset([
  //  for p in setproduct(local.all_zones, local.all_zones) : join("_-_", p)
  //  if p[0] != p[1]
  //])

  ///////////////////////////////
  // Add direction value on zone_rules and regoup them
  zone_rules_direction = { for key, value in local.zone_rules :
    key => merge(value, { direction = join("_-_", concat(tolist(value.from_zone), tolist(value.to_zone))) })
  }
  zone_rules_direction_transposed = transpose({ for policy, values in local.zone_rules_direction : policy => [values.direction] })
  // rebuild zone_rules grouped by direction
  zone_rules_grouped = {
    for direction, policies in local.zone_rules_direction_transposed : direction => {
      for pol_name in policies : pol_name => local.zone_rules_direction[pol_name] if(local.zone_rules_direction[pol_name].direction == direction)
    }
  }

  // list of uniq application ports retrieved from policy rules + ports_groups and merge them with extra vat.ports in uniq_application
  application_fromrules        = distinct(flatten([for rule in var.policy_rules : rule["application"]]))
  application_fromset          = distinct(flatten([for grpset in var.port_groups : grpset]))
  applications_present_on_file = [for port in sort(distinct(flatten(concat([var.ports], [local.application_fromrules], [local.application_fromset])))) : port if length(regexall("^(TCP|UDP|TCP-UDP)_[0-9]+", port)) > 0]
  #applications_present_on_srx  = sort(distinct(flatten([for k, v in data.junos_applications.all.applications : v.name])))
  #applications_to_add = setsubtract(local.applications_present_on_file, local.applications_present_on_srx)


  // list of uniq vms retrieved from rules
  addressbook_fromrules_src = setsubtract(distinct(flatten([for rule in var.policy_rules : rule["source"]])), ["any"])
  addressbook_fromrules_dst = setsubtract(distinct(flatten([for rule in var.policy_rules : rule["destination"]])), ["any"])
  addressbook_fromset       = distinct(flatten([for grpset in var.addressbook_groups : grpset]))
  addressbook_list          = var.adressbook_extract == true ? [for obj in sort(distinct(flatten(concat([local.addressbook_fromrules_src], [local.addressbook_fromrules_dst], [local.addressbook_fromset])))) : obj if length(regexall("^(vm-|fwv-)", obj)) > 0] : []
}
