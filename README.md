# GitHub Actions AWS IAM Assume Role with Provider OIDC

## Pre-Requirements

### Terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.github_actions_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.github_actions_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_account_alias.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_account_alias) | data source |
| [aws_iam_openid_connect_provider.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_policy.administrator_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.github_actions_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.github_actions_role_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role_name"></a> [assume\_role\_name](#input\_assume\_role\_name) | AWS IAM Assume Role Name | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment Name. Which runtime owns the resource? This is used for cost analysis and support. | `string` | n/a | yes |
| <a name="input_github_actions_provider_configuration"></a> [github\_actions\_provider\_configuration](#input\_github\_actions\_provider\_configuration) | OpenID Connect Provider Configuration | <pre>object({<br>    client_id_list  = optional(list(string), ["sts.amazonaws.com", ])<br>    thumbprint_list = optional(list(string), ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd", ])<br>    url             = optional(string, "https://token.actions.githubusercontent.com")<br>  })</pre> | n/a | yes |
| <a name="input_github_repositories_map"></a> [github\_repositories\_map](#input\_github\_repositories\_map) | AWS IAM Detach Policies | <pre>map(object({<br>    repositories = optional(map(object({<br>      role_name        = optional(string, null)<br>      allowed_branches = optional(list(string), ["*"])<br>      environment      = optional(list(string), ["*"])<br>      pull_requests    = optional(list(string), ["*"])<br>    })), {})<br>  }))</pre> | n/a | yes |
| <a name="input_create_iam_roles"></a> [create\_iam\_roles](#input\_create\_iam\_roles) | Whether or not to create IAM Role. | `bool` | `true` | no |
| <a name="input_create_oidc_provider"></a> [create\_oidc\_provider](#input\_create\_oidc\_provider) | Whether or not to create the associated oidc provider. If true, variable 'oidc\_provider\_arn' is required | `bool` | `true` | no |
| <a name="input_environment_prefix"></a> [environment\_prefix](#input\_environment\_prefix) | Environment Name Prefix. | `string` | `null` | no |
| <a name="input_force_detach_policies"></a> [force\_detach\_policies](#input\_force\_detach\_policies) | AWS IAM Detach Policies | `bool` | `true` | no |
| <a name="input_iam_role_description"></a> [iam\_role\_description](#input\_iam\_role\_description) | AWS IAM Role Description | `string` | `"GitHub Organization Account Assume Role"` | no |
| <a name="input_iam_role_max_session_duration"></a> [iam\_role\_max\_session\_duration](#input\_iam\_role\_max\_session\_duration) | Max Session Duration in Seconds | `number` | `7200` | no |
| <a name="input_market"></a> [market](#input\_market) | Country Name. Which country owns the resource? This is used for cost analysis and support. | `string` | `"br"` | no |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | ARN of the github actions AWS oidc provider. Used if create\_oidc\_provider is true | `string` | `null` | no |
| <a name="input_policy_statement_deny"></a> [policy\_statement\_deny](#input\_policy\_statement\_deny) | Policy Statement Deny | <pre>object({<br>    actions   = list(string)<br>    resources = list(string)<br>  })</pre> | `null` | no |
| <a name="input_policy_statements"></a> [policy\_statements](#input\_policy\_statements) | Policy Statements | <pre>object({<br>    enabled = optional(bool, false)<br>    statements = optional(map(object({<br>      effect    = optional(string, "Allow")<br>      actions   = optional(list(string), ["*"])<br>      resources = optional(list(string), ["*"])<br>    })), {})<br>  })</pre> | `{}` | no |
| <a name="input_policy_statements_deny"></a> [policy\_statements\_deny](#input\_policy\_statements\_deny) | Policy Statements Deny | <pre>object({<br>    enabled = bool<br>    statements = map(object({<br>      effect    = string<br>      actions   = list(string)<br>      resources = list(string)<br>    }))<br>  })</pre> | <pre>{<br>  "enabled": true,<br>  "statements": {<br>    "GitHubActionsExplicitlyDenySelectedIAMActions": {<br>      "actions": [<br>        "ce:*",<br>        "iam:DeleteUserPermissionsBoundary",<br>        "iam:DeleteVirtualMFADevice",<br>        "iam:PassRole"<br>      ],<br>      "effect": "Deny",<br>      "resources": [<br>        "*"<br>      ]<br>    }<br>  }<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | AWS Tags | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_actions_policy_document"></a> [github\_actions\_policy\_document](#output\_github\_actions\_policy\_document) | GitHub Actions IAM Policy Document |
| <a name="output_github_actions_role"></a> [github\_actions\_role](#output\_github\_actions\_role) | GitHub Actions Role |
| <a name="output_github_actions_role_policy_document"></a> [github\_actions\_role\_policy\_document](#output\_github\_actions\_role\_policy\_document) | GitHub Actions Role Policy Document |
| <a name="output_github_repositories_map"></a> [github\_repositories\_map](#output\_github\_repositories\_map) | GitHub Repositories Map |
| <a name="output_github_subs_by_role"></a> [github\_subs\_by\_role](#output\_github\_subs\_by\_role) | GitHub Subs By Role |
| <a name="output_iam_github_actions_provider"></a> [iam\_github\_actions\_provider](#output\_iam\_github\_actions\_provider) | GitHub Actions IAM OpenID Connect |
| <a name="output_iam_role"></a> [iam\_role](#output\_iam\_role) | AWS IAM role |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of the created IAM Role |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | Name of the created IAM Role |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | OIDC provider ARN |
| <a name="output_policy_statements"></a> [policy\_statements](#output\_policy\_statements) | AWS IAM Policy Statements |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Author

[Elio Severo Junior](https://github.com/elioseverojunior)
