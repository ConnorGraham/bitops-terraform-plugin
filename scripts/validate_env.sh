#!/usr/bin/env bash
set -e 

if [ -n "$SKIP_DEPLOY_TERRAFORM" ]; then
  echo "SKIP_DEPLOY_TERRAFORM set..."
  exit 0
fi

if [ ! -d "$ENVIRONMENT_DIR" ]; then
  echo "No terraform directory.  Skipping."
  exit 0
fi