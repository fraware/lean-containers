# lean-containers Dockerfile
# Multi-stage build for optimal image size

# Pinned OS base; elan installs the Lean revision declared by lean-toolchain.
FROM ubuntu:24.04 AS lean-base
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl git build-essential zstd \
    && rm -rf /var/lib/apt/lists/*
ENV PATH="/root/.elan/bin:${PATH}"
WORKDIR /app
COPY lean-toolchain ./lean-toolchain
RUN curl -fsSL https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh \
    | sh -s -- -y --default-toolchain none \
    && elan toolchain install "$(head -n 1 lean-toolchain)" \
    && elan default "$(head -n 1 lean-toolchain)" \
    && lake --version

# Build stage
FROM lean-base AS builder

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install dependencies and build
RUN lake update && lake build

# Runtime stage
FROM lean-base AS runtime
ARG VERSION=dev

# Set working directory
WORKDIR /app

# Copy built artifacts from builder stage (Lake outputs live under .lake/)
COPY --from=builder /app/.lake /app/.lake
COPY --from=builder /app/lake-manifest.json /app/lake-manifest.json
COPY --from=builder /app/lakefile.lean /app/lakefile.lean
COPY --from=builder /app/lean-toolchain /app/lean-toolchain
COPY --from=builder /app/src /app/src
COPY --from=builder /app/Main.lean /app/Main.lean
COPY --from=builder /app/FinalProductionTest.lean /app/FinalProductionTest.lean
COPY --from=builder /app/Examples.lean /app/Examples.lean
COPY --from=builder /app/CSLibExamples.lean /app/CSLibExamples.lean

# Resolve imports via Lake (library lives under .lake)
ENTRYPOINT ["lake", "env", "lean"]

# Default command
CMD ["Main.lean"]

# Labels for metadata
LABEL org.opencontainers.image.title="lean-containers"
LABEL org.opencontainers.image.description="Lean 4: container signatures, polynomial functors, and W-types (mathlib-free)"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.source="https://github.com/fraware/lean-containers"
LABEL org.opencontainers.image.licenses="MIT"
