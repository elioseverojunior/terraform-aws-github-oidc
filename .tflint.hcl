config {
  module = true
  force  = true
}

plugin "terraform" {
  enabled = true
  preset  = "recommended"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
  version = "0.4.0"
}

plugin "aws" {
  deep_check = true
  enabled    = true
  source     = "github.com/terraform-linters/tflint-ruleset-aws"
  version    = "0.27.0"
}

rule "terraform_naming_convention" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = true
}

rule "terraform_workspace_remote" {
  enabled = true
}
