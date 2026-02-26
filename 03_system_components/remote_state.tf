data "terraform_remote_state" "foundation" {
  backend = "local"

  config = {
    path = "../01_foundation/terraform.tfstate"
  }
}

data "terraform_remote_state" "platform" {
  backend = "local"

  config = {
    path = "../02_platform//terraform.tfstate"
  }
}
