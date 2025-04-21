{
  config,
  lib,
  pkgs,
  ...
}: {
  # ...
  # (beginning of your configuration.nix)
  # ...

  services.illogiops = {
    enable = true;
    devices."Wireless Mouse MX Master 3" = {
      dpi = 3000;

      smartShift = {
        enable = true;
        threshold = 12;
      };

      highResScroll.enable = true;

      buttons = {
        forwardButton.action.keypress.options.keys = [
          "KEY_LEFTMETA"
          "KEY_LEFTCTRL"
          "BTN_LEFT"
        ];
        backButton.action.keypress.options.keys = [
          "KEY_LEFTMETA"
          "BTN_LEFT"
        ];
        gestureButton.action.gestures.options.gestures = {
          right.action.keypress.options.keys = [
            "KEY_LEFTMETA"
            "KEY_LEFTCTRL"
            "KEY_LEFT"
          ];
          left.action.keypress.options.keys = [
            "KEY_LEFTMETA"
            "KEY_LEFTCTRL"
            "KEY_RIGHT"
          ];
        };
        toggleSmartShiftButton.action.gestures.options.gestures = {
          none.action = "toggleSmartShift";
          up.action.changeDPI.options.inc = 200;
          down.action.changeDPI.options.inc = -200;
        };
      };
    };
  };

  # ...
  # (rest of your configuration.nix)
  # ...
}
