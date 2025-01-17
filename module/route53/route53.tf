##Route53 Records
resource "aws_route53_record" "default" {
  for_each = { for name in var.zone_name : name => name }
  zone_id  = var.zone_id
  name     = each.value
  type     = "A"
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}