variable "working_directory" {
  type = string
}

variable "temp_directory" {
  type = string
}

variable "Configuration" {
  type = map(any)
}

variable "KeyPair" {
  type = string
}

variable "getpass" {
  type = bool
}

variable "iam_role" {
  type = string
}

variable "accountID" {
  type = string
}

variable "InstanceName" {
  type = string
}