# syntax=docker/dockerfile:1
FROM node:16-alpine3.14 AS builder

# Assigne environment variables in the container.
ENV USER_HOME=/home/node

# Change owner of project directory.
RUN chown -R node:node ${USER_HOME}

# By default, a docker container runs as a root user. Switch to previously created user to resolve problems with permissions to files created from the container.
USER node

# Set the working directory inside the container. All commands will be run inside this directory by default.
WORKDIR ${USER_HOME}

# Copy necessary files.
COPY --chown=node:node ./ ./

# Install dependencies.
RUN npm install

# Bootstrap packages.
RUN npx lerna bootstrap

# Build projects.
RUN npx lerna run build

FROM node:16-alpine3.14

# Assigne environment variables in the container.
ENV USER_HOME=/home/node

# Change owner of project directory.
RUN chown -R node:node ${USER_HOME}

# By default, a docker container runs as a root user. Switch to previously created user to resolve problems with permissions to files created from the container.
USER node

# Set the working directory inside the container. All commands will be run inside this directory by default.
WORKDIR ${USER_HOME}

#RUN ls
#RUN ls packages/api
#RUN ls packages/client
COPY --chown=node:node --from=builder /home/node/packages/api/package.json ./
COPY --chown=node:node --from=builder /home/node/packages/api/dist/ ./dist
COPY --chown=node:node --from=builder /home/node/packages/client/build/ ./build

# Install production dependencies for backend application.
RUN npm install --production

# Run the production script.
CMD ["npm", "run", "start:prod"]
