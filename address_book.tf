// in global we create vms object extracted from rules and we can also add more
resource "junos_security_address_book" "global" {
  count = length(local.addressbook_list) == 0 ? length(merge(var.addressbook_dns, var.addressbook_network)) == 0 ? 0 : 1 : 1
  name  = "global"

  // Dynamic block with extracted values
  dynamic "dns_name" {
    for_each = local.addressbook_list
    iterator = item
    content {
      name  = item.value
      value = "${item.value}.${var.domain}"
    }
  }

  dynamic "dns_name" {
    for_each = var.addressbook_dns
    content {
      name  = dns_name.key
      value = dns_name.value
      #      description = dns_name.description
    }
  }

  dynamic "address_set" {
    for_each = var.addressbook_groups
    content {
      name    = address_set.key
      address = address_set.value
    }
  }

  dynamic "address_set" {
    for_each = var.addressbook_groupsofgroups
    content {
      name        = address_set.key
      address_set = address_set.value
    }
  }

  dynamic "network_address" {
    for_each = var.addressbook_network
    content {
      name  = network_address.key
      value = network_address.value
    }
  }

  dynamic "range_address" {
    for_each = var.addressbook_range
    content {
      name = range_address.key
      from = range_address.from
      to   = range_address.to
    }
  }

}
