// use locals for customizing vars
locals {
  suffix_main       = "${data.terraform_remote_state.network.outputs.project_code}-${terraform.workspace}-${data.terraform_remote_state.network.outputs.region_code}"
  suffix_concat     = "${data.terraform_remote_state.network.outputs.project_code}${terraform.workspace}${data.terraform_remote_state.network.outputs.region_code}"
  tags              = merge(data.terraform_remote_state.network.outputs.tags, { "env" = terraform.workspace })
  vm_admin_username = "${data.terraform_remote_state.network.outputs.project_code}${terraform.workspace}vmadmin"
}

