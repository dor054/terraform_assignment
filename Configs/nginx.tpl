events {
     worker_connections 1024; 
}

http {

    upstream web_servers {
${join("\n", formatlist("\t\tserver %s;", split(",", upstream_list)))}
    }

    server {

        listen 80;

        location / {
            proxy_pass         http://web_servers;
        }

        location = /health {
            access_log off;
            add_header 'Content-Type' 'application/json';
            return 200 '{"host": "load-balancer"}';
        }
    }
}