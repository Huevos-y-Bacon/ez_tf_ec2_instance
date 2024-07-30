# variables.tf
variable "purpose" {
  description = "name prefix"
  type        = string
  default     = null
}

variable "attach_instance_profile" {
  description = "Set to true to create an IAM Instance profile and attach to EC2"
  type        = bool
  default     = true
}

variable "attach_read_only_access" {
  description = "Set to true to attach ReadOnlyAccess policy to EC2 role"
  type        = bool
  default     = true
}

variable "attach_ssm_instance_core_access" {
  description = "Set to true to attach AmazonSSMManagedInstanceCore policy to EC2 role"
  type        = bool
  default     = true
}

variable "attach_ec2_role_for_ssm_access" {
  description = "Set to true to attach AmazonEC2RoleforSSM policy to EC2 role"
  type        = bool
  default     = false
}

variable "attach_s3_full_access" {
  description = "Set to true to attach AmazonS3FullAccess policy to EC2 role"
  type        = bool
  default     = false
}

variable "key_name" {
  description = "If null, it won't set key_name"
  type        = string
  default     = null
}

variable "graviton" {
  description = "graviton? true or false"
  type        = string
  default     = true
}

variable "size" { # t-shirt size
  description = "nano, micro, small, medium, large, etc"
  type        = string
  default     = "micro" # micro is free tier eligible
}

data "aws_ami" "al2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "architecture"
    values = [local.arch]
  }
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*"]
  }

  filter {
    name   = "architecture"
    values = [local.arch]
  }
}

variable "linux_version" {
  description = "Amazon Linux 2 or Amazon Linux 2023 (default)"
  type        = string
  default     = "al2023"
  validation {
    condition     = var.linux_version == "al2" || var.linux_version == "al2023"
    error_message = "Invalid value for linux_version. Must be al2 or al2023."
  }
}

variable "attach_eip" {
  description = "Set to true to create and attach an Elastic IP to EC2 instance. Use where launching in public subnet, but VPC is set to block automatic public IP assignment."
  type        = bool
  default     = false
}

data "http" "myip" {
  url = "https://wtfismyip.com/text"
}

variable "root_vol" {
  description = "Root volume config"
  type        = map(any)
  default = {
    size = 15
    type = "gp3"
  }
}

# THIS REQUIRES FURTHER WORK 
# - E.G. MOUNTING, FORMATTING, ETC. 
# - Create as separate resource to avoid for recreate, i.e. can be created after instance is created?
variable "ebs_vol" {
  description = "EBS volume config. size = 0 if no EBS volume. Supply size, type and device_name if you want to attach EBS volume."
  type        = map(any)
  default = {
    size        = 0
    type        = "gp3"
    device_name = "/dev/sdf"
  }
}

# Value for these generated by bin/prep.sh and stored in terraform.tfvars
variable "name_prefix" {
  description = "name prefix"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = null
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
  default     = null
}

variable "subnet_cidr" {
  description = "Subnet CIDR"
  type        = string
  default     = null
}

variable "ssh_from_my_ip" {
  description = "Use my IP for SSH access"
  type        = bool
  default     = false
}
