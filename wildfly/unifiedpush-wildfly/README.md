# AeroGear UnifiedPush server environment

[![](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg)](https://hub.docker.com/r/aerogear/unifiedpush-wildfly/)
[![Docker Stars](https://img.shields.io/docker/stars/aerogear/unifiedpush-wildfly.svg?style=plastic)](https://registry.hub.docker.com/v2/repositories/aerogear/unifiedpush-wildfly/stars/count/)
[![Docker pulls](https://img.shields.io/docker/pulls/aerogear/unifiedpush-wildfly.svg?style=plastic)](https://registry.hub.docker.com/v2/repositories/aerogear/unifiedpush-wildfly/)

[![License](https://img.shields.io/:license-Apache2-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)



This image prepares the environment required to run [AeroGear UnifiedPush](https://github.com/aerogear/aerogear-unifiedpush-server/) server with the binaries.

For feature requests or bugs, please file a JIRA [here](https://issues.jboss.org/projects/AGPUSH/summary)

## Install Docker

Follow the [instructions](http://docs.docker.com/installation/)

## Running the image

Before starting the UPS we need to have a Keycloak Server and a database available for it.

You can start a database for the UnifiedPush Server using the following command:

```shell
$ docker run --name unifiedpushDB \
           -p 8080:8080 \
           -p 9090:9090 \
           -e POSTGRES_USER=unifiedpush \
           -e POSTGRES_PASSWORD=unifiedpush \
           -e POSTGRES_DATABASE=unifiedpush \
           -e POSTGRES_ROOT_PASSWORD=supersecret \
           -d postgres:9.6
```

This creates a Postgres instance and exposes the ports we'll need for Keycloak, UPS, and Postgres.

You can run the commands below to start Keycloak and the UPS containers. These containers both share the same network as the database container due to the `--net` option that's passed so we don't need to specify the port options again. 

Replace `localhost` and `/path/to/my/folder/containing/ups-realm` with your own values as necessary. A sample realm configuration can be found [here](https://github.com/aerogear/aerogear-unifiedpush-server/tree/master/docker-compose/keycloak-realm).

```shell
$ docker run -d --name keycloak \
           --net=container:unifiedpushDB \
           -v /path/to/my/folder/containing/ups-realm:/keycloak-cfg \
           -e KEYCLOAK_USER=admin \
           -e KEYCLOAK_PASSWORD=admin \
           jboss/keycloak:4.0.0.Final \
           "-b 0.0.0.0 -Dkeycloak.import=/keycloak-cfg/ups-realm-sample.json"

$ docker run --name ups \
           --net=container:unifiedpushDB \
           -e POSTGRES_SERVICE_HOST=localhost \
           -e POSTGRES_SERVICE_PORT=3306 \
           -e POSTGRES_DATABASE=unifiedpush \
           -e POSTGRES_USER=unifiedpush \
           -e POSTGRES_PASSWORD=unifiedpush \
           -e KEYCLOAK_SERVICE_HOST=localhost \
           -e KEYCLOAK_SERVICE_PORT=8080 \
           -dit aerogear/unifiedpush-wildfly:2.1.0 \
           "-Djboss.socket.binding.port-offset=1010"
```

**Note**: The image will run SSL by default with self signed certificates being automatically generated.    
If you want to use your own certificate and key (authority certified certificates for example), proceed as follows :

1. put your key and certificate respectively named `privatekey.key` and `certificate.crt` in a dedicated directory.    
2. Launch the container as above but adding a volume option : `-v <path to the dir where you put key and cert>:/keys`

The image will use your certificates instead of the self signed ones.

## Building the image (alternative)

**Note**: First, you need to build the Dockerfile of the parent folder!

Afterwards build the `unifiedpush-wildfly` image yourself, by running:

`docker build -t aerogear/unifiedpush-wildfly .`

## Accessing UPS

It only exposes SSL port, all HTTP requests will be redirected to HTTPS.

If you're developing locally with a default Docker setup you should be able to access the UPS server at `https://localhost:9090/ag-push`. Alternatively, get the image IP address, using one of these commands:

```
$ docker-machine ip default
$ docker inspect IMAGENAME | grep -i IPAddr
```

You can then navigate to `http://myip:9090/ag-push`.

Login using the default values of `admin` for the username and `123` as the password.

## Contributing

Patches are welcome, just send a pull request and I will be happy on merging it. If you want more images, open issues
with the request.
