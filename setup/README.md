# setup

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 2.20 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 2.1 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 2.20 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backend"></a> [backend](#module\_backend) | ../modules/backend | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_list_ipv4"></a> [allow\_list\_ipv4](#input\_allow\_list\_ipv4) | The allowed list of IPs for accessing the cluster | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_api_image"></a> [api\_image](#input\_api\_image) | The docker image of the nerves\_hub\_api app | `string` | `"nerveshub/nerves_hub_api:latest"` | no |
| <a name="input_api_service_desired_count"></a> [api\_service\_desired\_count](#input\_api\_service\_desired\_count) | The number of NervesHubAPI containers to run | `string` | `"1"` | no |
| <a name="input_billing_enabled"></a> [billing\_enabled](#input\_billing\_enabled) | Enable billing? | `bool` | `false` | no |
| <a name="input_billing_image"></a> [billing\_image](#input\_billing\_image) | The docker image of the nerves\_hub\_billing app | `string` | `"nerveshub/nerves_hub_billing:latest"` | no |
| <a name="input_billing_service_desired_count"></a> [billing\_service\_desired\_count](#input\_billing\_service\_desired\_count) | The number of NervesHubBilling containers to run | `string` | `"1"` | no |
| <a name="input_bucket"></a> [bucket](#input\_bucket) | AWS S3 Bucket name for Terraform state | `any` | n/a | yes |
| <a name="input_bucket_prefix"></a> [bucket\_prefix](#input\_bucket\_prefix) | AWS S3 Bucket prefix for application state buckets | `any` | n/a | yes |
| <a name="input_ca_db_name"></a> [ca\_db\_name](#input\_ca\_db\_name) | The name of the CA database | `string` | `"nerves_hub_ca"` | no |
| <a name="input_ca_image"></a> [ca\_image](#input\_ca\_image) | The docker image of the nerves\_hub\_ca app | `string` | `"nerveshub/nerves_hub_ca:latest"` | no |
| <a name="input_ca_service_desired_count"></a> [ca\_service\_desired\_count](#input\_ca\_service\_desired\_count) | The number of NervesHubCA containers to run | `string` | `"1"` | no |
| <a name="input_db_allocated_storage"></a> [db\_allocated\_storage](#input\_db\_allocated\_storage) | n/a | `number` | `20` | no |
| <a name="input_db_engine_version"></a> [db\_engine\_version](#input\_db\_engine\_version) | The Engine version of the Postgres database server | `string` | `"11.4"` | no |
| <a name="input_db_instance_class"></a> [db\_instance\_class](#input\_db\_instance\_class) | The Instance class of the Postgres database server | `string` | `"db.t2.small"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Database password | `any` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Database username | `any` | n/a | yes |
| <a name="input_device_image"></a> [device\_image](#input\_device\_image) | The docker image of the nerves\_hub\_device app | `string` | `"nerveshub/nerves_hub_device:latest"` | no |
| <a name="input_device_service_desired_count"></a> [device\_service\_desired\_count](#input\_device\_service\_desired\_count) | The number of NervesHubDevice containers to run | `string` | `"1"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain name | `any` | n/a | yes |
| <a name="input_dynamodb_table"></a> [dynamodb\_table](#input\_dynamodb\_table) | AWS DynamoDB table for state locking | `any` | n/a | yes |
| <a name="input_erl_cookie"></a> [erl\_cookie](#input\_erl\_cookie) | The Erlang distribution cookie value | `any` | n/a | yes |
| <a name="input_key"></a> [key](#input\_key) | Key for Terraform state at S3 bucket | `any` | n/a | yes |
| <a name="input_log_retention"></a> [log\_retention](#input\_log\_retention) | Cloud watch log retention days | `number` | `90` | no |
| <a name="input_operators"></a> [operators](#input\_operators) | n/a | `list(string)` | n/a | yes |
| <a name="input_profile"></a> [profile](#input\_profile) | AWS profile | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `any` | n/a | yes |
| <a name="input_web_db_name"></a> [web\_db\_name](#input\_web\_db\_name) | The name of the web database | `string` | `"nerves_hub_web"` | no |
| <a name="input_web_secret_key_base"></a> [web\_secret\_key\_base](#input\_web\_secret\_key\_base) | The secret key base for sessions | `any` | n/a | yes |
| <a name="input_web_smtp_password"></a> [web\_smtp\_password](#input\_web\_smtp\_password) | The SES SMTP password | `any` | n/a | yes |
| <a name="input_web_smtp_username"></a> [web\_smtp\_username](#input\_web\_smtp\_username) | The SES SMTP username | `any` | n/a | yes |
| <a name="input_www_image"></a> [www\_image](#input\_www\_image) | The docker image of the nerves\_hub\_www app | `string` | `"nerveshub/nerves_hub_www:latest"` | no |
| <a name="input_www_live_view_signing_salt"></a> [www\_live\_view\_signing\_salt](#input\_www\_live\_view\_signing\_salt) | The signing salt to use for Phoenix LiveView | `any` | n/a | yes |
| <a name="input_www_service_desired_count"></a> [www\_service\_desired\_count](#input\_www\_service\_desired\_count) | The number of NervesHubWWW containers to run | `string` | `"1"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
