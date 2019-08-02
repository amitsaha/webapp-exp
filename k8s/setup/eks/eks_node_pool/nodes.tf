resource "aws_iam_role" "node" {
  name = "${var.service_name}-${var.environment}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.node.name}"
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.node.name}"
}

resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.node.name}"
}

resource "aws_iam_instance_profile" "node" {
  name = "${var.service_name}-${var.environment}"
  role = "${aws_iam_role.node.name}"
}

resource "aws_security_group" "node" {
  name        = "${var.service_name}-${var.environment}"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "${var.service_name}-${var.environment}-node",
     "kubernetes.io/cluster/${var.cluster_name}", "owned",
    )
  }"
}

resource "aws_security_group_rule" "node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.node.id}"
  source_security_group_id = "${aws_security_group.node.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.node.id}"
  source_security_group_id = "${var.cluster_security_group_id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${var.cluster_security_group_id}"
  source_security_group_id = "${aws_security_group.node.id}"
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "node-ingress-ssh" {
  description       = "Allow SSH into the worker nodes from VPN"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.node.id}"
  cidr_blocks       = "${var.private_access_ip}"
  to_port           = 22
  type              = "ingress"
}

data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.cluster_version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

# This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.
data "aws_region" "current" {}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We implement a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh \
    --apiserver-endpoint '${var.cluster_endpoint}' \
    --b64-cluster-ca '${var.cluster_certificate_authority}' \
    --kubelet-extra-args --node-labels=nodegroup=${var.service_name},environment=${var.environment} \
     '${var.cluster_name}'  
USERDATA
}

resource "aws_launch_configuration" "nodes" {
  associate_public_ip_address = false
  iam_instance_profile        = "${aws_iam_instance_profile.node.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "t3.large"
  name_prefix                 = "${var.service_name}-${var.environment}"
  security_groups             = [
      "${aws_security_group.node.id}",
      "${var.node_all_traffic_security_group_id}",
  ]
  user_data_base64            = "${base64encode(local.node-userdata)}"
  key_name                    = "${var.ssh_key_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "nodes" {
  desired_capacity     = "${var.node_pool_desired}"
  launch_configuration = "${aws_launch_configuration.nodes.id}"
  max_size             = "${var.node_pool_max}"
  min_size             = "${var.node_pool_min}"
  name                 = "${var.service_name}-${var.environment}-nodes"
  vpc_zone_identifier  = ["${var.private_subnet_ids}"]

  tag {
    key                 = "Name"
    value               = "${var.service_name}${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}

output "node_security_group_id" {
    value = "${aws_security_group.node.id}"
}
