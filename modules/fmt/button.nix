{lib, ...}: buttonConfig: let
  inherit (builtins) toString;
  inherit (lib.trivial) boolToString;
in ''
  {
    cid: "${buttonConfig.cid}";
    action: ;
  }
''
