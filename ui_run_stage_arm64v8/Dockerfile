FROM arm64v8/node:22.18.0-alpine3.22

# Create the directory on the node image
# where our Next.js app will live
RUN mkdir -p /app

# Set /app as the working directory in container
WORKDIR /app
# to the /app working directory
COPY package.json ./

RUN yarn set version berry

# Install dependencies in /app
RUN yarn install