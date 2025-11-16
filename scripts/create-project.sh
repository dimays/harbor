#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Usage:
#   ./create-project.sh <project_name> [<child_template>]
# -----------------------------
PROJECT_NAME=$1
CHILD_TEMPLATE=${2:-""} # Optional child template overlay
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HARBOR_ROOT="$(dirname "$(dirname "$(dirname "$SCRIPT_DIR")")")" # This file's grandparent directory
TEMPLATE_DIR="$HARBOR_ROOT/templates/dev-template"
PROJECTS_DIR="$HARBOR_ROOT/projects"
TARGET_DIR="$PROJECTS_DIR/$PROJECT_NAME"
# SED command has slightly different syntax in Max vs. Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    SED_CMD="sed -i ''"
else
    SED_CMD="sed -i"
fi

# -----------------------------
# Create project directory
# -----------------------------
if [ -d "$TARGET_DIR" ]; then
    echo "Error: Directory $TARGET_DIR already exists"
    exit 1
fi

mkdir -p "$TARGET_DIR"

# -----------------------------
# Copy base template
# -----------------------------
rsync -av --exclude='scripts/' --exclude='.git/' "$TEMPLATE_DIR/" "$TARGET_DIR/"

# -----------------------------
# Apply child template overlay if specified
# -----------------------------
if [ -n "$CHILD_TEMPLATE" ]; then
    CHILD_TEMPLATE_DIR="$HARBOR_ROOT/templates/$CHILD_TEMPLATE"
    if [ ! -d "$CHILD_TEMPLATE_DIR" ]; then
        echo "Error: Child template $CHILD_TEMPLATE does not exist"
        exit 1
    fi
    echo "Applying child template overlay: $CHILD_TEMPLATE"
    rsync -av --exclude='scripts/' "$CHILD_TEMPLATE_DIR/" "$TARGET_DIR/"
fi

# -----------------------------
# Copy .env.example → .env
# -----------------------------
if [ -f "$TARGET_DIR/.env.example" ]; then
    cp "$TARGET_DIR/.env.example" "$TARGET_DIR/.env"
    $SED_CMD "s/__project__/$PROJECT_NAME/g" "$TARGET_DIR/.env"
else
    echo "Warning: .env.example not found, skipping .env creation"
fi

# -----------------------------
# Overwrite README.md with project-specific content
# -----------------------------
cat > "$TARGET_DIR/README.md" <<EOF
# $PROJECT_NAME

Boilerplate README file for $PROJECT_NAME
EOF

# -----------------------------
# Replace __project__ placeholders with $PROJECT_NAME
# -----------------------------

# Replace directory placeholders
mv "$TARGET_DIR/src/__project__" "$TARGET_DIR/src/$PROJECT_NAME"
mv "$TARGET_DIR/tests/__project__" "$TARGET_DIR/tests/$PROJECT_NAME"

# Replace placeholders in all relevant files
grep -rl "__project__" "$TARGET_DIR/src" "$TARGET_DIR/tests" | xargs $SED_CMD "s/__project__/$PROJECT_NAME/g"

# -----------------------------
# Load GITHUB_USERNAME from the new project's .env
# -----------------------------
if [ ! -f "$TARGET_DIR/.env" ]; then
    echo "Error: .env file missing in $TARGET_DIR"
    exit 1
fi

export $(grep -v '^#' "$TARGET_DIR/.env" | xargs)

if [ -z "${GITHUB_USERNAME-}" ]; then
    echo "Error: GITHUB_USERNAME variable not defined in .env"
    exit 1
fi

# -----------------------------
# Initialize git and create GitHub repo
# -----------------------------
pushd "$TARGET_DIR" >/dev/null

rm -rf .git || true
git init
git add .
git commit -m "Initial commit from dev-template"

GITHUB_REPO="$GITHUB_USERNAME/$PROJECT_NAME"
echo "Creating GitHub repository: $GITHUB_REPO"

if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) not installed"
    exit 1
fi

# Create repo and push
gh repo create "$GITHUB_REPO" --private --source="$TARGET_DIR" --remote=origin --push

popd >/dev/null

echo "✔ Project $PROJECT_NAME created at $TARGET_DIR with remote $GITHUB_REPO"
