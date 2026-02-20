#!/bin/bash
# Local startup script for codestandards-java-mcp

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

if [ ! -d ".venv" ]; then
  echo "Creating virtual environment..."
  python -m venv .venv
fi

echo "Activating virtual environment..."
source .venv/Scripts/activate 2>/dev/null || source .venv/bin/activate

echo "Installing dependencies..."
pip install -r requirements.txt --quiet

echo "Starting MCP server on http://127.0.0.1:8000 ..."
python src/server.py
