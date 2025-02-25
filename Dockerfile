FROM debian:jessie-slim
LABEL authors="clegginabox"

ENV NODE_VERSION="v6.17.1"
ENV BASH_ENV /home/user/.bash_env

# Copy locally stored apt-packages into the image
COPY ./packages/*.deb /tmp/packages/

# Install the .deb packages
RUN dpkg -i /tmp/packages/*.deb && apt-get install -f && rm -rf /tmp/packages

# Use bash for the shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Create a script file sourced by both interactive and non-interactive bash shells
RUN mkdir -p /home/user
RUN touch "${BASH_ENV}"
RUN echo '. "${BASH_ENV}"' >> ~/.bashrc

# Download and install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | PROFILE="${BASH_ENV}" bash
RUN echo node > .nvmrc \
    && nvm install ${NODE_VERSION}

# Add composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
