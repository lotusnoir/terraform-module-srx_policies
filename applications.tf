// We create the application ports depending of all ports found in policy rules + port_groups. We should so strictly have the ones declared and needed.
// In case we need to declare extra port, the variable "ports" is made for that
resource "junos_application" "this" {
  for_each = toset(local.application_list)
  name     = each.value

  dynamic "term" {
    // if item in ports contains TCP-UDP we create an object with 2 terms tcp and udp, if not we pass the value
    for_each = length(regexall("TCP-UDP", each.value)) > 0 ? [each.value, each.value] : [each.value]
    iterator = app

    content {
      name             = "t${app.key + 1}"
      source_port      = "0-65535"
      protocol         = length(regexall("TCP-UDP", app.value)) > 0 && app.key == 0 ? "tcp" : length(regexall("TCP-UDP", app.value)) > 0 && app.key == 1 ? "udp" : lower(element(split("_", app.value), 0))
      destination_port = length(regexall("-", element(split("_", app.value), 1))) > 0 ? element(split("_", app.value), 1) : element(split("_", app.value), 1) - element(split("_", app.value), 1)
    }
  }
}

// As we cant guess the ports defined inside a group, this must be done manually
resource "junos_application_set" "this" {
  depends_on = [junos_application.this]

  for_each     = var.port_groups
  name         = each.key
  applications = each.value
}
