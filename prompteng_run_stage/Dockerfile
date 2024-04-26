# Python 'run' stage
FROM python:3.11.9-slim-bookworm  as python-run-stage

ARG BUILD_ENVIRONMENT=local
ARG APP_HOME=/app
ARG APP_SRC=./app-src

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV BUILD_ENV ${BUILD_ENVIRONMENT}

WORKDIR ${APP_HOME}

# dependencies and utils
RUN apt-get update && apt-get install --no-install-recommends -y \
  sudo git bash-completion ssh curl vim iputils-ping build-essential libpq5 libpq-dev gettext python3.11-dev \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/*

# Create devcontainer user and add it to sudoers
RUN  groupadd -g 999 docker && groupadd -g 1000 dev-user \
  && useradd --uid 1000 --gid dev-user --shell /bin/bash --create-home dev-user \
  && echo dev-user ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/dev-user \
  && chmod 0440 /etc/sudoers.d/dev-user \
  && echo dev-user:docker | chpasswd \
  && usermod -aG docker dev-user

RUN pip install --upgrade pip

