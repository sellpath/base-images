FROM postgres:17.5-bookworm

# Install dependencies and pgvector extension
RUN apt-get update && apt-get install -y \
    git \
    postgresql-server-dev-17 \
    gcc \
    make \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add the pgvector extension
RUN git clone https://github.com/pgvector/pgvector.git \
    && cd pgvector \
    && git checkout tags/v0.8.0 -b v0.8.0 \
    && make \
    && make install \
    && cd .. \
    && rm -rf pgvector

    # Remove unnecessary build tools to reduce container size
RUN apt-get remove -y \
    gcc \
    make \
    git \
    postgresql-server-dev-17 \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY maintenance /usr/local/bin/maintenance
RUN chmod +x /usr/local/bin/maintenance/*
RUN mv /usr/local/bin/maintenance/* /usr/local/bin \
    && rmdir /usr/local/bin/maintenance
