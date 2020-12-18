
#Management VPC
output "mgt_aws_endpoint_01" {
  value = module.mgt.aws_tunnel_ip_01
}

output "mgt_aws_endpoint_02" {
  value = module.mgt.aws_tunnel_ip_02
}

output "mgt_gcp_endpoint_01" {
  value = module.mgt.gcp_vpn_ip
}

#Development VPC
output "dev_aws_endpoint_01" {
  value = module.dev.aws_tunnel_ip_01
}

output "dev_aws_endpoint_02" {
  value = module.dev.aws_tunnel_ip_02
}

output "dev_gcp_endpoint_01" {
  value = module.dev.gcp_vpn_ip
}

#Staging VPC
output "stg_aws_endpoint_01" {
  value = module.stg.aws_tunnel_ip_01
}

output "stg_aws_endpoint_02" {
  value = module.stg.aws_tunnel_ip_02
}

output "stg_gcp_endpoint_01" {
  value = module.stg.gcp_vpn_ip
}

# Production VPC
output "prd_aws_endpoint_01" {
  value = module.prd.aws_tunnel_ip_01
}

output "prd_aws_endpoint_02" {
  value = module.prd.aws_tunnel_ip_02
}

output "prd_gcp_endpoint_01" {
  value = module.prd.gcp_vpn_ip
}

