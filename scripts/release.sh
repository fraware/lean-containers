#!/bin/bash
# Release script for lean-containers

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "Lakefile.lean" ]; then
    print_error "Please run this script from the project root directory"
    exit 1
fi

# Get version from Lakefile.lean
VERSION=$(grep "version :=" Lakefile.lean | sed 's/.*version := "\(.*\)".*/\1/')
if [ -z "$VERSION" ]; then
    print_error "Could not determine version from Lakefile.lean"
    exit 1
fi

print_status "Starting release process for version $VERSION"

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    print_warning "Docker not found. Skipping Docker-related checks."
    SKIP_DOCKER=true
else
    SKIP_DOCKER=false
fi

# Step 1: Clean and build
print_status "Step 1: Cleaning and building project..."
make clean
make build

# Step 2: Run tests
print_status "Step 2: Running tests..."
make test

# Step 3: Test Docker build (if available)
if [ "$SKIP_DOCKER" = false ]; then
    print_status "Step 3: Testing Docker build..."
    docker build -t lean-containers:$VERSION .
    docker build -t lean-containers:latest .
    
    print_status "Step 4: Testing Docker run..."
    docker run --rm lean-containers:$VERSION
else
    print_warning "Skipping Docker tests"
fi

# Step 4: Create release archive
print_status "Creating release archive..."
mkdir -p release
cp -r src release/
cp Lakefile.lean release/
cp lake-manifest.json release/
cp lean-toolchain release/
cp Main.lean release/
cp FinalProductionTest.lean release/
cp README.md release/
cp Makefile release/
cp Dockerfile release/
cp .dockerignore release/

tar -czf lean-containers-$VERSION.tar.gz -C release .
rm -rf release

print_status "Release archive created: lean-containers-$VERSION.tar.gz"

# Step 5: Summary
print_status "Release process completed successfully!"
echo ""
echo "Next steps:"
echo "1. Create a GitHub release with tag v$VERSION"
echo "2. Upload lean-containers-$VERSION.tar.gz to the release"
if [ "$SKIP_DOCKER" = false ]; then
    echo "3. Push Docker images:"
    echo "   docker tag lean-containers:$VERSION ghcr.io/your-org/lean-containers:$VERSION"
    echo "   docker tag lean-containers:latest ghcr.io/your-org/lean-containers:latest"
    echo "   docker push ghcr.io/your-org/lean-containers:$VERSION"
    echo "   docker push ghcr.io/your-org/lean-containers:latest"
fi
echo "4. Update documentation if needed"
echo ""
print_status "Release ready for distribution!"
