terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

resource "docker_image" "web_server_node" {
  name = "fmf054/web_server_node:latest"
  keep_locally = false
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
  keep_locally = false
}

resource "docker_network" "private_network" {
    name = "network_df"
}

resource "docker_container" "web" {
  count = 3
  image = docker_image.web_server_node.image_id
  networks_advanced {
    name = "${docker_network.private_network.name}"
  }
  name  = "web_${count.index+1}"
  env = ["SERVER_NUMBER=${count.index+1}"]
  rm = true
}

resource "docker_container" "load_balancer" {
  name = "load_balancer"
  depends_on = [docker_container.web]
  image = docker_image.nginx.image_id
  networks_advanced {
    name = "${docker_network.private_network.name}"
  }
  ports {
    internal = 80
    external = 8080
  }
}

resource "local_file" "nginx_conf" {
    depends_on = [docker_container.web, docker_container.load_balancer]
    filename = "${path.module}/nginx.conf"
    content = data.template_file.nginx_config.rendered 
}

resource "null_resource" "local_exec" {
  depends_on = [local_file.nginx_conf]
  provisioner "local-exec" {
    command = "docker cp ${local_file.nginx_conf.filename} ${docker_container.load_balancer.name}:/etc/nginx/ && docker exec ${docker_container.load_balancer.name} nginx -s reload"
  }
  triggers = {
		load_balancer = docker_container.load_balancer.id
    web_servers = join(",", docker_container.web.*.id)
	}
}

data "template_file" "nginx_config" {
  depends_on = [docker_container.web, docker_container.load_balancer]
  template = "${file("${path.module}/Configs/nginx.tpl")}"
  vars = {
    "upstream_list" = "${join(",", docker_container.web.*.name)}"
  }
}

# output "test1" {
#   value = data.template_file.nginx_config.rendered
# }