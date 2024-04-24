terraform {
  cloud {
    organization = "gd-jackstraw"

    workspaces {
      name = "mcit-capstone-qa"
    }
  }
}
