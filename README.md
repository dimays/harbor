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

## Usage

To create a new project:

```bash
cd harbor
scripts/create-project.sh <project_name> [child_template]
```

* `<project_name>` – The name of your new project
* `[child_template]` – Optional child template to overlay on the base template

This script will:

1. Copy the base template (and optionally a child template) to `projects/<project_name>`
2. Replace placeholders in files and directories with your project name
3. Initialize a Git repository for the project
4. Create a corresponding GitHub repository using the username defined in the `.env` file

## Templates

* `dev-template` – Lightweight base Python project
* `dev-template-django` – Python Django project template
* `dev-template-dbt` – dbt project template
* `dev-template-ctk` – CustomTkinter GUI project template

## Notes

* The `projects/` directory is **gitignored** in Harbor. This keeps the monorepo lightweight while allowing each project to maintain its own repository and remote.
* Harbor ensures consistent structure and tooling across all personal projects.
