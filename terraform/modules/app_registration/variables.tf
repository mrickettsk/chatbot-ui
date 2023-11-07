variable "environment" {
  type        = string
  description = "The environment context"
}

variable "project" {
  type        = string
  description = "The project name"
}

variable "location" {
  type        = string
  description = "The location resources should be provisioned withins"
}

variable "name" {
  type        = string
  description = "The name of the app being created within app service"
}