variable "domain" {
  description = "DNS Domain "
  type        = string
}

variable "name" {
  description = "Authentik application name"
  type        = string
}

variable "description" {
  description = "Application description"
  type        = string
}

variable "group" {
  description = "Authentik application group"
  type        = string
}

variable "auth_type" {
  description = "Type of authentication"
  type        = string
}

variable "oauth_redirect_uris" {
  description = "List of redirection URIs for OAuth2 config"
  type        = list(string)
}

variable "oauth_scopes" {
  description = "Space seperated list of OAuth2 scopes to allow"
  type        = string
}

variable "oauth_signing_key" {
  description = "OAuth2 signing key"
  type        = string
}

variable "authentik_authorization_flow" {
  description = "Authentik authorization_flow"
  type        = string
}

variable "authentik_invalidation_flow" {
  description = "Authentik invalidation_flow"
  type        = string
}
