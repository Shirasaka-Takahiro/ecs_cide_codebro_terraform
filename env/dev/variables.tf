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
  }
}

##Regions
variable "regions" {
  default = {
    tokyo    = "ap-northeast-1"
  }
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

variable "private_subnets" {
  type = map(any)
  default = {
    subnets = {
      private-1a = {
        name = "private-1a"
        cidr = "10.0.20.0/24"
        az   = "ap-northeast-1a"
      },
      private-1c = {
        name = "private-1c"
        cidr = "10.0.40.0/24"
        az   = "ap-northeast-1c"
      }
    }
  }
}

##Security Group CIDR
variable "operation_sg_1_cidr" {
  default = ["0.0.0.0/0"]
}

variable "operation_sg_2_cidr" {
  default = ["0.0.0.0/0"]
}

##EC2
variable "ami" {
  description = "ID of AMI to use for ec2 instance"
  default     = "ami-0abb7b60d1c69c211"
}

variable "ec2_count" {
  description = "Number of EC2 instance"
  default     = "1"
}

variable "instance_type" {
  description = "Instance type of EC2"
  type        = string
  default     = "t3.micro"
}

variable "volume_type" {
  description = "Root block device of EC2"
  type        = string
  default     = "gp2"
}

variable "volume_size" {
  description = "Root block device size of EC2"
  default     = 100
}

variable "key_name" {
  description = "Key pair's name"
  type        = string
}

variable "public_key_path" {
  description = "Public key path. For example: ~/.ssh/terraform.pub"
  type        = string
}

##Route53
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