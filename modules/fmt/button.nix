{
  lib,
  indent,
  ...
} @ attrs: buttonConfig: let
  inherit (builtins) toString;
  inherit (lib.trivial) boolToString;

  fmtAction = import ./action.nix attrs buttonConfig.action;
in ''
  {
    cid: "${buttonConfig.cid}";
    action = ${indent 2 fmtAction}
  }''
