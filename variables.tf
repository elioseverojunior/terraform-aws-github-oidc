variable "assume_role_name" {
  description = "AWS IAM Assume Role Name"
  type        = string
}

variable "market" {
  description = "Country Name. Which country owns the resource? This is used for cost analysis and support."
  type        = string
  validation {
    condition = anytrue([
      var.market == "ar" || var.market == "AR",
      var.market == "au" || var.market == "AU",
      var.market == "br" || var.market == "BR",
      var.market == "cl" || var.market == "CL",
      var.market == "las" || var.market == "LAS",
      var.market == "latam" || var.market == "LATAM",
      var.market == "us" || var.market == "US",
      var.market == "uy" || var.market == "UY",
    ])
    error_message = "Must have a valid country code, can be au|AU, br|BR, las|LAS, us|US."
  }
  default = "br"
}

variable "environment" {
  description = "Environment Name. Which runtime owns the resource? This is used for cost analysis and support."
  type        = string
  validation {
    condition = anytrue([
      var.environment == "snd",
      var.environment == "dev",
      var.environment == "sit",
      var.environment == "pre",
      var.environment == "prd",
      var.environment == "prod",
      var.environment == "nickel",
      var.environment == "bronze",
      var.environment == "silver",
      var.environment == "gold",
      var.environment == "platinum",
      var.environment == "bronze-data",
      var.environment == "silver-data",
      var.environment == "gold-data",
      var.environment == "experiments",
      var.environment == "sharedtools",
    ])
    error_message = "Must have a valid environment, can be snd, dev, sit, pre, prd, nickel, bronze, silver, gold, platinum, bronze-data, silver-data, gold-data, experiments, sharedtools."
  }
}

variable "environment_prefix" {
  description = "Environment Name Prefix."
  type        = string
  default     = null
}

variable "create_oidc_provider" {
  description = "Whether or not to create the associated oidc provider. If true, variable 'oidc_provider_arn' is required"
  type        = bool
  default     = true
}

variable "oidc_provider_arn" {
  description = "ARN of the github actions AWS oidc provider. Used if create_oidc_provider is true"
  type        = string
  default     = null
}

variable "create_iam_roles" {
  description = "Whether or not to create IAM Role."
  type        = bool
  default     = true
}

variable "github_actions_provider_configuration" {
  description = "OpenID Connect Provider Configuration"
  type = object({
    client_id_list  = optional(list(string), ["sts.amazonaws.com", ])
    thumbprint_list = optional(list(string), ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd", ])
    url             = optional(string, "https://token.actions.githubusercontent.com")
  })
}

variable "github_repositories_map" {
  description = "AWS IAM Detach Policies"
  type = map(object({
    repositories = optional(map(object({
      role_name        = optional(string, null)
      allowed_branches = optional(list(string), ["*"])
      environment      = optional(list(string), ["*"])
      pull_requests    = optional(list(string), ["*"])
    })), {})
  }))
}

variable "policy_statements" {
  description = "Policy Statements"
  type = object({
    enabled = optional(bool, false)
    statements = optional(map(object({
      effect    = optional(string, "Allow")
      actions   = optional(list(string), ["*"])
      resources = optional(list(string), ["*"])
    })), {})
  })
  default = {}
}

variable "policy_statement_deny" {
  description = "Policy Statement Deny"
  type = object({
    actions   = list(string)
    resources = list(string)
  })
  default = null
}

variable "policy_statements_deny" {
  description = "Policy Statements Deny"
  type = object({
    enabled = bool
    statements = map(object({
      effect    = string
      actions   = list(string)
      resources = list(string)
    }))
  })
  default = {
    enabled = true
    statements = {
      GitHubActionsExplicitlyDenySelectedIAMActions = {
        effect = "Deny"
        actions = [
          "ce:*",
          "iam:DeleteUserPermissionsBoundary",
          "iam:DeleteVirtualMFADevice",
          "iam:PassRole",
        ]
        resources = ["*"]
      }
    }
  }
}

variable "iam_role_description" {
  description = "AWS IAM Role Description"
  type        = string
  default     = "GitHub Organization Account Assume Role"
}

variable "iam_role_max_session_duration" {
  description = "Max Session Duration in Seconds"
  type        = number
  validation {
    condition     = (var.iam_role_max_session_duration >= 3600 && var.iam_role_max_session_duration < 43200)
    error_message = "Invalid IAM Role Max Session Duration value. It must be greater or equal than \"3600\" (1 hour) and less than \"43200\" (12 hours)."
  }
  default = 7200
}

variable "force_detach_policies" {
  description = "AWS IAM Detach Policies"
  type        = bool
  default     = true
}

/*
  TAGS
*/
variable "tags" {
  description = "AWS Tags"
  type        = map(any)
  default     = {}
}
