output "vm_name" {
  value = module.vm.name
}

output "resource_group" {
  value = module.rg.name
}

output "admin_password" {
  description = "Auto-generated admin password (only set when ssh_public_key variable is not provided)"
  value       = var.ssh_public_key == null ? module.vm.admin_password : null
  sensitive   = true
}