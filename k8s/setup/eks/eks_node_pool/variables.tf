variable "cluster_name" {  
  type    = "string"
}

variable "cluster_version" {
    type = "string"
}

variable "cluster_certificate_authority" {
    type = "string"
}

variable "cluster_endpoint"{
    type = "string"
}

variable "cluster_security_group_id" {
    type = "string"
}

variable "vpc_id" {
    default = "vpc-ce7b04a5"
    type = "string"
}

variable "node_pool_desired" {
    default = "1"
    type = "string"  
}

variable "node_pool_min" {
    default = "1"
    type = "string"  
}

variable "node_pool_max" {
    default = "1"
    type = "string"
  
}
variable "private_subnet_ids" {
    default = [
        "subnet-e8082383",
        "subnet-914634dc",
        "subnet-00bfde7d",
    ]
    type = "list"
}

variable "node_all_traffic_security_group_id" {
    type = "string"
}

variable "service_name" {
    type = "string"
  
}

variable "environment" {  
    type = "string"  
}


