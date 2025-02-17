terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  cloud_id = "b1g2445ompelboq61fkg"
  folder_id = "b1gfoungdr8tuo6k9lhp"
  zone = "ru-central1-a"
}

resource "yandex_vpc_network" "network-2" {
  name = "network2"
}

resource "yandex_vpc_subnet" "subnet-2" {
  name           = "subnet2"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-2.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_lb_network_load_balancer" "lb-1" {
  name  = "lb-1"
  deletion_protection = "false"
  listener {
    name = "my-lb1"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
}
  attached_target_group {
    target_group_id = yandex_lb_target_group.test-1.id
    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

resource "yandex_lb_target_group" "test-1" {
  name      = "test-1"
  target {
    subnet_id = yandex_vpc_subnet.subnet-2.id
    address   = yandex_compute_instance.vm[0].network_interface.0.ip_address
  }
  target {
    subnet_id = yandex_vpc_subnet.subnet-2.id
    address   = yandex_compute_instance.vm[1].network_interface.0.ip_address
  }
}


resource "yandex_compute_instance" "vm" {
  count = 2
  name  = "vm${count.index}"

boot_disk {
  initialize_params {
    image_id = "fd8s17cfki4sd4l6oa59"
    size =  5
  }
}

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-2.id
    nat       = true
  }

  resources {
    cores  = 2
    memory = 2
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }
}