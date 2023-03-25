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
    }
}