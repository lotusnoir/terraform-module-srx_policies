locals {
  // if one of from_zone and to_zone are equal to any or more than 2 items
  global_rules = { for k, v in var.policy_rules : k => v if((length(v.from_zone) > 1 || v.from_zone == ["any"]) || (length(v.to_zone) > 1 || v.to_zone == ["any"])) }

  // if from_zone AND to_zone equals 1 item that is not any
  zone_rules = { for k, v in var.policy_rules : k => v if(length(v.from_zone) == 1 && length(v.to_zone) == 1 && v.from_zone != ["any"] && v.to_zone != ["any"]) }

  // affect to each zones the from_zone policy rules
  zone_list_policy_rules = { for subnet in var.zone_list :
    subnet => { for k, v in local.zone_rules : k => v if v.from_zone == [subnet] }
  }

  // list of uniq application ports retrieved from policy rules + ports_groups and merge them with extra vat.ports in uniq_application
  application_fromrules = distinct(flatten([for rule in var.policy_rules : rule["application"]]))
  application_fromset   = distinct(flatten([for grpset in var.port_groups : grpset]))
  application_list      = [for port in sort(distinct(flatten(concat([var.ports], [local.application_fromrules], [local.application_fromset])))) : port if length(regexall("^(TCP|UDP|TCP-UDP)_[0-9]+", port)) > 0]

  // list of uniq vms retrieved from rules
  addressbook_fromrules_src = setsubtract(distinct(flatten([for rule in var.policy_rules : rule["source"]])), ["any"])
  addressbook_fromrules_dst = setsubtract(distinct(flatten([for rule in var.policy_rules : rule["destination"]])), ["any"])
  addressbook_fromset       = distinct(flatten([for grpset in var.addressbook_groups : grpset]))
  addressbook_list          = [for obj in sort(distinct(flatten(concat([var.vms_list], [local.addressbook_fromrules_src], [local.addressbook_fromrules_dst], [local.addressbook_fromset])))) : obj if length(regexall("^(vm-|fwv-)", obj)) > 0]
}
