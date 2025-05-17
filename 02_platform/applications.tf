locals {
  applications = data.terraform_remote_state.foundation.outputs.applications
}
