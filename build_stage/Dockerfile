FROM python:3.11.13-slim-bookworm AS python-build-stage

ARG BUILD_ENVIRONMENT=local

COPY base_image_version.txt /base_image_version.txt

# Install apt packages
RUN apt-get update && apt-get install --no-install-recommends -y \
  # dependencies for building Python packages
  build-essential
