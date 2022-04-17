########################
###### [SYNAPSE] ######
########################

// synapse password
output "syn_password" {
  value       = random_password.syn_password.result
  sensitive   = true
  description = "synapse password"
}

