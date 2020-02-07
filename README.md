# AWS Elastic Container Service (ECS) - Task Definition  Terraform module

Terraform module that creates a container task definition

## Pre-requirements
***
- To be used in conjunction with the "Task Definition JSON" module
- If __awsvpc__ network mode is used, please refer to the __Elastic Network Interface Trunking__ section
- For more information on the task definition JSON document, please see  [link][link1]

## Important notes
***
- __Testing__: Conducted with containers using the "EC2 Launch Type"
- __Logging__: The type of information that is logged by the containers in your task depends mostly on their ENTRYPOINT command.
  By default, the logs that are captured show the command output that you would normally see in an interactive terminal if you ran the container locally,
  which are the STDOUT and STDERR I/O streams. The awslogs log driver simply passes these logs from Docker to CloudWatch Logs

## Elastic Network Interface Trunking
***
Each Amazon ECS task that uses the __awsvpc__ network mode receives its own elastic network interface (ENI), which is attached to the container instance that hosts it. 
There is a default limit to the number of network interfaces that can be attached to an Amazon EC2 instance, and the primary network interface counts as one.\
For example, by default a __c5.large__ instance may have up to three ENIs attached to it. The primary network interface for the instance counts as one, so you can attach an additional two ENIs to the instance. Because each task using the awsvpc network mode requires an ENI, you can typically only run two such tasks on this instance type.
Amazon ECS supports launching container instances with increased ENI density using supported Amazon EC2 instance types. When you use these instance types and opt in to the __awsvpcTrunking__ account setting, additional ENIs are available on newly launched container instances. This configuration allows you to place more tasks using the awsvpc network mode on each container instance.\
Using this feature, a __c5.large__ instance with __awsvpcTrunking__ enabled has an increased ENI limit of twelve. The container instance will have the primary network interface and Amazon ECS creates and attaches a "trunk" network interface to the container instance. So this configuration allows you to launch ten tasks on the container instance instead of the current two tasks.
The trunk network interface is fully managed by Amazon ECS and is deleted when you either terminate or deregister your container instance from the cluster
To enable __awsvpcTrunking__ mode, please run the following command from the AWS CLI and make sure the right region is specified.
```
aws ecs put-account-setting-default --name awsvpcTrunking --value enabled --region us-east-1
```

## Volumes
***
When you register a task definition, you can optionally specify a list of volumes to be passed to the Docker daemon on a container instance,
which then becomes available for access by other containers on the same container instance\
The following are the types of data volumes that can be used:

* __Docker volumes__: A Docker-managed volume that is created under /var/lib/docker/volumes on the container instance.\
Docker volume drivers (also referred to as plugins) are used to integrate the volumes with external storage systems, such as Amazon EBS. The built-in local volume driver or a third-party volume driver can be used. Docker volumes are only supported when using the EC2 launch type

* __Bind mounts__:  A file or directory on the host machine is mounted into a container. Bind mount host volumes are supported when using either the EC2 or Fargate launch types. To use bind mount host volumes, specify a host and optional sourcePath value in your task definition.

## Module Inputs

| Name | Description | Type | Default | Required |
|------|:-------------:|:----:|:-----:|:-----:|
| name_tag | EFS name | string | n/a | yes |
| appid_tag | Application ID | number | n/a | yes |
| env_tag | Environment ID (Dev/QA/Prod) | string | n/a | yes |
| awsaccount_tag | AWS Account number | string | n/a | yes |
| function_tag | Function or purpose of the instance | string | n/a | yes |
| created_by | Created by ID e-number@lpsvcs.com | string | n/a | yes |
| container_definition | Container definition JSON | string | n/a | yes |
| requires_compatibilities | Requires compatibilities flag EC2/Fargate | list(string) | n/a | yes |
| volumes | Volumes to be mounted to the container | list(object) | n/a | yes |
| task_role_arn | IAM role ARN for Task Role | string | n/a | yes | 
| execution_role_arn | IAM role ARN for Execution Role | string | n/a | yes |
| network_mode | Network Mode for ECS container | string | n/a | yes | 
| container_family | Container name, for grouping purposes | n/a | yes | 
| create_log_group | Log group creation flag | bool | true | no |

## Usage

```hcl
module "ecs-task-definition" {
  source = "../../ecs-task-definition"
  container_definition = module.task-definition-json.json
  container_family = "nginx"
  execution_role_arn = "${aws_iam_role.ecs_task_iam_role.arn}"
  network_mode = "awsvpc"
  requires_compatiblities = ["EC2"]
  task_role_arn = "${aws_iam_role.ecs_task_iam_role.arn}"
  volumes = [
    {
      name = "certs"
      host_path = "/mnt/efs/certs/"
    },
    {
      name = "service-configs"
      host_path = "/mnt/efs/service-configs"
    }
  ]
}
```

## Outputs

| Name | Description |
|------|-------------|
| task_definition_arn | Task definition ARN |
| task_definition_log_group | Task definition log group in CloudWatch |

[//]: # (References)
   [link1]: <https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create-task-definition.html>
