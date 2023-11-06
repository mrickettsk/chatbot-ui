variable "location" {
  type    = string
  default = "uksouth"
}

variable "project" {
  type    = string
  default = "chatbot-ui"
}

variable "environment" {
  type    = string
  default = "stable"
}

variable "image_tag" {
  type    = string
  default = "main"
}

variable "openai_api_key" {
  type        = string
  description = "The Azure OpenAI API key to use for the chatbot"
  sensitive   = true
}

variable "openai_api_url" {
  type        = string
  description = "The Azure OpenAI API URL to use for the chatbot"
  sensitive   = true
}