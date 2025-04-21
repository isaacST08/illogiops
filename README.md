# Illogiops

Illogiops (WIP) is a simple Nix flake to allow one to configure logiops using nix.

## Features

- Use the nix language to configure logiops.
- Automatically create systemd services to run logiops and to restart logid
  when waking up from sleep.

## Installation

Nix flakes must be enabled.

- Add `inputs.illogiops.url = "github:isaacST08/illogiops";` to your `flake.nix` file.
- Add `inputs.illogiops.nixosModules.default` to the `modules` list inside your `nixosConfiguration`
  for your system.

## TODO

This is still a WIP and breaking changes could still happen.

- Add support to ignore devices.
- Add configuration options for the scroll wheel.
- Add configuration options for the thumb wheel.
- Add support the `axis` parameter for gesture actions.
- Add support for configuring the `workers` option.
- Add support for configuring the `io_timeout` option.
