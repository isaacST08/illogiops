{lib, ...}: {
  options = {
    keys = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      description = ''
        This is a required string/integer array/list field that defines the
        keys to be pressed/released. For a list of key/button strings,
        refer to linux/input-event-codes.h. (e.g. keys: ["KEY_A",
        "KEY_B"];). Alternatively, you may use integer keycodes to define
        the keys.

        Please note that these event codes work in a US (QWERTY) keyboard
        layout. If you have a locale set that does not use this keyboard
        layout, please map it to whatever key it would be on a QWERTY
        keyboard. (e.g. "KEY_Z" on a QWERTZ layout should be "KEY_Y")
      '';
    };
  };
}
