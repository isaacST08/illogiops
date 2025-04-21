{specialArgs}: {
  config,
  lib,
  pkgs,
  ...
}: let
  # ----- INHERITANCE -----
  inherit (builtins) concatStringsSep map;
  inherit (illogiopsLib.strings) indent;
  inherit (lib) mkOption mkIf;
  inherit (lib.modules) mkDefault;
  inherit (specialArgs) illogiopsLib;

  # ----- VARS -----
  cfg = config.services.illogiops;
  configFileName = "logid.cfg";

  # ----- SUB-MODULES -----
  device = import ./device {inherit lib config;};
in {
  options.services.illogiops = {
    enable = lib.mkEnableOption "illogiops";

    package = mkOption {
      type = lib.types.package;
      default = pkgs.logiops;
      description = "The logiops package to use.";
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
      type = with lib.types; attrsOf (submodule device);
      default = {};
    };
  };

  config = mkIf cfg.enable {
    # Add the package to the system
    environment.systemPackages = [cfg.package];

    # Create the main systemd service for logiops
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

    environment.etc."${configFileName}".text = let
      fmtObjectAttrs = fmtFunction: objectsConfig: indentSpaces: (indent indentSpaces (
        concatStringsSep ",\n" (map fmtFunction (builtins.attrValues objectsConfig))
      ));

      formatOptionValue = v:
        if builtins.isList v
        then ''[ ${lib.strings.concatMapStringsSep ", " formatOptionValue v} ]''
        else if builtins.isString v
        then ''"${v}"''
        else ''${toString v}'';

      fmtInheritancePackage = {
        inherit
          lib
          fmtObjectAttrs
          formatOptionValue
          illogiopsLib
          ;
      };

      deviceFmt = import ./fmt/device.nix fmtInheritancePackage;
    in ''
      devices: (
        ${fmtObjectAttrs deviceFmt cfg.devices 2}
      );'';
  };
}
