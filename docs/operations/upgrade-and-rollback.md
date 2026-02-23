# Upgrade and Rollback Playbook

This playbook supports deterministic upgrades without breaking existing terminals.

## Standard Upgrade Procedure

1. Snapshot current state.

```bash
git status --short
cp -a ~/.wezterm.lua ~/.wezterm.lua.pre-upgrade.bak
cp -a ~/.config/fish/config.fish ~/.config/fish/config.fish.pre-upgrade.bak
cp -a ~/.config/starship.toml ~/.config/starship.toml.pre-upgrade.bak
```

2. Pull latest repo changes.

```bash
git pull --ff-only origin main
```

3. Re-run installer layers in order.

```bash
./scripts/install-foundation.sh
./scripts/install-layer-1.sh
./scripts/install-layer-2.sh
./scripts/install-layer-3.sh
./scripts/install-layer-4.sh
./scripts/install-layer-5.sh
```

4. Run health-check and confirm success criteria.

```bash
./scripts/health-check.sh --summary
```

5. Validate runtime.

```bash
exec fish
lazygit
gh --version
grepai help
```

## Rollback Procedure

If the upgrade causes breakage:

1. Capture current bad state and revert changes.

```bash
git checkout -- scripts install.sh docs context CHANGELOG.md
```

2. Restore previous configs from backup copies.

```bash
mv ~/.wezterm.lua.pre-upgrade.bak ~/.wezterm.lua
mv ~/.config/fish/config.fish.pre-upgrade.bak ~/.config/fish/config.fish
mv ~/.config/starship.toml.pre-upgrade.bak ~/.config/starship.toml
```

3. Re-run health-check in summary mode.

```bash
./scripts/health-check.sh --summary
```

4. If shell behavior remains broken, start with a fresh login shell session and re-open.

## Controlled Rollback with Git

- For repository-level revert:

```bash
git log --oneline -n 10
git checkout <known-good-commit>
```

- For a hotfix path, apply only a minimal commit.

## Safety Rules

- Never remove `~/.local/bin` content unless restoring a clean backup.
- Never run `apt` commands while package manager lock is active.
- Always run health-check before and after any bulk change.

## Sign-off

- Upgrade complete only when:
  - `./scripts/health-check.sh --summary` passes required checks
  - shell startup and core layer commands work in a fresh shell
  - config parity is intentional (or documented exception)
