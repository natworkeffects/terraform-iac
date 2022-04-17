#################################
###### [VIRTUAL MACHINES] ######
#################################

// vm password
output "vm_password" {
  value       = random_password.vm_password.result
  sensitive   = true
  description = "vm password"
}

