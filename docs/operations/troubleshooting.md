# Troubleshooting

This guide captures operational failures commonly seen across Linux
(Debian/Ubuntu), macOS, and Windows flows.

## General Recovery

- Re-run the relevant installer script after fixing prerequisites.
- Ensure internet access and valid `sudo` credentials for system package steps.
- Re-run `./scripts/health-check.sh --summary` after each change.
- On macOS use `./scripts/health-check-macos.sh --summary`.
- On Windows use `.\scripts\health-check-windows.ps1 -Summary`.

## Common Issues and Fixes

### 1) Layer script exits with `command not found`

**Cause**

Required package/tool is missing.

**Fix**

```bash
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends <package>
./scripts/linux/install-layer-2.sh # or relevant layer
```

Windows equivalent:

```powershell
winget install --id <Package.Id> --exact --source winget
.\scripts\install-windows.ps1
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

### 3) WezTerm spam logs: `while processing update-status event: runtime error`

**Cause**

Lua callback in `update-status` fails repeatedly (commonly due to passing
multi-return values like `string.gsub(...)` directly into `table.insert(...)`).

**Fix**

Sync local config from the repository:

```bash
cp configs/wezterm/wezterm.lua ~/.wezterm.lua
```

Reload WezTerm config (`Ctrl+Shift+R` by default) and validate:

```bash
journalctl --user -b --since '10 minutes ago' | rg "update-status event: runtime error"
```

### 4) `semgrep` command fails with `PermissionError: .../.semgrep/semgrep.log`

**Cause**

Either:
- local Semgrep log path permissions are broken, or
- command is executed in a restricted sandbox that blocks writes to `~/.semgrep`.

**Fix**

```bash
rm -f ~/.semgrep/semgrep.log
mkdir -p ~/.semgrep
chmod 700 ~/.semgrep
touch ~/.semgrep/semgrep.log
chmod 600 ~/.semgrep/semgrep.log
```

Then run again:

```bash
semgrep scan --config auto .  # for a quick validation
```

If validation works in a normal shell but fails in a restricted automation
runtime, treat it as an environment limitation (not a host issue).

If issue persists, remove stale user-level Python package cache and reinstall:

```bash
python3 -m pip uninstall -y semgrep
python3 -m pip install --user semgrep
```

### 5) `gemini` command times out / hangs

**Cause**

This environment executes `gemini` in interactive mode before completing CLI init.

**Fix**

- Confirm network and shell env vars (`HTTPS_PROXY`, `PATH`, cert trust).
- Run interactive auth once in a normal shell:

```bash
gemini
```

- For non-interactive use, define `GEMINI_API_KEY`.

### 6) `~/.local/bin` missing or not on `PATH`

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

### 7) `curl` or GitHub API blocked

**Cause**

Corporate proxy/firewall limits release metadata fetch.

**Fix**

- Ensure outbound HTTPS access.
- Re-run failing layer with explicit retries.

```bash
CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt ./scripts/linux/install-layer-3.sh
```

### 8) `sg` exists but is not ast-grep

**Cause**

Some Linux systems expose `sg` from `util-linux`, which is not `ast-grep`.

**Fix**

```bash
~/.cargo/bin/sg --version
cargo install --locked ast-grep
./scripts/health-check.sh --strict --summary
```

### 9) `nvidia-smi` fails with `Failed to initialize NVML: Unknown Error`

**Cause**

`nvidia-persistenced` is inactive or NVML runtime path is in a degraded state.

**Fix**

Run recovery utility:

```bash
./scripts/linux/fix-nvidia-nvml.sh
```

Manual fallback:

```bash
sudo systemctl start nvidia-persistenced
sudo systemctl add-wants multi-user.target nvidia-persistenced.service
nvidia-smi
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
