FROM python:3.11.9-slim-bookworm as python-build-stage

ARG BUILD_ENVIRONMENT=local
ARG APP_SRC=./prompteng

# Install apt packages
RUN apt-get update && apt-get install --no-install-recommends -y \
  # dependencies for building Python packages
  build-essential \
  # psycopg2 dependencies
  libpq-dev
