{lib, ...}:
lib.types.submodule {
  options = {
    enable = lib.mkEnableOption "high res scroll";
    invert = lib.mkEnableOption "invert the mouse wheel";
    target = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        This is an optional boolean field that defines whether mousewheel
        events should send as an HID++ notification or work normally (true
        for HID++ notification, false for normal usage). This option must be
        set to true to remap the scroll wheel action.
      '';
    };
  };
}
