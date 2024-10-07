variable "domain" {
  description = "dns address domain extension for the automated rule extract addressbook"
  type        = string
}

#variable "cluster" {
#  description = "srx in cluster mode or not to determine the regex"
#  type        = bool
#  default     = false
#}

variable "ports" {
  description = "list of application port to create, if you choose add custom one not from extracted ones"
  type        = list(string)
  default     = []
}

variable "port_groups" {
  description = "map of list of applications-set to create"
  type        = map(list(string))
  default     = {}
}

variable "addressbook_groups" {
  description = "map of list of address-book-set to create"
  type        = map(list(string))
  default     = {}
}
variable "addressbook_groupsofgroups" {
  description = "map of list of address-book-set to create"
  type        = map(list(string))
  default     = {}
}


variable "addressbook_network" {
  description = "map of extra address-book in network format to create"
  type        = map(string)
  default     = {}
}

variable "addressbook_dns" {
  description = "map of extra address-book in dns format to create"
  type        = map(string)
  default     = {}
}

variable "addressbook_range" {
  description = "map of extra address-book in range format to create"
  type        = map(list(string))
  default     = {}
}

variable "policy_rules" {
  description = "policies to create, objects application and address-book are extracted and created automatically"
  type = map(object({
    from_zone                          = optional(set(string))
    source                             = optional(set(string))
    to_zone                            = optional(set(string))
    destination                        = optional(set(string))
    application                        = optional(set(string))
    action                             = optional(string, "permit")
    count                              = optional(bool, true)
    log_init                           = optional(bool)
    log_close                          = optional(bool)
    match_destination_address_excluded = optional(bool)
    match_dynamic_application          = optional(set(string))
    match_source_address_excluded      = optional(bool)
    match_source_end_user_profile      = optional(string)
    permit_tunnel_ipsec_vpn            = optional(string)
  }))
  default = {}
}

//variable "all_zones" {
//  description = "list of all available zones"
//  type        = list(string)
//  default     = []
//}
variable "adressbook_extract" {
  description = "Extract dns from rules of just add the one in var.addressbook_dns"
  type        = bool
  default     = true
}
