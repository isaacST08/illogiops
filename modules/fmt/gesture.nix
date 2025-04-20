{
  lib,
  capitalize,
  capitalizeProper,
  indent,
  ...
} @ attrs: gestureConfig: let
  fmtAction = import ./action.nix attrs gestureConfig.action;
in ''
  {
    direction: "${capitalizeProper gestureConfig.direction}";
    mode: "${capitalize gestureConfig.mode}";
    threshold: ${builtins.toString gestureConfig.threshold};
    action = ${indent 2 fmtAction}
  }''
