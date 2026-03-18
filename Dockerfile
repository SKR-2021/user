FROM node:20.19.5-alpine3.21 AS build
WORKDIR /opt/server
COPY package.json .
COPY *.js .
# this may add extra cache memory
RUN npm install 


FROM node:20.19.5-alpine3.21
# Create a group and user
WORKDIR /opt/server
RUN addgroup -S dotmart && adduser -S dotmart -G dotmart && \
    chown -R dotmart:dotmart /opt/server
EXPOSE 8080
LABEL com.project="dotmart" \
      component="user" \
      created_by="sivakumar"
ENV MONGO="true" \
    REDIS_URL="redis://redis:6379" \
    MONGO_URL="mongodb://mongodb:27017/users"
COPY --from=build --chown=dotmart:dotmart /opt/server /opt/server
USER dotmart
CMD ["server.js"]
ENTRYPOINT ["node"]

# FROM node:20
# WORKDIR /opt/server
# EXPOSE 8080
# COPY package.json .
# COPY *.js .
# RUN npm install
# ENV MONGO="true" \
#     REDIS_URL="redis://redis:6379" \
#     MONGO_URL="mongodb://mongodb:27017/users"
# CMD ["node", "server.js"]