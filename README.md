# Illogiops

Illogiops is a simple Nix flake to allow one to configure logiops using nix.

## Features

- Use the nix language to configure logiops.
- Automatically create systemd services to run logiops and to restart logid
  when waking up from sleep.

## Installation

Nix flakes must be enabled.

- Add `inputs.illogiops.url = "github:isaacST08/illogiops";` to your `flake.nix` file.
- Add `inputs.illogiops.nixosModules.default` to the `modules` list inside your `nixosConfiguration`
  for your system.
