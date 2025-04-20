{
  buttonsConfig,
  lib,
  ...
}: let
  # ----- INHERITANCE -----
  inherit (lib) mkOption;
  inherit (lib.modules) mkForce;
  inherit (lib.types) str;

  # ----- FUNCTIONS -----
  mkActionOption = import ./../mkActionOption;
in
  {name, ...}: let
    cid = name; # The name of the calling attrset is the cid for the button.
    actionConfig = buttonsConfig."${cid}".action;
  in {
    options = {
      cid = mkOption {
        type = str;
        example = "0xc4";
        description = ''
          This is a required integer field that defines the Control ID of the
          button that is being remapped.

          This option is automatically set to the value of the attribute set
          that contains these options.
        '';
      };

      action = mkActionOption {
        inherit lib actionConfig;
        description = ''
          This is a required object field that defines the new action of the
          button.
        '';
      };
    };

    config = {
      cid = mkForce cid;
    };
  }
