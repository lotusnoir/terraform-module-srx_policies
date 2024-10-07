// We create the application ports depending of all ports found in policy rules + port_groups. We should so strictly have the ones declared and needed.
// In case we need to declare extra port, the variable "ports" is made for that

resource "junos_applications" "global" {
  count = length(local.applications_present_on_file) == 0 ? 0 : 1

  application {
    name     = "ICMP"
    protocol = "icmp"
  }

  dynamic "application" {
    for_each = toset(local.applications_present_on_file)
    iterator = app
    content {
      name = app.key
      // NO multi protocols here
      // If SRC in name we inverse source and dest port
      protocol         = length(regexall("TCP-UDP", app.value)) == 0 ? lower(element(split("_", app.value), 0)) : null
      source_port      = length(regexall("TCP-UDP", app.value)) == 0 ? "0-65535" : null
      destination_port = length(regexall("TCP-UDP", app.value)) == 0 ? length(regexall("-", element(split("_", app.value), 1))) > 0 ? element(split("_", app.value), 1) : "${element(split("_", app.value), 1)}-${element(split("_", app.value), 1)}" : null
      dynamic "term" {
        // if item in ports contains TCP-UDP we create an object with 2 terms tcp and udp, if not we pass the value
        // for_each = length(regexall("TCP-UDP", each.value)) > 0 ? [each.value, each.value] : [each.value]
        for_each = length(regexall("TCP-UDP", app.value)) > 0 ? [app.value, app.value] : []
        iterator = term
        content {
          name             = "t${term.key + 1}"
          source_port      = "0-65535"
          protocol         = length(regexall("TCP-UDP", term.value)) > 0 && term.key == 0 ? "tcp" : length(regexall("TCP-UDP", term.value)) > 0 && term.key == 1 ? "udp" : lower(element(split("_", term.value), 0))
          destination_port = length(regexall("-", element(split("_", term.value), 1))) > 0 ? element(split("_", term.value), 1) : "${element(split("_", term.value), 1)}-${element(split("_", term.value), 1)}"
        }
      }
    }
  }

  dynamic "application_set" {
    for_each = var.port_groups
    iterator = appset
    content {
      name         = appset.key
      applications = appset.value

    }
  }
}
