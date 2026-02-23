# Troubleshooting

This guide captures operational failures commonly seen on Debian/Ubuntu systems.

## General Recovery

- Re-run the relevant installer script after fixing prerequisites.
- Ensure internet access and valid `sudo` credentials for system package steps.
- Re-run `./scripts/health-check.sh --summary` after each change.

## Common Issues and Fixes

### 1) Layer script exits with `command not found`

**Cause**

Required package/tool is missing.

**Fix**

```bash
sudo apt update
sudo apt install -y <package>
./scripts/install-layer-2.sh # or relevant layer
```

### 2) `config parity check failed`

**Cause**

Local dotfiles diverge from repository templates.

**Fix**

```bash
cp configs/wezterm/wezterm.lua ~/.wezterm.lua
cp configs/fish/config.fish ~/.config/fish/config.fish
mkdir -p ~/.config
cp configs/starship/starship.toml ~/.config/starship.toml
```

Then re-open shell and rerun health-check.

### 3) `semgrep` command fails with `PermissionError: .../.semgrep/semgrep.log`

**Cause**

Semgrep cannot write to its log file on this machine (known local issue).

**Fix**

```bash
rm -f ~/.semgrep/semgrep.log
mkdir -p ~/.semgrep
chmod 700 ~/.semgrep
```

Then run again:

```bash
semgrep scan --config auto .  # for a quick validation
```

If issue persists, remove stale user-level Python package cache and reinstall:

```bash
python3 -m pip uninstall -y semgrep
python3 -m pip install --user semgrep
```

### 4) `gemini` command times out / hangs

**Cause**

This environment executes `gemini` in interactive mode before completing CLI init.

**Fix**

- Confirm network and shell env vars (`HTTPS_PROXY`, `PATH`, cert trust).
- Run interactive auth once in a normal shell:

```bash
gemini
```

- For non-interactive use, define `GEMINI_API_KEY`.

### 5) `~/.local/bin` missing or not on `PATH`

**Cause**

Local binary installs in scripts go into `~/.local/bin`, but not all shells source
PATH updates consistently.

**Fix**

```bash
mkdir -p ~/.local/bin
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  echo 'set -gx PATH "$HOME/.local/bin:$PATH"' >> ~/.config/fish/config.fish
fi
```

Then restart shell.

### 6) `curl` or GitHub API blocked

**Cause**

Corporate proxy/firewall limits release metadata fetch.

**Fix**

- Ensure outbound HTTPS access.
- Re-run failing layer with explicit retries.

```bash
CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt ./scripts/install-layer-3.sh
```

## Escalation Protocol

If issues continue after remediation:

1. Save `./scripts/health-check.sh --summary` output.
2. Capture shell logs and command stderr.
3. Open an issue with:
   - Distribution (`cat /etc/os-release`)
   - Layer and command that failed
   - Exact error block
   - Output of `./scripts/health-check.sh`
