# lean-containers Dockerfile
# Multi-stage build for optimal image size

# Build stage
FROM leanprover/lean4:4.31.0 AS builder

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install dependencies and build
RUN lake update && lake build

# Runtime stage
FROM leanprover/lean4:4.31.0 AS runtime
ARG VERSION=dev

# Set working directory
WORKDIR /app

# Copy built artifacts from builder stage (Lake outputs live under .lake/)
COPY --from=builder /app/.lake /app/.lake
COPY --from=builder /app/lake-manifest.json /app/lake-manifest.json
COPY --from=builder /app/Lakefile.lean /app/Lakefile.lean
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
