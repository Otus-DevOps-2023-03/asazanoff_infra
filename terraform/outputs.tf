output "external_ip_address_app" {
  value = yandex_compute_instance.app[*].network_interface.*.nat_ip_address
}
output "extertal_ip_address_lb" {
  value = yandex_lb_network_load_balancer.networkLoadBalancer.listener[*].external_address_spec[*].address
}
