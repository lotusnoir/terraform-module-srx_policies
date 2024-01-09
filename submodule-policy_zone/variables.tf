variable "from_zone" {
  type = string
}

variable "rules" {
  #type = map(map(list(string)))
  type = any
}

variable "zone_list" {
  type = list(string)
}
