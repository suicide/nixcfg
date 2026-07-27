# 0001. Feature-Owned Home Configuration

**Status:** Accepted

**Amended:** 2026-07-27 — clarified the `misc` and persistence-only feature
module conventions.

## Context

The configuration is migrating from separate system and Home Manager trees to
auto-discovered flake-parts modules. A generic `modules/home/` tree for every
Home Manager module would obscure whether a module configures an application,
a service, or foundational home-directory data. Application state also needs
to persist on impermanent NixOS hosts, but Home Manager Impermanence is not in
use because of its recursion and bindfs overhead.

## Decision

- Keep `hosts/` as the top-level location for host-local data and generated
  inputs. Keep `modules/hosts/` for host composition.
- Organize shared modules by ownership:
  - `modules/apps/` contains user-facing application modules.
  - `modules/services/` contains system and session-service integrations.
  - `modules/home/` contains foundational home-directory structure and
    non-application user data.
- Use an app-level `misc` module only for simple package declarations that do
  not require feature-specific configuration. Do not use it as a catch-all for
  configured applications or services.
- Register Home Manager modules under `internal.modules.home.<feature>`.
  Platform/user composition selects them explicitly; they are not implicitly
  imported as one global Home Manager profile.
- A stateful application may register both a Home Manager module and a NixOS
  module in the same feature file. The NixOS module owns that application's
  `environment.persistence` declarations, using project options for the
  persistence directory and main user rather than hardcoded values.
- Keep generic personal data, credentials, and non-application home state in
  `modules/home/` persistence modules.
- A persistence-only application module is valid when infrequently used
  software still has important state to retain. Such a module must not install
  or enable the software merely because it persists its state.

## Consequences

- Application configuration and the persistent paths it requires can be found
  together, avoiding a central list with unclear ownership.
- NixOS persistence remains the mechanism for persistent home state; Home
  Manager Impermanence remains disabled.
- Persistence-only modules retain data independently of whether their related
  applications are currently installed.
- Linux and Darwin Home Manager feature lists must remain explicit so
  Linux-only desktop modules are not evaluated on Darwin.
- Existing Home Manager modules can migrate incrementally without changing
  host-local configuration or encrypted secret contents.
