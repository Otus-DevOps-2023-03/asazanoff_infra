resource "yandex_lb_network_load_balancer" "networkLoadBalancer" {
  name = "reddit-loadbalancer"
  listener {
    name = "reddit-port-listener"
    port = 9292
  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.loadBalancerTargetGroup.id
    healthcheck {
      name = "reddit-healthcheck"
      http_options {
        path = "/"
        port = 9292
      }
    }
  }
}

resource "yandex_lb_target_group" "loadBalancerTargetGroup" {
  name = "reddit-target-group"

  dynamic "target" {
    for_each = yandex_compute_instance.app.*.network_interface.0.ip_address
    content {
      subnet_id = var.subnet_id
      address   = target.value
    }
  }
}
