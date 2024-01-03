output "tamr-config" {
  value     = module.tamr-config.tamr_config_file
  sensitive = true
}
