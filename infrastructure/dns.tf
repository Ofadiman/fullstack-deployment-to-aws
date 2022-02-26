resource "aws_route53_zone" "main" {
  name = "ofadiman.com"
}

# For some unknown reason I don't know why this validation is not working 🤔.
#resource "aws_acm_certificate" "load_balancer_tls_certificate" {
#  domain_name       = "ofadiman.com"
#  validation_method = "DNS"
#
#  lifecycle {
#    create_before_destroy = true
#  }
#}
#
#resource "aws_acm_certificate_validation" "certificate_validation" {
#  certificate_arn         = aws_acm_certificate.load_balancer_tls_certificate.arn
#  validation_record_fqdns = [for record in aws_route53_record.aws_route53_record_validation : record.fqdn]
#}
#
#resource "aws_route53_record" "aws_route53_record_validation" {
#  for_each = {
#    for dvo in aws_acm_certificate.load_balancer_tls_certificate.domain_validation_options : dvo.domain_name => {
#      name   = dvo.resource_record_name
#      record = dvo.resource_record_value
#      type   = dvo.resource_record_type
#    }
#  }
#
#  allow_overwrite = true
#  name            = each.value.name
#  records         = [each.value.record]
#  ttl             = 60
#  type            = each.value.type
#  zone_id         = aws_route53_zone.main.zone_id
#}
