# git-tools

**Cross-platform git helper scripts** — pull, push, commit, submodules, branch, and GitHub login. Install once per system, use from any terminal. 

I made this because I am lazy. 

## Scripts

| Command | Description |
|---------|-------------|
| `git-pull` | Update to latest commit and init/update submodules in this repo |
| `git-push` | Push changes in this repo (including submodules) |
| `git-commit` [*comment*] | Commit latest changes (default message: "Update") |
| `git-commit-submodules` [*comment*] | Commit in all submodules and in this repo (default: "Update") |
| `git-import-submodule` *url* [*path*] | Add a git repo as a submodule |
| `git-branch` *name* | Create and switch to a new branch |
| `git-login` | Log in to Git via browser (GitHub device flow) |

## Setup

Run the script for your platform (installs Git if missing, then installs the scripts globally). After that, the commands are available from any terminal.

- **Linux (Arch):** `./setup-arch.sh`
- **Linux (Debian/Ubuntu):** `./setup-debian.sh`
- **macOS:** `./setup-mac.sh`
- **Windows (PowerShell):** `.\setup-windows.ps1`
