#!/bin/bash
# Validate release metadata consistency for lean-containers.
# Canonical version is the single line in ./VERSION (X.Y.Z).
# Git tags must be vX.Y.Z and match VERSION.
# Usage:
#   scripts/check-release-consistency.sh
#   scripts/check-release-consistency.sh v0.1.0

set -euo pipefail

if [ ! -f "VERSION" ]; then
  echo "[ERROR] VERSION file missing at repository root."
  exit 1
fi

VERSION="$(tr -d '\r\n' < VERSION | tr -d ' ')"
if ! echo "$VERSION" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "[ERROR] VERSION must be X.Y.Z, got: ${VERSION:-<empty>}"
  exit 1
fi

TAG="v${VERSION}"

if [ $# -gt 1 ]; then
  echo "[ERROR] Usage: $0 [vX.Y.Z]"
  exit 1
fi

if [ $# -eq 1 ]; then
  if [ "$1" != "$TAG" ]; then
    echo "[ERROR] Tag $1 does not match VERSION file (expected $TAG)."
    exit 1
  fi
fi

if ! grep -Eq "[[:space:]]*version[[:space:]]*:=.*v!\"${VERSION}\"" lakefile.lean; then
  echo "[ERROR] lakefile.lean must set version := v!\"${VERSION}\" to match VERSION file."
  exit 1
fi

if [ -f "lean-containers-${TAG}.tar.gz" ]; then
  echo "[INFO] Found release artifact: lean-containers-${TAG}.tar.gz"
else
  echo "[INFO] Artifact not present locally yet: lean-containers-${TAG}.tar.gz"
fi

echo "[OK] Release metadata is consistent (VERSION=${VERSION}, tag=${TAG})."
