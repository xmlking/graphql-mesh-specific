# syntax=docker/dockerfile:1.4
############################################################
### Ref https://github.com/Urigo/graphql-mesh/tree/master/packages/container
############################################################
############################################################
### stage_runtime
### this stage installs the runtime dependencies.
############################################################
FROM node:19-alpine as runtime

# install pnpm
RUN corepack enable; corepack prepare pnpm@8.2.0 --activate

WORKDIR /app

# clean install dependencies, no devDependencies, no prepare script
COPY ./patches/ ./patches/
COPY .npmrc package.json pnpm-lock.yaml ./
RUN pnpm fetch --prod --unsafe-perm --ignore-scripts --unsafe-perm
RUN pnpm install -r --offline --prod

COPY . .
# workaround for issue: https://github.com/Urigo/graphql-mesh/issues/5297
COPY ./.meshrc.prod.yml ./.meshrc.yml

RUN pnpm build
RUN pnpm prune --prod --no-optional
############################################################
### stage_final
### this stage only needs the compiled application and the runtime dependencies.
############################################################
FROM gcr.io/distroless/nodejs:18 as final
# FROM cgr.dev/chainguard/node:19 as final
# FROM node:19-alpine as final

USER nonroot
ENV NODE_ENV production
WORKDIR /app

ENTRYPOINT ["/nodejs/bin/node"]
COPY --from=runtime --chown=nonroot:nonroot /app/.mesh ./.mesh
COPY --from=runtime --chown=nonroot:nonroot /app/config ./config
COPY --from=runtime --chown=nonroot:nonroot /app/src ./src
COPY --from=runtime --chown=nonroot:nonroot /app/tsconfig.json ./tsconfig.json
COPY --from=runtime --chown=nonroot:nonroot /app/package.json ./package.json
COPY --from=runtime --chown=nonroot:nonroot /app/node_modules ./node_modules

ENV PORT 4000
EXPOSE 4000

# Metadata params
ARG TARGET=graphql-mesh
ARG DOCKER_REGISTRY=ghcr.io
ARG DOCKER_CONTEXT_PATH=xmlking
ARG BUILD_TIME
ARG BUILD_VERSION
ARG VCS_URL=graphql-mesh
ARG VCS_REF=1
ARG VENDOR=xmlking

# Metadata
LABEL org.opencontainers.image.created=$BUILD_TIME \
	org.opencontainers.image.name="${TARGET}" \
	org.opencontainers.image.title="${TARGET}" \
	org.opencontainers.image.description="GraphQL Mesh Gateway Docker Image" \
	org.opencontainers.image.url=https://github.com/xmlking/$VCS_URL \
	org.opencontainers.image.source=https://github.com/xmlking/$VCS_URL \
	org.opencontainers.image.revision=$VCS_REF \
	org.opencontainers.image.version=$BUILD_VERSION \
	org.opencontainers.image.authors=sumanth \
	org.opencontainers.image.vendor=$VENDOR \
	org.opencontainers.image.licenses=MIT \
	org.opencontainers.image.documentation="docker run -it -e NODE_ENV=production -p 4000:4000 ${DOCKER_REGISTRY:+${DOCKER_REGISTRY}/}${DOCKER_CONTEXT_PATH}/${TARGET}:${BUILD_VERSION}"

CMD  ["node_modules/@graphql-mesh/cli/cjs/bin.js", "start"]
