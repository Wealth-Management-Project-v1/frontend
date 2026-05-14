#stage 1: Build
FROM            docker.io/library/node:22
WORKDIR         /app
COPY            ./ /app/
RUN             npm ci && npm run build