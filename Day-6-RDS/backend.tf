terraform {
  backend "s3" {
    bucket = "tf-state-file-locking-amit"
    key    = "terraform.tfstate"
    region = "eu-north-1"
   
    # Enable S3 native locking
    use_lockfile = true   #tf version should be above 1.10
    # The dynamodb_table argument is no longer needed
    # dynamodb_table = "terraform-state-lock-dynamo"

  }
}