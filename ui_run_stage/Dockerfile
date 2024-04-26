FROM node:20.12.2-alpine3.19

# disable ipv6
COPY workaround-disable-ipv6.txt ./
RUN cat workaround-disable-ipv6.txt >> /etc/sysctl.d/local.conf \
    && rm workaround-disable-ipv6.txt

# Create the directory on the node image
# where our Next.js app will live
RUN mkdir -p /app

# Set /app as the working directory in container
WORKDIR /app

RUN yarn set version berry

# Override the ENTRYPOINT of the base image
ENTRYPOINT []