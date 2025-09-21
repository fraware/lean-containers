# lean-containers Dockerfile
# Multi-stage build for optimal image size

# Build stage
FROM leanprover/lean4:4.8.0 AS builder

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install dependencies and build
RUN lake update && lake build

# Runtime stage
FROM leanprover/lean4:4.8.0 AS runtime

# Set working directory
WORKDIR /app

# Copy built artifacts from builder stage
COPY --from=builder /app/build /app/build
COPY --from=builder /app/.lake /app/.lake
COPY --from=builder /app/lake-manifest.json /app/lake-manifest.json
COPY --from=builder /app/Lakefile.lean /app/Lakefile.lean
COPY --from=builder /app/lean-toolchain /app/lean-toolchain
COPY --from=builder /app/src /app/src
COPY --from=builder /app/Main.lean /app/Main.lean
COPY --from=builder /app/FinalProductionTest.lean /app/FinalProductionTest.lean

# Set entrypoint
ENTRYPOINT ["lean"]

# Default command
CMD ["Main.lean"]

# Labels for metadata
LABEL org.opencontainers.image.title="lean-containers"
LABEL org.opencontainers.image.description="A container library for Lean 4 with type-safe, mathematically rigorous implementations"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.source="https://github.com/your-org/lean-containers"
LABEL org.opencontainers.image.licenses="MIT"
