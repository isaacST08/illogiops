{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) concatStringsSep map;
  inherit (lib) types mkOption;
  inherit (lib.modules) mkDefault;

  cfg = config.services.illogiops;

  configFileName = "logid.cfg";

  # --- Custom Option Types ---
  # mkOption = {
  #   default ? null,
  #   defaultText ? null,
  #   example ? null,
  #   description ? null,
  #   relatedPackages ? null,
  #   type ? null,
  #   apply ? null,
  #   internal ? null,
  #   visible ? null,
  #   readOnly ? null,
  #   ...
  # } @ attrs:
  #   attrs // {_type = "option";};

  # mkDisableOption = name:
  #   mkOption {
  #     type = lib.types.bool;
  #     default = true;
  #     example = false;
  #     description = "Whether to enable ${name}.";
  #   };

  # --- Sub-modules ---

  # smartShift = import ./smartShift.nix {inherit lib;};
  # hiResScroll = import ./hiResScroll.nix {inherit lib;};
  # # button = import ./button.nix {
  # #   inherit lib;
  # #   config = cfg.buttons;
  # # };

  device = import ./device {inherit lib config;};
in
  # device = {name, ...}: {
  #   options = {
  #     enable = mkDisableOption "this device";
  #
  #     name = mkOption {
  #       type = lib.types.str;
  #       example = "MX Master 3";
  #       description = ''
  #         This is a required string field that defines the name of the device.
  #         To get the name of the device, launch logid with the device connected
  #         and it should print out a message with the device name.
  #         (e.g. `name: "MX Master";`)
  #       '';
  #     };
  #
  #     dpi = mkOption {
  #       type = lib.types.int;
  #       default = 1000;
  #       example = 1200;
  #       description = ''
  #         Sets the DPI for a mouse that supports it.
  #       '';
  #     };
  #
  #     smartShift = mkOption {
  #       description = ''
  #         This is an optional object field that defines the SmartShift settings
  #         for a mouse that supports it.
  #       '';
  #       default = {};
  #       type = lib.types.submodule smartShift;
  #     };
  #
  #     hiResScroll = mkOption {
  #       description = ''
  #         This is an optional object field that defines the HiRes
  #         mouse-scrolling settings for a device that supports it.
  #       '';
  #       default = {};
  #       type = lib.types.submodule hiResScroll;
  #     };
  #
  #     buttons = mkOption {
  #       description = ''
  #         This is an optional array field that defines the mappings for
  #         buttons.
  #       '';
  #       default = {};
  #       type = lib.types.attrsOf (
  #         lib.types.submodule (
  #           import ./button.nix {
  #             inherit lib;
  #             config = cfg.devices."${name}".buttons;
  #           }
  #         )
  #       );
  #     };
  #   };
  #
  #   config = {
  #     name = mkDefault name;
  #   };
  # };
  {
    options.services.illogiops = {
      enable = lib.mkEnableOption "illogiops";
      package = mkOption {
        type = lib.types.package;
        default = pkgs.logiops;
        description = ''
          The logiops package to use.
        '';
      };

      restartAfterSleep = mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = ''
          Whether to restart the logid service after the system wakes from sleep.
          This is needed in most cases.
        '';
      };

      devices = mkOption {
        default = {};
        type = lib.types.attrsOf (lib.types.submodule device);
        example = {};
      };
    };

    config = lib.mkIf cfg.enable {
      # Add the package to the system
      environment.systemPackages = [cfg.package];

      # Create the main systemd service
      systemd.services.logid = mkDefault {
        enable = cfg.enable;
        wantedBy = ["multi-user.target"];
        restartIfChanged = true;
        description = "An unofficial userspace driver for HID++ Logitech devices";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${cfg.package}/bin/logid";
          Restart = "always";
        };
      };

      # Service to restart the logid service after the system wakes from sleep
      systemd.services.logidrestart = mkDefault {
        enable = cfg.restartAfterSleep;
        description = "Restart logid.service after resume from sleep";
        wantedBy = ["suspend.target"];
        after = ["suspend.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.systemd}/bin/systemctl --no-block restart logid.service";
        };
      };

      environment.etc."logidd.cfg".text = let
        indent = spaces: string:
          if spaces > 0
          then (indent (spaces - 1) (builtins.replaceStrings ["\n"] ["\n "] string))
          else string;

        fmtObjectAttrs = fmtFunction: objectsConfig: indentSpaces: (indent indentSpaces (
          concatStringsSep ",\n" (map fmtFunction (builtins.attrValues objectsConfig))
        ));
        # ${indent 2 (concatStringsSep ",\n" (map deviceFmt (builtins.attrValues cfg.devices)))}

        deviceFmt = import ./fmt/device.nix {inherit lib fmtObjectAttrs;};
      in ''
        devices: (
          ${fmtObjectAttrs deviceFmt cfg.devices 2}
        );
      '';
    };
  }
