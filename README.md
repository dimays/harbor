# Harbor

Harbor is a monorepo for managing all my personal programming projects. It serves as a central hub for project templates, automation scripts, and organizational tooling.

## Structure

```
harbor/
├─ templates/          # Base and child project templates
├─ scripts/            # Automation scripts (e.g., create-project.sh)
├─ projects/           # Personal projects (gitignored in Harbor)
├─ .devcontainer/      # Base dev container for development
├─ .gitignore          # Excludes projects/ directory
└─ README.md           # This file
```

## Prerequisites

Before using Harbor and running create-project.sh, make sure you have the following installed and configured:

1. Visual Studio Code

   - Download and install [VSCode](https://code.visualstudio.com/)
   - Recommended settings (add to settings.json):
     - editor.formatOnSave: true
     - terminal.integrated.defaultProfile.linux: bash
     - remote.containers.forwardAgent: true
   - Recommended extensions:
     - ms-vscode-remote.remote-containers (devcontainer support)
     - esbenp.prettier-vscode (code formatting)

2. Docker Desktop

   - Download and install [Docker Desktop](https://www.docker.com/products/docker-desktop)
   - Start Docker Desktop and make sure it’s running.
   - Confirm you can run Docker commands: docker ps
   - Enable SSH agent forwarding to use GitHub SSH keys inside devcontainers.

3. Git & GitHub

   - Install Git if not already installed.
   - Configure Git identity:
     - git config --global user.name "Your Name"
     - git config --global user.email "you@example.com"
   - Set up GitHub authentication:
     - SSH keys: generate and add to GitHub
       - ssh-keygen -t ed25519 -C "your_email@example.com"
       - ssh-add ~/.ssh/id_ed25519
     - Generate Personal Access Token (classic) and store it locally as GH_TOKEN env variable
     - Ensure you can push/pull to GitHub from your host.

4. Devcontainer Setup
   - Open Harbor in VSCode and let it build the devcontainer.
   - The container will have tools required for project creation, including:
     - rsync
     - git
     - gh CLI for creating repositories

## Usage

To create a new project:

```bash
cd harbor
scripts/create-project.sh <project_name> [child_template]
```

- `<project_name>` – The name of your new project
- `[child_template]` – Optional child template to overlay on the base template

This script will:

1. Copy the base template (and optionally a child template) to `projects/<project_name>`
2. Replace placeholders in files and directories with your project name
3. Initialize a Git repository for the project
4. Create a corresponding GitHub repository using the username defined in the `.env` file

## Templates

- `dev-template` – Lightweight base Python project
- `dev-template-dbt` – dbt project template
- `dev-template-ctk` – CustomTkinter GUI project template

## Notes

- The `projects/` directory is **gitignored** in Harbor. This keeps the monorepo lightweight while allowing each project to maintain its own repository and remote.
- Harbor ensures consistent structure and tooling across all personal projects.
