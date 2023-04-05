# GraphQL Mesh Docker
[GraphQL Mesh](https://the-guild.dev/graphql/mesh)  docker image build specific to a project needs. 

## Setup
### Prerequisites

install `tsx` globally
```shell
pnpm add -g tsx
```

## Tools

### Introspect
Tool to Generate scheam for a given GraphQL endpoint
```shell
node tools/introspect.mjs https://api.cartql.com > ./src/schema/cartql.scheam.graphql
```

##  Build
```shell
VERSION=$(git describe --tags || echo "HEAD")
# VERSION=v0.1.0
BUILD_TIME=$(date +%FT%T%Z)
REGISTRY=ghcr.io
IMAGE_NAME=xmlking/graphql-mesh-specific
DOCKER_IMAGE=$REGISTRY/$IMAGE_NAME

# build
export DOCKER_CLI_EXPERIMENTAL=enabled
docker buildx create --use

docker build \
-t $DOCKER_IMAGE\:$VERSION \
-t $DOCKER_IMAGE\:latest \
--build-arg BUILD_TIME=$BUILD_TIME --build-arg BUILD_VERSION=$VERSION \
--push .


# (optional) pull recent images from GHCR
docker pull --platform linux/arm64 $DOCKER_IMAGE\:$VERSION

# run
docker run -it --rm --platform linux/arm64 -p 4000:4000 \
-e NODE_ENV=production -e NODE_TLS_REJECT_UNAUTHORIZED=0 --env-file ./.env $DOCKER_IMAGE:$VERSION
```

Debug container 
```shell
DOCKER_HOST=unix:///Users/schintha/.rd/docker.sock dive  $DOCKER_IMAGE:$VERSION
```

## Run
```shell
# start mesh
docker compose up mesh
# stop mesh
docker compose down
# stop mesh and remove volume
# if Error: EACCES: permission denied, open '/app/.mesh/
docker compose down -v
```


## Reference 

- [A guide to the GraphQL Mesh library](https://blog.logrocket.com/a-guide-to-the-graphql-mesh-library/)
  - See cache usage
- [nx-mesh](https://github.com/domjtalbot/nx-mesh/blob/main/libs/example/sdk/json-schema/fake-api/.meshrc.yml)
- [GraphQL Mesh Services examples](https://github.com/charlypoly/graphql-mesh-docs-first-gateway)
- [Use Hasura + GraphQL Mesh to create the ultimate data graph](https://hasura.io/blog/graphql-everywhere-use-hasura-graphql-mesh-to-create-the-ultimate-data-graph-uri-goldshtein/)
- [GraphQL Mesh Docker](https://github.com/onelittlenightmusic/graphql-mesh-docker)
- [gql-bff example project](https://github.com/osstotalsoft/atlas/tree/main/gql-bff)
