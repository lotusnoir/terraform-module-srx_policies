variable "domain" {
  description = "addresse boot domain extension"
  type        = string
  default     = ""
}


variable "ports" {
  description = "list of application port to create"
  type        = list(string)
  default     = []
}

variable "port_groups" {
  description = "map of list of applications-set to create"
  type        = map(list(string))
  default     = {}
}

variable "vms_list" {
  description = "list of address-book to create"
  type        = list(string)
  default     = []
}

variable "addressbook_groups" {
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
  #type    = map(map(list(string)))
  type    = any
  default = {}
}

variable "zone_list" {
  description = "list of all available zones"
  type        = list(string)
  default     = []
}
