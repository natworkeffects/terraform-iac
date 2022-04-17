// use locals for customizing vars
locals {
  suffix_main   = "${var.project_code}-${terraform.workspace}-${var.region_code}"
  suffix_concat = "${var.project_code}${terraform.workspace}${var.region_code}"
  tags          = merge(var.tags, { "env" = terraform.workspace })
}

