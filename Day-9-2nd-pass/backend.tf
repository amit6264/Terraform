terraform {
  backend "s3" {
    bucket = "amit-patidar-12321"
    key    = "terraform.tfstate"
    region = "eu-north-1"

    use_lockfile = true
  }
}