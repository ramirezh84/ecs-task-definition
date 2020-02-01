#Task Definition Outputs

output "task_definition_arn" {
  value = aws_ecs_task_definition.task_definition.arn
}

#CloudWatch Log Group

output "task_definition_log_group" {
  value = aws_cloudwatch_log_group.log_group.name
}