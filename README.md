# terraform_assignment

Please see solution and notes for the exercise inline.

The exercise:

This exercise should be performed locally using Terraform and Docker. Using Terraform and the official Docker provider.

Please add the code to github and share it with me by email.

Make sure this code can run locally on a linux  OS base machine (if terraform is not installed , add support for install it)

 

Create the following cluster:

1. Run X web-servers that serves a single static page with a message: Hello from web-server (1..X)
    Solution:
        To set web services number update count within resource "docker_container" "web" in main.tf. This will create a desired number of web servers dockers from fmf054/web_server_node:latest image.


2. Run a load-balancer in front of the web-servers that performs round robin load balancing
    Solution:
        Load-balancer is created from nginx docker image. ngnix config is replaced by nginx.conf file built in run-time from template according to servers number. 

3. On both web-servers and load-balancer, add a health endpoint returning the name of the component (web-server-(1..X) / load-balancer).
    Solution:
        For the load balancer http://localhost:8080/health endpoint was added (see in Config/nginx.tpl)
        For the web server endpoint is http://localhost:8080/healths (trough the load balancer. each request different server's health is returned because of round robin load balancing). For implementation see Webserver_nodejs/server.js

4. Create support for setting different versions for the web-server and load-balancer
    Solution:
        I didn't understand how to handle versions for docker resources via terraform. It is possible to manage versions for web server by building its image with different tag and pushing into docker hub. To use a specific version resource "docker_image" "web_server_node" should be updated with a specific tag. Same method could be implemented with load balancer (using private image on docker hub built from nginx image)


5. Write a shell script for install(using git pull from github)/start/stop/status of the cluster
    Solution:
        Script: webserverdf.sh [action]
        Available actions: Available actions: install, start, stop, status

6. Write a README file
    Solution:
        README.md

 

BONUS: Instantiate a second cluster (or more – based on configuration )of web-servers and load-balancer with minimum added lines (add support in your script)
    DF: not implemented yet. hopefully will do that later)

General notes:
This script should run on linux machine with terraform and docker installed where docker commands are not require sudo
Private resources used: 
https://github.com/dor054/terraform_assignment
https://hub.docker.com/repository/docker/fmf054/web_server_node/general

Regards,
Dor Feldman
