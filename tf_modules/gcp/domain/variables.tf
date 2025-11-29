variable "main_domain" {
  description = "Main DNS domain for the SelfHosted platform"
  type        = string
}

variable "project_owner_email" {
  description = "Platform Owner's email"
  type        = string
}

variable "project_owner_phone_number" {
  description = "Platform Owner's phone number"
  type        = string
}

variable "project_owner_address" {
  description = "Platform Owner's postal address"
  type = object(
    {
      region_code   = string
      locality      = string
      postal_code   = string
      recipients    = list(string)
      address_lines = list(string)
    }
  )
}

variable "gcp_domain_price" {
  description = "DNS Domain Yearly pricing in dollars"
  type        = number
}

variable "name_servers" {
  description = "DNS Name Servers for the domain registration"
  type        = list(string)
}
