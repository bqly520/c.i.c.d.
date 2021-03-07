variable "prefix" {
  type = string
  default = "bobo"
}

variable "location" {
  type = string
  default = "westus2"
}

variable "sshpub" {
  type = string
}

variable "node_count" {
  type = string
  default = 3
}