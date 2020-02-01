
variable "container_definition" {
  description = "Container definition"
}


variable "requires_compatiblities" {
  type = list(string)
}

variable "volumes" {
  type = list(object({
    name        = string
    host_path   = string
  }))
}

variable "task_role_arn" {
  type = string
}
variable "execution_role_arn" {
  type = string
}
variable "network_mode" {
  type = string
}
variable "container_family" {
  type = string
}
