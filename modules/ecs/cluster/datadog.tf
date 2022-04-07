locals {

  datadog_ecs_agent_task_def = <<EOF
{
  "name": "datadog-agent",
  "image": "${var.datadog_image}",
  "essential": false,
  "memoryReservation": 256,
  "cpu": 10,
  "mountPoints": [],
  "volumesFrom": [],
  "portMappings": [
    {
      "containerPort": 8125,
      "hostPort": 8125,
      "protocol": "udp"
    },
    {
      "containerPort": 8126,
      "hostPort": 8126,
      "protocol": "tcp"
    }
  ],
  "environment": [
    {
      "name": "ECS_FARGATE",
      "value": "true"
    },
    {
      "name": "DD_LOG_LEVEL",
      "value": "warn"
    },
    {
      "name": "DD_APM_ENABLED",
      "value": "true"
    },
    {
      "name": "DD_APM_NON_LOCAL_TRAFFIC",
      "value": "true"
    },
    {
      "name": "DD_SYSTEM_PROBE_ENABLED",
      "value": "true"
    },
    {
      "name": "DD_PROCESS_AGENT_ENABLED",
      "value": "true"
    },
    {
      "name": "DD_HEALTH_PORT",
      "value": "5555"
    },
    {
      "name": "DD_APM_RECEIVER_PORT",
      "value": "8126"
    },
    {
      "name": "DD_DOGSTATSD_NON_LOCAL_TRAFFIC",
      "value": "true"
    },
    {
      "name": "DD_LOGS_CONFIG_CONTAINER_COLLECT_ALL",
      "value": "true"
    },
    {
      "name": "DD_DOGSTATSD_PORT",
      "value": "8125"
    },
    {
      "name": "DD_DOCKER_LABELS_AS_TAGS",
      "value": "${replace(jsonencode(var.tags), "\"", "\\\"")}"
    }
  ],
  "secrets": [
    {
      "name": "DD_API_KEY",
      "valueFrom": "${aws_ssm_parameter.datadog_key.arn}"
    }
  ],
  ${module.firelens_log_config.log_configuration}
}
EOF
}