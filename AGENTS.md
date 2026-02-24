# AGENTS.md - Project Policy for rldyourterm (Codex Runtime)

## Scope
- Applies to repository: `/home/rldyourmnd/Desktop/projects/nddev_projects/awesome-terminal-for-ai`.
- Governs architecture, quality, and execution discipline for all sessions.

## 1) Product Priorities (hard priority order)
1. `СТАБИЛЬНОСТЬ`
   - Сохранение сессий при сбоях рендеринга.
   - Корректный failover: GPU -> CPU без падения процесса терминала.
   - Детект, retry/backoff и наблюдаемость для всех критических границ.
2. `BEST PRACTICES FOR AI TOOLS`
   - Поведение, заточенное под CLI-потоки CodeX, OpenCode, Claude Code, Gemini CLI.
   - Предсказуемая производительность ввода/вывода в автоматических сессиях.
   - Минимум шума в терминале и строгий контроль lifecycle shell-процессов.
3. `СКОРОСТЬ`
   - Низкая латентность (input -> frame).
   - Два режима рендера: `cpu` и `gpu`, плюс `auto`.
   - Контролируемое потребление памяти и устойчивый FPS.

## 1.1) Product Persona and Compatibility Intent
- Пользователь v1.0: визуальный продуктовый владелец и AI CLI power-user (длительные сессии с активной автоматизацией и shell-интеракциями), для которых критичны стабильность и предсказуемая скорость.
- Shell policy: дефолтно `fish + starship`; допускается прозрачный fallback на `zsh` как вспомогательный путь.
- Bash не является целевым shell для v1.0 на Linux/macOS; любые проверки Bash-совместимости выполняются через совместимые ANSI/terminal-паттерны.
- Терминальная совместимость в v1.0 фиксируется как корректность критичных сценариев: ANSI цвет/style, курсорные операции, очистка/перерисовка, прокрутка, paste, resize stability.

## 1.2 OS Coverage (v1 and Roadmap)
- v1.0.0: Linux (Ubuntu 22.04 LTS, 24.04 LTS, 25.10) + macOS.
- Roadmap for Linux: include future Ubuntu 26 LTS validation after initial 26.04 baseline in same release track.
- Windows support is part of phase architecture and implemented as a distinct platform slice.
- OS-specific code is not allowed in `core`; only in `foundation` and platform adapters.

## 2) Вехи разработки
- Шаг 1: рабочая версия базового терминала с одним окном и двумя рендерами (CPU/GPU), без расширений.
- Шаг 2: внедрение VSA архитектуры до уровня контрактов/границ.
- Шаг 3: расширение фичами после того, как базовое ядро стабильно.

## 3) Архитектурная модель VSA (обязательная)
- `foundation/`: адаптеры ОС (PTY, окна, clipboard, события окна, shell hooks).
- `core/`: доменная логика терминала (grid, escape/ANSI parser, сессионная модель), без зависимостей от окон/рендера.
- `services/`: оркестрация и переключение режимов, retry/fallback, контроль жизненного цикла сессий.
- `features/`: модульные возможности (render.cpu, render.gpu, settings.ui, shell.integration, diagnostics).
- `ui/`: отрисовка и интерфейс пользователя на основе контрактов сервисов.
- `app/`: бинарники/CLI и интеграционные сборки.

## 4) Правила зависимостей
- Все зависимости строго направлены внутрь.
- Взаимодействие слоев только через trait-порты (`api/`).
- `core` не имеет прямых зависимостей от конкретных фреймворков рендера/окон.

## 5) Принципы стабильности и производительности
- GPU и CPU режимы обязательны, оба должны быть production-ready.
- Автоматический fallback на CPU при любой GPU-проверяемой ошибке.
- Любой failure на слое интеграции не должен рушить core loop.
- Ошибки считаются штатным событием проектирования и переводятся в контролируемые состояния.

## 7) UI и настройки
- Никаких «только config-file» сценариев.
- Настройки редактируются внутри терминала через command palette (`Ctrl/Cmd + Shift + P`, командная строка настроек).
- Базовый визуальный стиль: современный shell UI, стартовая тема `cuberpunk`.

## 8) Shell Integration
- Базовый автологин для `fish + Starship` сохраняется как дефолт.
- Fallback на `zsh` допустим как поддерживающий сценарий для стабильности.
- Bash policy v1.0: не включён как целевой базовый shell, расширение только отдельным решением через roadmap.

## 8.1) Terminal Compatibility Contract
- Поддержка базового ANSI/terminal behavior обязательна для:
  - цвета, атрибуты и reset-последовательности,
  - позиционирование и движение курсора,
  - очистка экранов/областей,
  - управление scrollback и paste.
- Экзотические/редкие ANSI-расширения допускается обработать как деградационные без падения сессии.
- Производительность и целостность рендера для AI-сценариев выше приоритетна, чем полная legacy-совместимость.

## 9) Риск-минимизация и источники
- Отказываемся от импортов готовых терминальных исходных кодов как основного ядра.
- Для фундаментальных примитивов допускаются проверенные crates:
  - PTY: `portable-pty`
  - окно/события: `winit`
  - GPU рендер: `wgpu`
  - текстовая обработка через отдельный выбранный internal rendering pipeline
- Каждая внешняя зависимость должна иметь обоснование и быть изолированной адаптером.

## 9.1 Integration Scope (what we connect to / what we build)
- We do **not** inherit or copy terminal source trees as core logic.
- We integrate only OS-level primitives and reusable utility crates via adapters:
  - PTY lifecycle and IO: `portable-pty` (spawn/resize/read/write/kill).
  - Windowing + input + lifecycle: `winit`.
  - GPU acceleration: `wgpu` (backend-per-platform).
  - Text path: internal text subsystem (CPU + GPU implementations behind a common trait).
  - Clipboard + misc platform services: optional crate adapters (`arboard`, etc.) behind traits.

## 10) Работа с документацией и репозиторием
- Каждое исследование/решение по слоям и метрикам уходит в `planning/*`.
- Метрики и целевые параметры версий в `metrics/version/*/*.md`.
- Перед завершением этапа обязательно:
  - 1+ коммит,
  - пуш в GitHub,
  - короткое объяснение изменений.

## 11) Ориентиры качества для v1.0.0
- Целевой набор для фиксации: стабильные CPU/GPU режимы, базовая shell-совместимость,
  in-terminal palette settings, базовый cuberpunk UI, и наблюдаемость fallback-логики.
