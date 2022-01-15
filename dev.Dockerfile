FROM node:16.13.2-buster

# Assign default values to arguments in case they are not specified.
ARG GROUP_ID=1000
ARG PROJECT_DIRECTORY_PATH=/app
ARG USER=developer
ARG USER_ID=1000

# Create a user inside the container that will use the same `GROUP_ID` and `USER_ID` as the current user.
RUN mkdir -p ${PROJECT_DIRECTORY_PATH} && \
    mkdir -p /etc/sudoers.d/ && \
    mkdir -p /home/${USER} && \
    echo "${USER}:x:${USER_ID}:${GROUP_ID}:${USER},,,:/home/${USER}:/bin/bash" >> /etc/passwd && \
    echo "${USER}:x:${USER_ID}:" >> /etc/group && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${USER}" && \
    chmod 0440 /etc/sudoers.d/${USER} && \
    chown ${USER_ID}:${GROUP_ID} -R /home/${USER} && \
    chown ${USER_ID}:${GROUP_ID} -R ${PROJECT_DIRECTORY_PATH}

# By default, a docker container runs as a root user. Switch to previously created user to resolve problems with permissions to files created from the container.
USER "${USER}"

# Set the working directory inside the container. All commands will be run inside this directory by default.
WORKDIR "${PROJECT_DIRECTORY_PATH}"

# Run the development script.
CMD ["npm", "run", "dev"]
