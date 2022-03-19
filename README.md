# Introduction

I forked this container to use it in my home autpomation system running node-red with HomematicIP. I am new to docker and also to lighttpd and ffmpeg, but I wanted to have a container ready to use with my system without any volumes etc. to simplify MY life. But I will of course in future update this repo to have also the opportunity to input volumes, camera url info etc. into the container so that a rebuild of the image is not required anymore.
I was a bit unhappy when I first tried the really good code from the repos I forked from, because the container didn't work out of the box. The reasons where:
* the used software version "latest" led to the situation that the newer versions have to be configured differently. Therefore the container didn't work.
* I didn't know if the cgi script part worked, because there was no test inside, so Iadded a simple test script. The reasion is with ffmpeg I never knew if it worked or not so i tried to get the webserver with cgi runing and then I parameterized ffmpeg.
* ffmpeg is a perfect tool with lots of flags and so on. So it was very hard for me to find the correct setup. But this container I forked gave a very good example, although it didn't work with my camera (HikVision BH-120M)
* the container was based on ubuntu:latest so I changed it to alpine
* I added specific versions in the docker file to be sure that it builds also in the future. For me it was not so interesting if the software was the newest one, I prefer running software out of the box. Then, somebody can change this...

My camera info:
* Manufacturer: HikVision
* Type: HWI-B120H-M
* Firmware Version: V5.5.94 build 190902

Settings of the camera:
* Set substream to MJPEG (unfortunately over RTSP - I didn't find the url for the http MJPEG stream --> Therefore I need this conversion container.)

The working URL for my camera model is: 
```
rtsp://user:password@192.168.1.173:554/Streaming/Channels/102
```
where 102 means stream 1 substream 2.

# Create container

To create a container image called ckrtspmpeg:

```
docker build -t ckrtspmpeg .
```

# Set up

At the moment You have to download this git project, modify the files samplestream and sampleframe and build a fresh image. I will improve this, e.g. with git CI/CD to create a container on docker.io.

For excample, I had to add to the files samplestream and sampleframe
```
-rtsp_transport tcp
```
to get infos from my cameras.

# Run container with docker

```
docker run --restart always -d -p 8080:80 -v my_cgi_bin_folder:/var/www/cgi-bin --name ckrtspmpeg-server ckrtspmpeg
```

# Run container with docker-compose

I added a docker-compose file ready to use.

```
version: "3.7"

services:
  ckrtspmpeg-server:
    image: ckrtspmpeg:latest
    stdin_open: true # docker run -i
    tty: true # docker run -t
    environment:
      - TZ=Europe/Berlin
    ports:
      - "8080:80"
    #volumes:
    #  - ./cgibin:/var/www/localhost/cgi-bin
    #  - ./lighttpd:/etc/lighttpd
    #  - ./htdocs:/var/www/localhost/htdocs
```
I added stdin_open and tty to start on the bash in interactive mode just for testing. The ports used on the host is then the 8080, inside the container 80. The volumes are commented out but I will re-enable them in future.

# Viewing

You can view the pages via http://server:port/cgi-bin/samplestream and http://server:port/cgi-bin/sampleframe

Example: http://localhost:8080/cgi-bin/samplestream

# Acknowledgements

Based on https://stevethemoose.blogspot.com/2021/07/converting-rtsp-to-mjpeg-stream-on.html

Big thanks to https://github.com/piersfinlayson for his initial implementation https://github.com/piersfinlayson/rtspmpeg for this based on the article.
