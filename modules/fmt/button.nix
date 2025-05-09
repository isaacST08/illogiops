{
  lib,
  illogiopsLib,
  ...
} @ attrs: buttonConfig: let
  inherit (illogiopsLib.strings) indent;

  CIDs = import ./../CIDs.nix;

  fmtAction = import ./action.nix attrs buttonConfig.action;

  singleButtonFormat = commentText: cid: let
    comment =
      if (commentText == "")
      then ""
      else "# ${commentText}";
  in ''
    {
      cid: ${cid}; ${comment}
      action: ${indent 2 fmtAction};
    }'';
in
  if (builtins.hasAttr buttonConfig.cid CIDs)
  then
    lib.strings.concatMapStringsSep ",\n" (singleButtonFormat "${
      buttonConfig.cid
    }")
    CIDs."${buttonConfig.cid}"
  else singleButtonFormat "" buttonConfig.cid
