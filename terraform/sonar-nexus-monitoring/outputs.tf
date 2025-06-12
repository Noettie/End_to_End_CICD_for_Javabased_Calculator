output "sonarqube_public_ip" {
  description = "Public IP of the SonarQube server"
  value       = aws_instance.sonarqube.public_ip
}

output "nexus_public_ip" {
  description = "Public IP of the Nexus server"
  value       = aws_instance.nexus.public_ip
}

#output "prometheus_grafana_public_ip" {
# description = "Public IP of the Prometheus and Grafana server"
# value       = aws_instance.prometheus_grafana.public_ip
#}

output "postgres_db_public_ip" {
  description = "Public IP of PostgreSQL DB server"
  value       = aws_instance.postgres_db.public_ip
}

output "postgres_db_private_ip" {
  description = "Private IP of PostgreSQL DB server"
  value       = aws_instance.postgres_db.private_ip
}
