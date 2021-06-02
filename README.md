# git-config

```sh
git update-index --skip-worktree .ssh/id_rsa
git update-index --skip-worktree .ssh/id_rsa.pub
git update-index --skip-worktree .ssh/known_hosts
```

```sh
chown -R $(whoami) "${HOME}/.ssh"
find "${HOME}/.ssh" -type f -exec chmod 600 {} \;
find "${HOME}/.ssh" -type l -exec chmod 600 {} \;
find "${HOME}/.ssh" -type d -exec chmod 700 {} \;
```

```sh
chmod +x .config/git/templates/hooks/post-checkout || chmod +x .config/git/templates/hooks/pre_commit
```
