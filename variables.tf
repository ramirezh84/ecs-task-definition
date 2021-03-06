# ECS Task Definition Variables
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html

#General variables

variable "name_tag" {
  description = "Environment Name"
  type        = string
}

variable "appid_tag" {
  description = "Identifier for the application using the instance"
  type        = string
}

variable "env_tag" {
  description = "Environment(s) that this parameter will be referenced."
  type        = string
}

variable "awsaccount_tag" {
  description = "Account Name"
  type        = string
}

variable "function_tag" {
  description = "Function or purpose of the instance"
  type        = string
}

variable "createdby_tag" {
  description = "e-number@lpsvcs.com"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

#Module Specific Variables

variable "container_definition" {
  description = "Container definition JSON"
}

variable "container_family" {
  description = "Name for multiple versions of the task definition"
  type        = string
}

variable "network_mode" {
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host"
  type        = string
}

variable "requires_compatiblities" {
  description = "Requires compatiblities flag EC2/Fargate"
  type        = list(string)
}

variable "execution_role_arn" {
  description = "IAM role that allows the containers in the task to pull container images and publish container logs to CloudWatch on your behalf"
  type        = string
}

variable "task_role_arn" {
  description = "IAM role that allows the containers in the task permission to call the AWS APIs that are specified in its associated policies on your behalf"
  type        = string
}

variable "volumes" {
  description = "Specify volumes that can be mounted to the container"
  type = list(object({
    name      = string
    host_path = string
  }))
}

variable "create_log_group" {
  description = "Create log group for task definition"
  type = bool
  default = true
}