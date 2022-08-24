variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}

##################################
# Security Group
##################################
variable "create_sg" {
  description = "Create new security group. False by default"
  type        = bool
  default     = false
}
variable "sg_name" {
  description = "Security Group name"
  type        = string
  default     = ""
}
variable "sg_description" {
  description = "Security Group description"
  type        = string
  default     = ""
}
variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = ""
}

##################################
# Security Group Rules
##################################
variable "security_group_id" {
  description = "Security Group  engress rules"
  type        = string
  default     = ""
}

variable "enabled_default_rules" {
  description = "Default security group rules that allow all egress traffic. Enabled by default"
  type        = bool
  default     = true
}
#########################################
# Security Group Rules with CIDR blocks
#########################################
variable "sg_rules_ingress_cidr_blocks" {
  description = "Security Group ingress rules"
  type = set(object({
    to_port     = string
    protocol    = string
    from_port   = string
    cidr_blocks = list(string)
  }))
  default = []

}
variable "sg_rules_egress_cidr_blocks" {
  description = "Security Group ingress rules"
  type = set(object({
    to_port     = string
    protocol    = string
    from_port   = string
    cidr_blocks = list(string)
  }))
  default = []
}

#########################################
# Security Group Rules with another SG
#########################################
variable "sg_rules_ingress_sg" {
  description = "Security Group ingress rules"
  type = set(object({
    to_port                  = string
    protocol                 = string
    from_port                = string
    source_security_group_id = string
  }))
  default = []
}
variable "sg_rules_egress_sg" {
  description = "Security Group ingress rules"
  type = set(object({
    to_port                  = string
    protocol                 = string
    from_port                = string
    source_security_group_id = string
  }))
  default = []
}

#########################################
# Security Group Rules with self source
#########################################
variable "sg_rules_ingress_self" {
  description = "Security Group ingress rules"
  type = set(object({
    to_port   = string
    protocol  = string
    from_port = string
    self      = bool
  }))
  default = []
}
variable "sg_rules_egress_self" {
  description = "Security Group ingress rules"
  type = set(object({
    to_port   = string
    protocol  = string
    from_port = string
    self      = bool
  }))
  default = []
}
