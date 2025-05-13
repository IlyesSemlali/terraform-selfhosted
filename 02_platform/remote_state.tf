data "terraform_remote_state" "foundation" {
  backend = "local"

  config = {
    path = "../01_foundation/terraform.tfstate"
  }
}

