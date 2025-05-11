variable "databases" {
  type = list(object({
    application = string
    component   = string
    password    = string
    extensions  = list(string)
  }))
}
