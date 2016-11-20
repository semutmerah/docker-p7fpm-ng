# docker-p7fpm-ng
Small Size Dockerized Nginx + PHP-FPM7, with Alpine Linux as base image.

## Features
- Best for development use
- Small Size
- Optimized nginx and php-fpm7 configuration (based from my experience)
- opcache enabled
- Can passing custom build argument SERVER_NAME for nginx configuration (default to web.local)
- Can passing custom build argument error_reporting for php.ini configuration (default to E_ALL)

## Pre-Requisites
- [Docker installed on your system](https://docs.docker.com/engine/installation/)
- Pull alpine:edge image with this command:
  ```
  $ docker pull alpine:edge
  ```

- [Optional] If you want to use database (I prefer mariadb), then pull also the mariadb:latest image with this command:
  ```
  $ docker pull mariadb:latest
  ```

## Build without passing parameters (using default value)
- Clone this repository:
  ```
  $ git clone git@github.com:semutmerah/docker-p7fpm-ng.git
  ```

- Inside folder repo, run this command to build the image:
  ```
  $ docker build -t whatever-name-tag-you-want .
  ```


## Build with passing parameters
- Clone this repository:
  ```
  $ git clone git@github.com:semutmerah/docker-p7fpm-ng.git
  ```

- Inside folder repo, run this command to build the image with custom argument:
  ```
  $ docker build -t whatever-name-tag-you-want --build-arg SERVER_NAME=yourdomain.local .
  ```
  In this case, we passing the SERVER_NAME argument and set it to yourdomain.local . Beside SERVER_NAME, there is also another argument that you can passing out to the images. You can check it at the Features line above.

## Run the image
- After the build is finished, you may want to check it first to make sure the image is successfully created with this command:
  ```
  $ docker images
  ```

- The output from above command should be like this (in this case I passed rasyid-php7 as the name/tag of the image):
  ```
  docker-p7fpm-ng (master) $ docker images
  REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
  rasyid-php7         latest              1f4aeecbca82        15 hours ago        38.41 MB
  ```

- To run the image, run this command:
  ```
  $ docker run -d --name php7-webserver -v /home/your-username/your-php-project:/var/www/localhost/htdocs -ti the-name-of-the-image
  ```

  The flag -v above, means that we set mount the host folder /home/your-username/your-php-project, to the docker container folder at /var/www/localhost/htdocs, which is the webroot
- To access the webroot from docker host, you need to find out what the ip address of the container first. To do this, run this command:
  ```
  $ docker inspect php7-webserver | grep IPAddress
  ```

- Access the ipaddress from your web browser
- The default server_name is web.local (if you not passing any parameters when build the image), you may want to set your /etc/hosts to pointing the ip address of docker container to that server_name

## If I want to use database, how could I do that?
Good question. For this case, you need to make sure you've already pulled the mariadb:latest image as suggested on the Features above. Then run the mariadb images with this command:
```
$ docker run --name some-mariadb -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb:latest
```

For another environment values that can be passed when running the mariadb image, you can check on their [docker hub page](https://hub.docker.com/_/mariadb/).

After that, to linked your php7-webserver container with the mariadb container, we need to run our php7-webserver container with this command (make sure you're not having any container running except the mariadb container):
```
$ docker run --name php7-webserver --link some-mariadb:mysql -d the-name-of-the-image
```
