{lib, ...}: {
  options = {
    host = lib.mkOption {
      type = with lib.types;
        either ints.positive (enum [
          "next"
          "previous"
        ]);
      example = 1;
      description = ''
        This field may either be an integer representing the host number
        (one-indexed, as shown on the bottom of the mouse), "next" to go to the
        next host number, or "previous" to go to the previous host number.
        (e.g. `host = 2;` or `host = "next";`).
      '';
    };
  };
}
