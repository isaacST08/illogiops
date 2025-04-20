{lib, ...}:
lib.types.submodule {
  options = {
    enable = lib.mkEnableOption "smart shift";

    threshold = lib.mkOption {
      type = lib.types.ints.between 1 255;
      default = 30;
      description = ''
        This is an optional integer field between 1-255 that defines the
        threshold required to change the SmartShift wheel to free-spin.
      '';
    };

    defaultThreshold = lib.mkOption {
      type = lib.types.ints.between 1 255;
      default = 30;
      description = ''
        This is an optional integer field between 1-255 that defines the
        mouse's default threshold required to change the SmartShift wheel
        to free-spin.
      '';
    };
  };
}
