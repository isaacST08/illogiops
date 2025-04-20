{
  lib,
  indent,
  capitalize,
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
    isString
    ;
  inherit (lib.strings) toLower;
  inherit (lib.trivial) boolToString;

  gestureFmt = import ./gesture.nix attrs;

  # ----- FUNCTIONS -----
  formatKeyValueOptions = actionOptions:
    lib.strings.concatMapStringsSep "\n" (
      key: ''${key}: ${formatOptionValue actionOptions."${key}"};''
    ) (attrNames actionOptions);

  # ----- ACTION TYPES -----
  formatActionTypes = {
    # keyPress = actionOptions: ''keys: ${formatOptionValue actionOptions.keys};'';
    # toggleSmartShift = actionOptions: "";
    # toggleHiresScroll = actionOptions: "";
    # cycleDPI = actionOptions: ''
    #   dpis: ${formatOptionValue actionOptions.dpis};
    #   sensor: ${formatOptionValue actionOptions.sensor};
    #   '';
    # changeDPI = actionOptions: ''
    #   inc: ${formatOptionValue actionOptions.dpis};
    #   sensor: ${formatOptionValue actionOptions.sensor};
    #   '';
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

  optionalStringMap = f: s:
    if isString s
    then s
    else (f s);

  # ----- MAIN -----

  actionType = capitalize (
    if isString actionConfig
    then actionConfig
    else (firstAttrsValue actionConfig).type
  );
  # actionType = optionalStringMap (x: (firstAttrsValue x).type) actionConfig;
  actionOptions =
    if isString actionConfig
    then ""
    else "\n  ${(indent 2 (formatActionType (firstAttrsValue actionConfig)))}";
in
  # actionOptions = optionalStringMap (x: "\n${(indent 2 (formatActionType (firstAttrsValue x)))}") actionConfig
  # actionOptions = map (x: ''${toLower x}: $'') (attrNames firstActionConfig.options);
  # if (builtins.isString actionConfig)
  # then ''
  #   {
  #     type: "${capitalize actionConfig}";
  #   }
  # ''
  # else ''
  #   {
  #     type: "${capitalize firstActionConfig.type}";
  #     ${indent 2 (formatActionType firstActionConfig)}
  #   }''
  ''
    {
      type: "${actionType}";${actionOptions}
    }''
