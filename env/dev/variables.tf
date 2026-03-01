##Access key
variable "access_key" {
  description = "Access key"
  type        = string
}

##Secret Key
variable "secret_key" {
  description = "Secret Key"
  type        = string
}

##General Config
variable "general_config" {
  type = map(any)
  default = {
    project = "example"
    env     = "dev"
    service = "web"
  }
}

##Region
variable "region" {
  description = "Default AWS Region"
  type        = string
  default     = "ap-northeast-1"
}

##Network
variable "vpc" {
  description = "CIDR BLOCK for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type = map(any)
  default = {
    availability_zones = {
      az-1a = {
        az = "ap-northeast-1a"
      },
      az-1c = {
        az = "ap-northeast-1c"
      }
    }
  }
}

variable "public_subnets" {
  type = map(any)
  default = {
    subnets = {
      public-1a = {
        name = "public-1a",
        cidr = "10.0.10.0/24",
        az   = "ap-northeast-1a"
      },
      public-1c = {
        name = "public-1c",
        cidr = "10.0.30.0/24",
        az   = "ap-northeast-1c"
      }
    }
  }
}

variable "dmz_subnets" {
  type = map(any)
  default = {
    subnets = {
      dmz-1a = {
        name = "dmz-1a",
        cidr = "10.0.20.0/24",
        az   = "ap-northeast-1a"
      },
      dmz-1c = {
        name = "dmz-1c",
        cidr = "10.0.40.0/24",
        az   = "ap-northeast-1c"
      }
    }
  }
}

variable "private_subnets" {
  type = map(any)
  default = {
    subnets = {
      private-1a = {
        name = "private-1a"
        cidr = "10.0.50.0/24"
        az   = "ap-northeast-1a"
      },
      private-1c = {
        name = "private-1c"
        cidr = "10.0.70.0/24"
        az   = "ap-northeast-1c"
      }
    }
  }
}

##Route53
variable "zone_id" {
  description = "Zone id on Route53"
  type        = string
}

variable "zone_name" {
  description = "Zone name on Route53"
  type        = list(string)
}

##ACM
variable "domain_name" {
  description = "Domain name for ACM"
  type        = string
}

variable "sans" {
  description = "Subject alternative names for ACM"
  type        = string
}

##Fargate CPU
variable "fargate_cpu" {
  description = "fargate cpu"
  type        = string
  default     = "256"
}

##Fargate Memory
variable "fargate_memory" {
  description = "fargate memory"
  type        = string
  default     = "512"
}

##Codepipeline
variable "branch_name" {
  description = "Codepipeline Github branch name"
  type        = string
  default     = "main"
}


##IAM ECS
variable "role_name_1" {
  description = "ECS IAM role name"
  type        = string
  default     = "role-fargate_task_execution"
}

variable "policy_name_1" {
  description = "ECS IAM policy name"
  type        = string
  default     = "fargate_task_execution"
}

##IAM Codebuild
variable "role_name_2" {
  description = "Codebuild IAM role name"
  type        = string
  default     = "role-codebuild-service-role"
}

variable "policy_name_2" {
  description = "Codebuild IAM policy name"
  type        = string
  default     = "build-policy"
}

##IAM Codedeploy
variable "role_name_3" {
  description = "Codedeploy IAM role name"
  type        = string
  default     = "role-codedeploy-service-role"
}

variable "policy_name_3" {
  description = "Codedeploy IAM policy name"
  type        = string
  default     = "deploy-policy"
}

##IAM Codepipeline
variable "role_name_4" {
  description = "Codepipeline IAM role name"
  type        = string
  default     = "role-codepipeline-service-role"
}

variable "policy_name_4" {
  description = "Codepipeline IAM policy name"
  type        = string
  default     = "pipeline-policy"
}