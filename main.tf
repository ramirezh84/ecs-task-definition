#ECS Task Definition
#https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html

resource "aws_ecs_task_definition" "task_definition" {
  container_definitions = var.container_definition
  family = var.container_family
  network_mode = var.network_mode
  requires_compatibilities = var.requires_compatiblities
  execution_role_arn = var.execution_role_arn
  task_role_arn = var.task_role_arn
  dynamic "volume" {
    for_each = var.volumes
    content {
      name = volume.value.name
      host_path = volume.value.host_path
    }
  }
}

#Cloudwatch log group
#https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CloudWatchLogsConcepts.html

resource "aws_cloudwatch_log_group" "log_group" {
  count = var.create_log_group == true ? 1 : 0
  name = "/ecs/${var.container_family}"
}