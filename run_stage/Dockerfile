# Python 'run' stage
FROM python:3.11.12-slim-bookworm  AS python-run-stage

ARG BUILD_ENVIRONMENT=local
ARG APP_HOME=/app
ARG APP_SRC=./app-src

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV BUILD_ENV=${BUILD_ENVIRONMENT}

WORKDIR ${APP_HOME}

# dependencies and utils
RUN apt-get update && apt-get install --no-install-recommends -y \
  sudo git bash-completion openssh-client curl \
  tzdata gnupg gnome-keyring wget curl ca-certificates \
  vim iputils-ping build-essential libpq5 libpq-dev gettext \
  python3.11-dev wget software-properties-common apt-transport-https \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/*

# RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add - \
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg \
  && install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg \
  && rm packages.microsoft.gpg \
  && echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list \
  && apt install apt-transport-https \
  && apt update \
  && apt install code -y \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/*

# Create devcontainer user and add it to sudoers
RUN groupadd -g 1000 dev-user \
  && useradd --uid 1000 --gid dev-user --shell /bin/bash --create-home dev-user \
  && echo dev-user ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/dev-user \
  && chmod 0440 /etc/sudoers.d/dev-user \
  && echo dev-user:docker | chpasswd \
  && groupadd -g 1001 docker \
  && usermod -aG docker dev-user 

RUN pip install --upgrade pip