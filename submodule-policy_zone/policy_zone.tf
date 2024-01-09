resource "junos_security_policy" "this" {
  // for all zones expect the current one
  #for_each = toset(setsubtract(var.zone_list, [var.from_zone]))
  for_each = toset(var.zone_list)

  from_zone = var.from_zone
  to_zone   = each.value

  // we create a dynamic policy for all filtered rules from_zone
  dynamic "policy" {
    for_each = {
      for k, v in var.rules : k => v if v.to_zone == [each.value]
    }
    content {
      name                      = policy.key
      match_source_address      = policy.value.source
      match_destination_address = policy.value.destination
      match_application         = policy.value.application
    }
  }
}
