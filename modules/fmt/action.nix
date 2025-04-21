{
  lib,
  illogiopsLib,
  formatOptionValue,
  fmtObjectAttrs,
  ...
} @ attrs: actionConfig: let
  # ----- INHERITANCE -----
  inherit
    (builtins)
    attrNames
    attrValues
    head
    isString
    ;
  inherit (illogiopsLib.strings) indent capitalize;

  gestureFmt = import ./gesture.nix attrs;

  # ----- FUNCTIONS -----
  formatKeyValueOptions = actionOptions:
    lib.strings.concatMapStringsSep "\n" (
      key: ''${key}: ${formatOptionValue actionOptions."${key}"};''
    ) (attrNames actionOptions);

  # ----- ACTION TYPES -----
  formatActionTypes = {
    keypress = formatKeyValueOptions;
    toggleSmartShift = formatKeyValueOptions;
    toggleHiresScroll = formatKeyValueOptions;
    cycleDPI = formatKeyValueOptions;
    changeDPI = formatKeyValueOptions;
    changeHost = formatKeyValueOptions;

    gestures = actionOptions: ''
      gestures: (
        ${fmtObjectAttrs gestureFmt actionOptions.gestures 2}
      )'';
  };

  formatActionType = action:
    if (builtins.hasAttr "${action.type}" formatActionTypes)
    then formatActionTypes."${action.type}" action.options
    else "";

  firstAttrsValue = attrs: head (attrValues attrs);

  # ----- MAIN -----

  actionType = capitalize (
    if isString actionConfig
    then actionConfig
    else (firstAttrsValue actionConfig).type
  );
  actionOptions =
    if isString actionConfig
    then ""
    else "\n  ${(indent 2 (formatActionType (firstAttrsValue actionConfig)))}";
in ''
  {
    type: "${actionType}";${actionOptions}
  }''
