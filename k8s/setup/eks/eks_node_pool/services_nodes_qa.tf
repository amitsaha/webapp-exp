module "services_nodes" {
  source = "../../../../../modules/eks_node_pool"
  service_name = "services"
  cluster_name = "${aws_eks_cluster.cluster.name}"
  environment = "qa"
  cluster_version = "${aws_eks_cluster.cluster.version}"
  cluster_certificate_authority = "${aws_eks_cluster.cluster.certificate_authority.0.data}"
  cluster_endpoint = "${aws_eks_cluster.cluster.endpoint}"
  cluster_security_group_id = "${aws_security_group.cluster.id}"
  node_all_traffic_security_group_id = "${aws_security_group.nodes_all_traffic.id}"
}
