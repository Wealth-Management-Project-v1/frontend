#stage 1: Build
FROM            docker.io/library/node:22 AS builder
WORKDIR         /app
COPY            ./ /app/
RUN             npm ci && npm run build

#stage 2: Run
FROM            docker.io/library/nginx
COPY            --from=builder /app/dist/* /usr/share/nginx/index.html
