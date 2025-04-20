{
  lib,
  fmtObjectAttrs,
  ...
} @ attrs: deviceConfig: let
  inherit (builtins) toString;
  inherit (lib.trivial) boolToString;

  buttonFmt = import ./button.nix attrs;
in ''
  {
    name: "${deviceConfig.name}";

    dpi: ${toString deviceConfig.dpi};

    smartshift: {
      on: ${boolToString deviceConfig.smartShift.enable};
      threshold: ${toString deviceConfig.smartShift.threshold};
    };

    hiresscroll: {
      hires: ${boolToString deviceConfig.highResScroll.enable};
      invert: ${boolToString deviceConfig.highResScroll.invert};
      target: ${boolToString deviceConfig.highResScroll.target};
    };

    buttons: (
      ${fmtObjectAttrs buttonFmt deviceConfig.buttons 4}
    );
  }''
