# Stage 1: Build
FROM node:latest AS build
WORKDIR /app
COPY package*.json /app/
RUN npm install
COPY . /app/


# Stage 2: Serve
FROM  node:alpine
WORKDIR /app
COPY --from=build /app/ .
EXPOSE 3000
CMD ["npm", "start"]
