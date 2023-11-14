
// ----- [ Container Varaibles ] ------
variable "resoource_group_prefix" {
  type = string
  default = "aci-rg"
}


variable "container_group_name_prefix" {
  type        = string
  description = "Prefix of the container group name that's combined with a random value so name is unique in your Azure subscription."
  default     = "acigroup"
}

variable "container_name_prefix" {
  type        = string
  description = "Prefix of the container name that's combined with a random value so name is unique in your Azure subscription."
  default     = "aci"
}

variable "image" {
  type        = string
  description = "image URI from our ACR"
  default     = "containerregistry0131234123.azurecr.io/namespace/hello-world"
}

variable "port" {
  type        = number
  description = "Port to open on the container and the public IP address."
  default     = 80
}

variable "cpu_cores" {
  type        = number
  description = "The number of CPU cores to allocate to the container."
  default     = 1
}

variable "memory_in_gb" {
  type        = number
  description = "The amount of memory to allocate to the container in gigabytes."
  default     = 2
}

variable "restart_policy" {
  type        = string
  description = "The behavior of Azure runtime if container has stopped."
  default     = "Always"
  validation {
    condition     = contains(["Always", "Never", "OnFailure"], var.restart_policy)
    error_message = "The restart_policy must be one of the following: Always, Never, OnFailure."
  }
}

variable "rg" {
  type = map
  description = "resource group id"
  default = {
    name: "aci-rg-aci",
    location: "swedencentral"
  }
}

variable "acr_username" {
  type = string
}

variable "acr_password" {
  type = string
  sensitive = true
}
