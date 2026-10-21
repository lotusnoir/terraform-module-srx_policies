// auto extract vms list dns resolution to have network_address instead of dns_name
data "dns_a_record_set" "resolved" {
  for_each = var.extract_to_dns == false ? toset(local.addressbook_list) : []
  host     = "${each.value}.${var.domain}"
}

// in global we create vms object extracted from rules and we can also add more
resource "junos_security_address_book" "global" {
  count = length(local.addressbook_list) == 0 ? length(merge(var.addressbook_dns, var.addressbook_network)) == 0 ? 0 : 1 : 1
  name  = "global"

  // Dynamic block with extracted values
  dynamic "dns_name" {
    for_each = var.extract_to_dns == true ? local.addressbook_list : []
    iterator = item
    content {
      name  = item.value
      value = "${item.value}.${var.domain}"
    }
  }
  dynamic "network_address" {
    for_each = var.extract_to_dns == false ? local.addressbook_list : []
    content {
      name  = network_address.value
      value = "${data.dns_a_record_set.resolved[network_address.value].addrs[0]}/32"
    }
  }

  //------------------------------------
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

  dynamic "address_set" {
    for_each = var.addressbook_groupsmixed
    content {
      name        = address_set.key
      address     = try(var.addressbook_groupsmixed[address_set.key]["address"], null)
      address_set = try(var.addressbook_groupsmixed[address_set.key]["address_set"], null)
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
