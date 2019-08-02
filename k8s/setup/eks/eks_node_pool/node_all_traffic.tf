resource "aws_security_group" "nodes_all_traffic" {
  name        = "node-all-traffic-${var.cluster_name}-${var.environment}"
  description = "Additional security group attached to nodes in the cluster to allow all intra-cluster to-and-fro traffic"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = "${var.private_subnet_cidrs}"
    
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "${var.private_subnet_cidrs}"
  }

  tags = "${
    map(
     "Name", "node-all-traffic-${var.cluster_name}-${var.environment}",
    )
  }"
}
