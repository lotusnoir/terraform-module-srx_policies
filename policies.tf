resource "junos_security_global_policy" "global" {
  count = length(local.global_rules) == 0 ? 0 : 1
  depends_on = [
    junos_application.this,
    junos_application_set.this,
    junos_security_address_book.global
  ]

  dynamic "policy" {
    for_each = local.global_rules
    iterator = rule

    content {
      name = rule.key

      match_from_zone           = rule.value.from_zone
      match_source_address      = rule.value.source
      match_to_zone             = rule.value.to_zone
      match_destination_address = rule.value.destination
      match_application         = rule.value.application
    }
  }
}


module "policy_zone" {
  source = "./submodule-policy_zone"

  depends_on = [
    junos_application.this,
    junos_application_set.this,
    junos_security_address_book.global
  ]

  // for each zones containing rules
  for_each = toset(keys({ for k, v in local.zone_list_policy_rules : k => v if v != {} }))

  // we set the starting zone and the rules associated
  from_zone = each.value
  rules     = local.zone_list_policy_rules[each.value]

  // the to_zone list to loop is equal to the sum of unique to_zone values in available rules
  zone_list = flatten(distinct([for zone in local.zone_list_policy_rules[each.value] : zone["to_zone"]]))
}
