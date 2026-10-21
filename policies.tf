###########################################
### GLOBAL
###########################################
resource "junos_security_global_policy" "global" {
  count = var.ordered_global_policy == true ? length(local.global_rules) == 0 ? 0 : 1 : 0
  depends_on = [
    junos_applications.global,
    junos_security_address_book.global
  ]

  dynamic "policy" {
    for_each = local.global_rules

    iterator = rule
    content {
      name                      = rule.key
      match_from_zone           = rule.value.from_zone
      match_source_address      = rule.value.source
      match_to_zone             = rule.value.to_zone
      match_destination_address = rule.value.destination
      match_application         = rule.value.application
      then                      = rule.value.action
      count                     = true
      log_init                  = rule.value.log_init
      log_close                 = rule.value.log_close
    }
  }
  // add explicit deny_all at the end, ressource must be ordered
  policy {
    name                      = "deny_all"
    match_from_zone           = ["any"]
    match_to_zone             = ["any"]
    match_source_address      = ["any"]
    match_destination_address = ["any"]
    match_application         = ["any"]
    then                      = "deny"
    count                     = true
    log_init                  = true
  }
}

resource "junos_security_global_policy_unordered" "global" {
  count = var.ordered_global_policy == false ? length(local.global_rules) == 0 ? 0 : 1 : 0
  depends_on = [
    junos_applications.global,
    junos_security_address_book.global
  ]

  dynamic "policy" {
    for_each = local.global_rules

    iterator = rule
    content {
      name                      = rule.key
      match_from_zone           = rule.value.from_zone
      match_source_address      = rule.value.source
      match_to_zone             = rule.value.to_zone
      match_destination_address = rule.value.destination
      match_application         = rule.value.application
      then                      = rule.value.action
      count                     = true
      log_init                  = rule.value.log_init
      log_close                 = rule.value.log_close
    }
  }
  // add explicit deny_all at the end, ressource must be ordered
  policy {
    name                      = "deny_all"
    match_from_zone           = ["any"]
    match_to_zone             = ["any"]
    match_source_address      = ["any"]
    match_destination_address = ["any"]
    match_application         = ["any"]
    then                      = "deny"
    count                     = true
    log_init                  = true
  }
}



###########################################
// Zone to zone rules
###########################################
resource "junos_security_policy" "this" {
  depends_on = [
    junos_applications.global,
    junos_security_address_book.global
  ]
  // for each zone to zones
  for_each = { for k, v in local.zone_rules_grouped : k => v if var.ordered_policy }
  #for_each = local.zone_rules_grouped

  from_zone = split("_-_", each.key)[0]
  to_zone   = split("_-_", each.key)[1]

  dynamic "policy" {
    for_each = each.value
    content {
      name                               = policy.key
      match_source_address               = policy.value.source
      match_destination_address          = policy.value.destination
      then                               = policy.value.action
      count                              = policy.value.count
      log_init                           = policy.value.log_init
      log_close                          = policy.value.log_close
      match_application                  = policy.value.application
      match_destination_address_excluded = policy.value.match_destination_address_excluded
      match_dynamic_application          = policy.value.match_dynamic_application
      match_source_address_excluded      = policy.value.match_source_address_excluded
      match_source_end_user_profile      = policy.value.match_source_end_user_profile
      permit_tunnel_ipsec_vpn            = policy.value.permit_tunnel_ipsec_vpn
      dynamic "permit_application_services" {
        for_each = policy.value.permit_application_services != null ? [policy.value.permit_application_services] : []
        content {
          security_intelligence_policy = permit_application_services.value.security_intelligence_policy
          idp_policy                   = permit_application_services.value.idp_policy
        }
      }
    }
  }
}

resource "junos_security_policy_unordered" "this" {
  depends_on = [
    junos_applications.global,
    junos_security_address_book.global
  ]
  // for each zone to zones
  for_each = { for k, v in local.zone_rules_grouped : k => v if !var.ordered_policy }
  #for_each = local.zone_rules_grouped

  from_zone = split("_-_", each.key)[0]
  to_zone   = split("_-_", each.key)[1]

  dynamic "policy" {
    for_each = each.value
    content {
      name                               = policy.key
      match_source_address               = policy.value.source
      match_destination_address          = policy.value.destination
      then                               = policy.value.action
      count                              = policy.value.count
      log_init                           = policy.value.log_init
      log_close                          = policy.value.log_close
      match_application                  = policy.value.application
      match_destination_address_excluded = policy.value.match_destination_address_excluded
      match_dynamic_application          = policy.value.match_dynamic_application
      match_source_address_excluded      = policy.value.match_source_address_excluded
      match_source_end_user_profile      = policy.value.match_source_end_user_profile
      permit_tunnel_ipsec_vpn            = policy.value.permit_tunnel_ipsec_vpn
      dynamic "permit_application_services" {
        for_each = policy.value.permit_application_services != null ? [policy.value.permit_application_services] : []
        content {
          security_intelligence_policy = permit_application_services.value.security_intelligence_policy
          idp_policy                   = permit_application_services.value.idp_policy
        }
      }
    }
  }
}
