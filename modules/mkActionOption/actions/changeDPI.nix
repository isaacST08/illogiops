{lib, ...}: {
  options = {
    inc = lib.mkOption {
      type = lib.types.int;
      example = 200;
      description = ''
        This is an integer array field that defines what to increase the DPI by.
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
