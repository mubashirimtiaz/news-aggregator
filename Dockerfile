#Stage 1
FROM node:alpine AS build
WORKDIR /usr/src/app
COPY package.json ./
COPY pnpm-lock.yaml ./
RUN npm install -g pnpm
RUN pnpm install
COPY . .
RUN pnpm build



#Stage 2
FROM nginx:1.19.0 AS deploy
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=build /usr/src/app/dist .
ENTRYPOINT ["nginx", "-g", "daemon off;"]