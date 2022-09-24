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

### Usage

To clone a repository with post-clone hooks::

```sh
curl -fsSL https://raw.githubusercontent.com/issenn/git-config/master/bin/clone | zsh -s -- <normal-clone-args>
```

All arguments will be passed directly to `git clone`.

#### Manual

1. Clone this repository somewhere on disk::

    ```sh
    git clone https://github.com/issenn/git-config.git /tmp/post-clone
    ```

2. Clone the desired repository::

    ```sh
    git clone --template=/tmp/post-clone/templates git@github.com:username/repo-of-interest
    ```

In addition to cloning the repository, this method will: ensure

- if present in the cloned repo, `/hooks/` is symlinked to `/.git/hooks/`
- if present in the cloned repo, `/.git/hooks/post-clone` is invoked

    **Note**: this hook will not be automatically invoked again.
