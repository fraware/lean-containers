# lean-containers Makefile
# Provides convenient targets for development, testing, and release

.PHONY: help dev run release test clean build install

# Default target
help: ## Show this help message
	@echo "lean-containers Makefile"
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

dev: ## Set up local development environment
	@echo "Setting up development environment..."
	@if ! command -v lean >/dev/null 2>&1; then \
		echo "Installing Lean 4..."; \
		curl https://raw.githubusercontent.com/leanprover/lean4/master/elan-init.sh -sSf | sh; \
		source ~/.bashrc 2>/dev/null || true; \
	fi
	@if ! command -v lake >/dev/null 2>&1; then \
		echo "Lake is included with Lean 4"; \
	fi
	lake update
	lake build
	@echo "Development environment ready!"

run: ## Run the application/CLI locally
	@echo "Running lean-containers..."
	lake build
	lean Main.lean

test: ## Run all tests
	@echo "Running production tests..."
	lake build
	lean FinalProductionTest.lean
	@echo "All tests passed!"

build: ## Build the project
	@echo "Building lean-containers..."
	lake build

clean: ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	lake clean

install: ## Install as a dependency (for Lake projects)
	@echo "To use lean-containers in your Lake project, add to your Lakefile:"
	@echo "require lean-containers from git \"https://github.com/your-org/lean-containers.git\""

release-dry: ## Build and test release artifacts (dry run)
	@echo "Dry run release process..."
	@echo "1. Building project..."
	lake build
	@echo "2. Running tests..."
	lean FinalProductionTest.lean
	@echo "3. Testing Docker build..."
	docker build -t lean-containers:test .
	@echo "4. Testing Docker run..."
	docker run --rm lean-containers:test
	@echo "Release dry run completed successfully!"

release: ## Build and publish artifacts
	@echo "Running release script..."
	@if [ -f scripts/release.sh ]; then \
		chmod +x scripts/release.sh && ./scripts/release.sh; \
	elif [ -f scripts/release.bat ]; then \
		scripts/release.bat; \
	else \
		echo "Building release artifacts manually..."; \
		$(MAKE) build; \
		$(MAKE) test; \
		echo "Building Docker image..."; \
		docker build -t ghcr.io/your-org/lean-containers:latest .; \
		docker build -t ghcr.io/your-org/lean-containers:v1.0.0 .; \
		echo "Release artifacts built successfully!"; \
		echo "To publish:"; \
		echo "  docker push ghcr.io/your-org/lean-containers:latest"; \
		echo "  docker push ghcr.io/your-org/lean-containers:v1.0.0"; \
	fi

docker-build: ## Build Docker image
	docker build -t lean-containers .

docker-run: ## Run Docker container
	docker run --rm lean-containers

# CI/CD targets
ci-test: ## Run tests for CI
	lake build
	lean FinalProductionTest.lean

ci-build: ## Build for CI
	lake build
