{
  config,
  lib,
  ...
}: let
  # ----- INHERITANCE -----
  inherit (lib) mkOption;
  inherit (lib.modules) mkForce;
  inherit (lib.types) bool str int;

  # ----- VARIABLES -----
  devicesConfig = config.services.illogiops.devices;

  # ----- OPTION CONSTRUCTORS -----
  mkDisableOption = name:
    mkOption {
      type = bool;
      default = true;
      example = false;
      description = "Whether to enable ${name}.";
    };

  # ----- SUB-MODULES -----
  smartShiftSubmodule = import ./smartShiftSubmodule.nix {inherit lib;};
  highResScrollSubmodule = import ./highResScrollSubmodule.nix {inherit lib;};
  buttonsForDeviceSubmodule = import ./buttonsForDeviceSubmodule.nix {inherit lib devicesConfig;};
in
  # ----- DEVICE SUB-MODULE -----
  {name, ...}: {
    options = {
      enable = mkDisableOption "this device";

      name = mkOption {
        type = str;
        example = "MX Master 3";
        description = ''
          This is a required string field that defines the name of the device.
          To get the name of the device, launch logid with the device connected
          and it should print out a message with the device name.
          (e.g. `name: "MX Master";`)

          This is automatically set as the name of the attribute set that
          defines this device.
        '';
      };

      dpi = mkOption {
        type = int;
        default = 1000;
        example = 1200;
        description = ''
          Sets the DPI for a mouse that supports it.
        '';
      };

      smartShift = mkOption {
        type = smartShiftSubmodule;
        default = {};
        description = ''
          This is an optional object field that defines the SmartShift settings
          for a mouse that supports it.
        '';
      };

      highResScroll = mkOption {
        type = highResScrollSubmodule;
        default = {};
        description = ''
          This is an optional object field that defines the High Resolution
          mouse-scrolling settings for a device that supports it.
        '';
      };

      buttons = mkOption {
        type = buttonsForDeviceSubmodule name;
        default = {};
        description = ''
          This is an optional array field that defines the mappings for
          buttons.
        '';
      };
    };

    config = {
      # Set the name of the device as the same name as the attrset for the
      # device.
      name = mkForce name;
    };
  }
