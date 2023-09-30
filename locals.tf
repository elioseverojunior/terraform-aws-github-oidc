locals {
  aws_iam_openid_connect_provider = var.create_oidc_provider ? try(aws_iam_openid_connect_provider.github_actions["enabled"], null) : try(data.aws_iam_openid_connect_provider.github_actions["enabled"], null)

  github_orgs = {
    for org_name, org_data in var.github_repositories_map : org_name => merge(local.org_defaults, org_data)
  }

  github_orgs_with_repos = {
    for org_name, org_data in local.github_orgs : org_name => merge(
      {
        for key, val in org_data : key => val if key != "repositories"
      },
      {
        "repositories" = {
          for repo_name, repo_data in org_data["repositories"] : repo_name => merge(local.repo_defaults_by_org[org_name], repo_data)
        }
      }
    )
  }

  github_subs = flatten([
    for org_name, org_data in local.github_orgs_with_repos : [
      for repo_name, repo_data in org_data["repositories"] : {
        role_name : try(repo_data["role_name"], null) != null && try(repo_data["role_name"], "") != "" ? repo_data["role_name"] : var.assume_role_name
        github_subs : sort(distinct(compact(flatten([
          concat(
            [for branch in repo_data["allowed_branches"] : format("repo:%s/%s:ref:refs/heads/%s", org_name, repo_name, branch)],
            [for env in repo_data["environment"] : format("repo:%s/%s:environment:%s", org_name, repo_name, env)],
            try(repo_data["pull_requests"], null) != null && try(repo_data["pull_requests"], "") != "" ? [for repo_pull_request in repo_data["pull_requests"] : format("repo:%s/%s:pull_request", org_name, repo_pull_request)] : []
          )
        ]))))
      }
    ]
  ])

  github_subs_by_role = {
    for role in local.roles_names : role =>
    flatten(matchkeys([for el in local.github_subs : el["github_subs"]], [for el in local.github_subs : try(el["role_name"], var.assume_role_name)], [role]))
  }

  org_defaults = {}

  permissions_map = flatten([
    for org_name, org_data in local.github_orgs_with_repos : [
      for repo_name, repo_data in org_data["repositories"] : {
        role_name : try(repo_data["role_name"], null) != null && try(repo_data["role_name"], "") != "" ? repo_data["role_name"] : var.assume_role_name
        github_subs : sort(distinct(compact(flatten([
          [
            for branch in repo_data["allowed_branches"] : format("repo:%s/%s:ref:refs/heads/%s", org_name, repo_name, branch)
          ]
        ]))))
      }
    ]
  ])

  roles_names = distinct([
    for role in local.github_subs : role["role_name"]
  ])

  repo_defaults_by_org = {
    for org_name, org_data in local.github_orgs : org_name => {
      for key, val in org_data : key => val if key != "repositories"
    }
  }

  name_prefix                  = var.environment_prefix != null && var.environment_prefix != "" ? trimsuffix(var.environment_prefix, "-") : ""
  name_prefix_title            = title(local.name_prefix)
  name_prefix_dash             = format("%s-", local.name_prefix)
  name_prefix_dash_title       = title(format("%s-", local.name_prefix_title))
  github_url_without_protocols = replace(replace(var.github_actions_provider_configuration.url, "http://", ""), "https://", "")
}
