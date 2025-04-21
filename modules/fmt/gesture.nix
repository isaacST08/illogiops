{illogiopsLib, ...} @ attrs: gestureConfig: let
  inherit (illogiopsLib.strings) indent capitalize capitalizeProper;

  fmtAction = import ./action.nix attrs gestureConfig.action;
in ''
  {
    direction: "${capitalizeProper gestureConfig.direction}";
    mode: "${capitalize gestureConfig.mode}";
    threshold: ${builtins.toString gestureConfig.threshold};
    action: ${indent 2 fmtAction};
  }''
