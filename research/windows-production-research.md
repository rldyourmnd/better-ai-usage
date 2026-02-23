# Windows Production Research Notes

Date: 2026-02-23

This note captures the evidence used to implement the Windows production pipeline.

## Official Sources Used

- WinGet CLI documentation (`microsoft/winget-cli`): install/search/upgrade and automation flags (`--id`, `--exact`, `--silent`, `--accept-*`, `--disable-interactivity`).
- WinGet manifest repository (`microsoft/winget-pkgs`): package identifier verification through manifest paths.
- PowerShell docs (`microsoftdocs/powershell-docs`): profile creation via `$PROFILE` and execution policy (`RemoteSigned`, `CurrentUser`).
- WezTerm docs (`wezterm/wezterm`): platform gating with `wezterm.target_triple` and `config.default_prog` for Windows.
- Starship docs (`starship.rs`): PowerShell init line (`Invoke-Expression (&starship init powershell)`).
- zoxide docs (`ajeetdsouza/zoxide`): Windows install and PowerShell integration approach.
- uv docs (`astral-sh/uv`): Windows official installer (`install.ps1`) and `uv tool install` workflow.
- Bun docs (`oven-sh/bun`): Windows official installer (`bun.sh/install.ps1`).
- Semgrep docs (`semgrep/semgrep-docs`): CLI install and version verification.

## WinGet IDs Verified Against Manifest Paths

The following package IDs were validated against paths in
`https://github.com/microsoft/winget-pkgs/tree/master/manifests/...`.

- `wez.wezterm`
- `Microsoft.PowerShell`
- `Starship.Starship`
- `Git.Git`
- `DEVCOM.JetBrainsMonoNerdFont`
- `sharkdp.bat`
- `sharkdp.fd`
- `BurntSushi.ripgrep.MSVC`
- `chmln.sd`
- `jqlang.jq`
- `MikeFarah.yq`
- `eza-community.eza`
- `junegunn.fzf`
- `ajeetdsouza.zoxide`
- `Atuinsh.Atuin`
- `astral-sh.uv`
- `Oven-sh.Bun`
- `charmbracelet.glow`
- `Clement.bottom`
- `sharkdp.hyperfine`
- `GitHub.cli`
- `JesseDuffield.lazygit`
- `dandavison.delta`
- `UniversalCtags.Ctags`
- `XAMPPRocky.Tokei`
- `ast-grep.ast-grep`
- `OpenJS.NodeJS.LTS`
- `Rustlang.Rustup`

## Fallback Decisions (When WinGet Coverage Is Uneven)

- `watchexec`: install via `cargo install watchexec-cli`.
- `probe`: install via `cargo install probe-code`.
- `semgrep`: install via `uv tool install semgrep`.
- `grepai`: install from latest GitHub Windows release asset (`windows_amd64.zip` or `windows_arm64.zip`).

## Platform Semantics Decision

- Native Windows baseline shell is PowerShell (`pwsh`) for production stability.
- Fish support on Windows is documented as WSL/MSYS2/Cygwin-oriented; the pipeline keeps
  Fish as optional via WSL guidance instead of forcing a fragile native path.
