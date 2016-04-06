# AeroGear UnifiedPush server developer environment

This image prepares the environment required to build [AeroGear UnifiedPush](https://github.com/aerogear/aerogear-unifiedpush-server/) Server from scratch.

For feature requests or bugs, please file a JIRA [here](https://issues.jboss.org/projects/AGPUSH/summary)

## Install Docker

Follow the [instructions](http://docs.docker.com/installation/)

## Running the image

We need to run two different datasources, and each has been slpit up into its own container.

For our bundled Keycloak instance run the following command:

```shell
docker run --name keycloakDEV \
           -p 5306:3306 \
           -e MYSQL_USER=unifiedpush \
           -e MYSQL_PASSWORD=unifiedpush \
           -e MYSQL_DATABASE=keycloak \
           -e MYSQL_ROOT_PASSWORD=supersecret \
           -d mysql:5.5
```

For the database of the UnifiedPush Server itself, a similar command is needed:

```shell
docker run --name unifiedpushDEV \
           -p 6306:3306 \
           -e MYSQL_USER=unifiedpush \
           -e MYSQL_PASSWORD=unifiedpush \
           -e MYSQL_DATABASE=unifiedpush \
           -e MYSQL_ROOT_PASSWORD=supersecret \
           -d mysql:5.5
```

The two databases are now linked into the container that serves WildFly, containing the latest release of the UPS

```shell
docker run --name ups-dev \
           --link unifiedpushDEV:unifiedpush \
           --link keycloakDEV:keycloak \
           -p 8443:8443 \
           -it aerogear/unifiedpush-wildfly-dev
```

**Note**: The image will run SSL by default with self signed certificates being automatically generated.

## Building the image (alternative)

**Note**: First, you need to build the Dockerfile of the parent folder!

Afterwards build the `unifiedpush-wildfly-dev` image yourself, by running:

`docker build -t aerogear/unifiedpush-wildfly-dev .`

## Accessing it

Get the image IP address, for example:

`docker-machine ip default` or `docker inspect IMAGENAME | grep -i IPAdr`

Access it:

It only exposes SSL port, all the requests will be redirected to HTTPS.

`https://myip:8443/ag-push`

## Pull request review

Start Docker with Bash

`docker run --rm -it --entrypoint=/bin/bash aerogear/unifiedpush-wildfly-dev && cd ..`

Add the configuration to fetch pull requests

`git config --add remote.origin.fetch "+refs/pull/*/head:refs/remotes/origin/pr/*"`

Run git fetch

`git fetch origin`

Checkout

`git checkout origin/pr/PR_NUMBER`

## Contributing

Patches are welcome, just send a pull request and I will be happy on merging it. If you want more images, open issues
with the request.
