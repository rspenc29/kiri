#!/bin/bash

set -e

VERSION=${1:-latest} docker compose build
