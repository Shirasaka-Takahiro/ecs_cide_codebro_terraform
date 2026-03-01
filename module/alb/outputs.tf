output "alb_name" {
  value = aws_lb.alb.name
}

output "alb_arn_suffix" {
  value = aws_lb.alb.arn_suffix
}

output "alb_id" {
  value = aws_lb.alb.id
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

output "blue_tg_name" {
  value = aws_lb_target_group.blue_tg.name
}

output "blue_tg_arn" {
  value = aws_lb_target_group.blue_tg.arn
}

output "green_tg_name" {
  value = aws_lb_target_group.green_tg.name
}

output "green_tg_arn" {
  value = aws_lb_target_group.green_tg.arn
}

output "alb_https_listener_arn" {
  value = aws_lb_listener.alb_https_listener.arn
}