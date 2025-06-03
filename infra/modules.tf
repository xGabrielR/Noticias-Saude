module "aws" {
  source = "./modules/aws"
}

module "snowflake" {
  source = "./modules/snowflake"
  
  depends_on = [module.aws]
  
}