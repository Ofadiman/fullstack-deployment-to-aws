FROM node:16.13.2-buster

# Assigne environment variables in the container.
#ENV NODE_ENV=production
ENV PROJECT_DIRECTORY_PATH=/home/node

RUN npm install -g @nestjs/cli@8.2.0

# Change owner of project directory.
RUN chown -R node:node ${PROJECT_DIRECTORY_PATH}

# By default, a docker container runs as a root user. Switch to previously created user to resolve problems with permissions to files created from the container.
USER node

# Set the working directory inside the container. All commands will be run inside this directory by default.
WORKDIR "${PROJECT_DIRECTORY_PATH}"

# Copy necessary files.
COPY --chown=node:node package.json package-lock.json tsconfig.json tsconfig.build.json nest-cli.json ormconfig.ts ./
COPY --chown=node:node src ./src

# Install dependencies.
RUN npm install

# Build project.
RUN npm run build

# Run the production script.
CMD ["npm", "run", "start:prod"]
