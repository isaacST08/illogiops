{
  lib,
  indent,
  capitalizeProper,
  formatOptionValue,
  fmtObjectAttrs,
  ...
} @ attrs: actionConfig: let
  # ----- INHERITANCE -----
  inherit
    (builtins)
    toString
    attrValues
    attrNames
    head
    map
    ;
  inherit (lib.strings) toLower;
  inherit (lib.trivial) boolToString;

  gestureFmt = import ./gesture.nix attrs;

  # ----- ACTION TYPES -----
  formatActionTypes = {
    keyPress = actionOptions: ''keys: ${formatOptionValue actionOptions.keys};'';
    gestures = actionOptions: ''
      gestures: (
        ${fmtObjectAttrs gestureFmt actionOptions.gestures 2}
      )'';
  };

  formatActionType = action:
    if (builtins.hasAttr "${action.type}" formatActionTypes)
    then formatActionTypes."${action.type}" action.options
    else "";

  # ----- MAIN -----
  firstActionConfig = head (attrValues actionConfig);
in
  # actionOptions = map (x: ''${toLower x}: $'') (attrNames firstActionConfig.options);
  ''
    {
      type: "${capitalizeProper firstActionConfig.type}";
      ${indent 2 (formatActionType firstActionConfig)}
    }''
