variable "cluster_name" {  
  type    = "string"
  default = "k8s-cluster-non-production"
}


variable "vpc_id" {
    default = "vpc-ce7b04a5"
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

variable "environment" {  
    type = "string"
    default = "non-production"
}


