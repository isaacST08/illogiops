{lib, ...}: {
  options = {
    dpis = lib.mkOption {
      type = with lib.types; listOf int;
      default = [];
      example = [
        800
        1000
        1200
      ];
      description = ''
        This is a mandatory integer array field that defines what DPIs to cycle
        through.
      '';
    };

    sensor = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = ''
        This is an optional field that will determine what sensor the DPI will
        switch on. This value defaults to 0. In almost all cases, this does not
        need to be used.
      '';
    };
  };
}
