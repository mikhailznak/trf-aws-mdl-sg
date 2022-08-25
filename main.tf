locals {
  sg_rules_ingress_cidr_blocks = { for rule in var.sg_rules_ingress_cidr_blocks : md5(jsonencode(rule)) => rule }
  sg_rules_egress_cidr_blocks  = { for rule in var.sg_rules_egress_cidr_blocks : md5(jsonencode(rule)) => rule }

  sg_rules_ingress_sg = { for rule in var.sg_rules_ingress_sg : md5(jsonencode(rule)) => rule }
  sg_rules_egress_sg  = { for rule in var.sg_rules_egress_sg : md5(jsonencode(rule)) => rule }

  sg_rules_ingress_self = { for rule in var.sg_rules_ingress_self : md5(jsonencode(rule)) => rule }
  sg_rules_egress_self  = { for rule in var.sg_rules_egress_self : md5(jsonencode(rule)) => rule }
}

##################################
# Security Group
##################################
resource "aws_security_group" "this" {
  count       = var.create_sg ? 1 : 0
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id
  tags = merge(
    {
      Name = var.sg_name
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [name]
  }
}


##################################
# Default Security Group Rule
##################################
resource "aws_security_group_rule" "default_cidr_blocks_egress" {
  count             = var.create_sg && var.enabled_default_rules ? 1 : 0
  type              = "egress"
  to_port           = "0"
  protocol          = "all"
  from_port         = "0"
  security_group_id = aws_security_group.this[0].id
  cidr_blocks       = ["0.0.0.0/0"]
}

##################################
# Security Group Rule with CIDRs
##################################
resource "aws_security_group_rule" "cidr_blocks_ingress" {
  for_each          = local.sg_rules_ingress_cidr_blocks
  type              = "ingress"
  to_port           = lookup(each.value, "to_port")
  protocol          = lookup(each.value, "protocol")
  from_port         = lookup(each.value, "from_port")
  security_group_id = var.create_sg ? aws_security_group.this[0].id : var.security_group_id
  cidr_blocks       = lookup(each.value, "cidr_blocks")
}
resource "aws_security_group_rule" "cidr_blocks_egress" {
  for_each          = local.sg_rules_egress_cidr_blocks
  type              = "egress"
  to_port           = lookup(each.value, "to_port")
  protocol          = lookup(each.value, "protocol")
  from_port         = lookup(each.value, "from_port")
  security_group_id = var.create_sg ? aws_security_group.this[0].id : var.security_group_id
  cidr_blocks       = lookup(each.value, "cidr_blocks")
}

#########################################
# Security Group Rule with another SG
#########################################
resource "aws_security_group_rule" "sg_source_ingress" {
  for_each                 = local.sg_rules_ingress_sg
  type                     = "ingress"
  to_port                  = lookup(each.value, "to_port")
  protocol                 = lookup(each.value, "protocol")
  from_port                = lookup(each.value, "from_port")
  security_group_id        = var.create_sg ? aws_security_group.this[0].id : var.security_group_id
  source_security_group_id = lookup(each.value, "source_security_group_id")
}
resource "aws_security_group_rule" "sg_source_egress" {
  for_each                 = local.sg_rules_egress_sg
  type                     = "egress"
  to_port                  = lookup(each.value, "to_port")
  protocol                 = lookup(each.value, "protocol")
  from_port                = lookup(each.value, "from_port")
  security_group_id        = var.create_sg ? aws_security_group.this[0].id : var.security_group_id
  source_security_group_id = lookup(each.value, "source_security_group_id")
}

#########################################
# Security Group Rule with self source
#########################################
resource "aws_security_group_rule" "self_source_ingress" {
  for_each          = local.sg_rules_ingress_self
  type              = "ingress"
  to_port           = lookup(each.value, "to_port")
  protocol          = lookup(each.value, "protocol")
  from_port         = lookup(each.value, "from_port")
  security_group_id = var.create_sg ? aws_security_group.this[0].id : var.security_group_id
  self              = true
}
resource "aws_security_group_rule" "self_source_egress" {
  for_each          = local.sg_rules_egress_self
  type              = "egress"
  to_port           = lookup(each.value, "to_port")
  protocol          = lookup(each.value, "protocol")
  from_port         = lookup(each.value, "from_port")
  security_group_id = var.create_sg ? aws_security_group.this[0].id : var.security_group_id
  self              = true
}

