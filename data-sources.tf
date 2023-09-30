/*
  AWS Data Sources
*/
data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "aws_iam_account_alias" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

/*
  Policy Documents
*/
data "aws_iam_openid_connect_provider" "github_actions" {
  for_each = var.create_oidc_provider ? toset([]) : toset(["enabled"])
  url      = var.github_actions_provider_configuration.url
}

data "aws_iam_policy" "administrator_access" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy_document" "github_actions_policy_document" {
  dynamic "statement" {
    for_each = var.policy_statements.enabled && length(keys(var.policy_statements.statements)) > 0 ? var.policy_statements.statements : tomap({})
    content {
      sid       = "${local.name_prefix_title}${statement.key}"
      effect    = statement.value["effect"]
      actions   = statement.value["actions"]
      resources = statement.value["resources"]
    }
  }

  dynamic "statement" {
    for_each = var.policy_statements_deny.enabled && length(keys(var.policy_statements_deny.statements)) > 0 ? var.policy_statements_deny.statements : tomap({})
    content {
      sid       = "${local.name_prefix_title}${statement.key}"
      effect    = statement.value["effect"]
      actions   = statement.value["actions"]
      resources = statement.value["resources"]
    }
  }
}

data "aws_iam_policy_document" "github_actions_role_policy_document" {
  for_each = var.create_iam_roles ? local.github_subs_by_role : tomap({})
  statement {
    sid    = "${local.name_prefix_title}${each.key}"
    effect = "Allow"
    principals {
      identifiers = [local.aws_iam_openid_connect_provider.arn]
      type        = "Federated"
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringLike"
      values   = each.value
      variable = "${local.github_url_without_protocols}:sub"
    }
    condition {
      test     = "StringLike"
      values   = ["sts.amazonaws.com"]
      variable = "${local.github_url_without_protocols}:aud"
    }
  }
}
