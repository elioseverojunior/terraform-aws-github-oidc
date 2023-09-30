output "github_actions_role_policy_document" {
  description = "GitHub Actions Role Policy Document"
  value       = data.aws_iam_policy_document.github_actions_role_policy_document
}

output "github_actions_role" {
  description = "GitHub Actions Role"
  value       = aws_iam_role.github_actions
}

output "iam_github_actions_provider" {
  description = "GitHub Actions IAM OpenID Connect"
  value       = local.aws_iam_openid_connect_provider
}

output "github_actions_policy_document" {
  description = "GitHub Actions IAM Policy Document"
  value       = data.aws_iam_policy_document.github_actions_policy_document
}

output "iam_role" {
  description = "AWS IAM role"
  value       = aws_iam_role.github_actions
}

output "iam_role_arn" {
  description = "ARN of the created IAM Role"
  value = {
    for k, v in local.github_subs_by_role :
    k => aws_iam_role.github_actions[k].arn
  }
}

output "iam_role_name" {
  description = "Name of the created IAM Role"
  value = {
    for k, v in local.github_subs_by_role :
    k => aws_iam_role.github_actions[k].name
  }
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN"
  value       = local.aws_iam_openid_connect_provider
}

output "github_subs_by_role" {
  description = "GitHub Subs By Role"
  value       = local.github_subs_by_role
}

output "github_repositories_map" {
  description = "GitHub Repositories Map"
  value       = var.github_repositories_map
}

output "policy_statements" {
  description = "AWS IAM Policy Statements"
  value       = var.policy_statements
}
