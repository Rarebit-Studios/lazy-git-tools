# Show all lazy git-tools commands
@"
lazy git-tools — run from any terminal

  git-pull                    Update to latest commit and init/update submodules in this repo
  git-push                    Push changes (including submodules)
  git-commit [msg]            Commit latest changes (default: "Update")
  git-branch <name>           Create and switch to a new branch
  git-update-submodules [msg] Update all submodules: commit in each, then commit here (default: "Update")
  git-add-submodule <url> [name]     Add a repo as submodule in the current folder
  git-remove-submodule <path> Remove a submodule and clean up
  git-pull-submodule          Pull only the current submodule (run from inside submodule)
  git-push-submodule          Push only the current submodule (run from inside submodule)
  git-commit-submodule [msg]  Commit only in the current submodule (default: "Update")
  git-create                  Turn this folder into a repo: prompts for name, org, public/private
  git-switch-org              List GitHub orgs, transfer this repo to the one you choose
  git-switch-private          Set this GitHub repo to private
  git-switch-public           Set this GitHub repo to public
  git-login                   Log in to Git via browser (GitHub device flow)
  git-help                    Show this list
"@
