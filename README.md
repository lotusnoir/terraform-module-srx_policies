# terraform-module-srx_policies

This modules will help you creating objects in srx junos firewall.

This module DONT configure srx system or manage interfaces / security zones / policy options / routing etc.
Please check my other module terraform-module-srx_config for this

It just manage:

- policies
- application objects
- address book objects

## Application ports

### Single application port

We call application ports the input port of the vm, to simplify, we consider this elements:

Each element can be:

- protocol: tcp or udp or both
- source_port: 0-65
- destination port: single port or range

We always write them this way to be loaded by terraform:

| Single port  | Range ports     |
| ------------ | --------------- |
| TCP_xxxx     | TCP_xxx-xxx     |
| UDP_xxxx     | UDP_xxx-xxx     |
| TCP-UDP_xxxx | TCP-UDP_xxx-xxx |

All applications port are created dynamically, we extract ports from var.policy_rules + from var.port_groups.

Extra ports can be added with var.ports

        ports = ["TCP_3306", "UDP_44"]

### Groups of application ports (application-set)

When we want to groups ports, the object name must be defined like this:

PORTS_xxxxx

To create new group of applications ports:

        port_groups = {
          PORTS_titi = ["TCP_3306", "UDP_44"]
          PORTS_toto = ["UDP_44", "TCP-UDP_56"]
        }

## Address book

We can load differents objects in adress book:

    - dns_name (default for all vms starting with regex vm-)
    - network_address
    - range_address
    - wildcard_address
    - address_set

By default we dynamicaly create addressbook dns_name with the names of vms formatted in pfsv2. The object created in the firewall will always resolve the ip adress in real time to have the up-to-date ip adress and increase dynamic inventory. We extract this vms from

        var.policy_rules[source]
        var.policy_rules[destination]
        var.addressbook_groups

We dont attach address-book to a zone to avoid multiple definitions but we will make it global. Each address-book will be seen by all security zones.

Groups of address books can be set like this:

        addressbook_groups = {
            GRP_terraform = ["vm-terraform-prod-ang-01", "vm-terraform-prod-ang-02"]
            GRP_acng = ["vm-acng-prod-ang-01", "vm-acng-prod-ang-02"]
        }

A network addressbook can be set like this:

        addressbook_network = {
          eth1-titi_ang = "10.1.2.3/32"
          eth2-toto_pau = "10.2.3.4/32"
          subnet_secure-staging = "10.4.0.0/24"
        }

a dns addressbook can be set like this:

        addressbook_dns = {
          DNS_google_com = "google.com"
          DNS_microsoft = "microsoft.com"
        }

## Policies

There 2 kind of policies:

    - global (any to any or group of zone to group of zone)
    - zone to zone

Policies can be set like this:

        policy_rules = {
          zone_to_any = { # terraform acces all to ssh + winrm
            from_zone   = ["secure-staging"]
            source      = ["GRP_terraform"]
            to_zone     = ["any"]
            destination = ["any"]
            application = ["TCP_22", "TCP_8985-8986"]
          }
          any_to_multi = { #dns
            from_zone   = ["any"]
            source      = ["any"]
            to_zone     = ["common-staging", "interco_pfs"]
            destination = ["GRP_dns"]
            application = ["UDP_53"]
          }
          any_to_any = {  #consul serf
            from_zone   = ["any"]
            source      = ["any"]
            to_zone     = ["any"]
            destination = ["any"]
            application = ["TCP-UDP_8301"]
          }
          test_multi_to_multi = {
            from_zone   = ["secure-staging", "common-staging"]
            source      = ["vm-terraform-prod-pau-01", "vm-terraform-prod-ang-01"]
            to_zone     = ["secure-staging", "common-staging"]
            destination = ["vm-acng-prod-ang-01"]
            application = ["TCP_11"]
          }
          zone_to_zone = {
            from_zone   = ["apps_infra-staging"]
            source      = ["vm-titi-prod-rbx-01", "vm-toto-prod-rbx-01"]
            to_zone     = ["data-staging"]
            destination = ["vm-postgreql-db-staging-rbx-01"]
            application = ["TCP_5432"]
          }
        }
