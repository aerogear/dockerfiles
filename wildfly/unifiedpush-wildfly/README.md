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

We need to run a Keycloak Server and a database for the UPS itself.

### Keycloak Server

For the Keycloak instance run the following command:


```shell
docker run --name keycloakSRV \
           -v /path/to/my/folder/containing/ups-realm:/keycloak-cfg \
           -e KEYCLOAK_USER=admin \
           -e KEYCLOAK_PASSWORD=admin \
           jboss/keycloak:3.2.1.Final \
           "-b 0.0.0.0 -Dkeycloak.import=/keycloak-cfg/ups-realm-sample.json"
```

For the database of the UnifiedPush Server itself, a similar command is needed:

```shell
docker run --name unifiedpushDB \
           -p 11306:3306 \
           -e MYSQL_USER=unifiedpush \
           -e MYSQL_PASSWORD=unifiedpush \
           -e MYSQL_DATABASE=unifiedpush \
           -e MYSQL_ROOT_PASSWORD=supersecret \
           -d mysql:5.5
```

**Note** you can skip the -p options for the 2 database containers if you do not want to access the databases directly


The two databases are now linked into the container that serves WildFly, containing the latest release of the UPS

```shell
docker run --name ups \
           --link unifiedpushDB:unifiedpush \
           --link keycloakSRV:keycloak \
           -p 9090:8080 \
           -it aerogear/unifiedpush-wildfly
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

## Accessing it

Get the image IP address, for example:

`docker-machine ip default` or `docker inspect IMAGENAME | grep -i IPAdr`

Access it:

It only exposes SSL port, all the requests will be redirected to HTTPS.

`http://myip:9090/ag-push`

## Contributing

Patches are welcome, just send a pull request and I will be happy on merging it. If you want more images, open issues
with the request.
