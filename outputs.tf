output "tamr_config_file" {
  value       = local.default_tamr_config
  description = "Rendered Tamr custom config"
  sensitive = true
}
