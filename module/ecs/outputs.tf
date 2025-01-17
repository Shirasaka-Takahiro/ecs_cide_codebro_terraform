output "ecs_cluster_arn" {
  value = aws_ecs_cluster.cluster.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.service.name
}