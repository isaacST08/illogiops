{lib, ...}: {
  strings = rec {
    indent = spaces: string:
      if spaces > 0
      then (indent (spaces - 1) (builtins.replaceStrings ["\n"] ["\n "] string))
      else string;

    capitalize = s: let
      firstLetter = lib.strings.concatStrings (lib.lists.take 1 (lib.strings.stringToCharacters s));
      remainingLetters = lib.strings.concatStrings (lib.lists.drop 1 (lib.strings.stringToCharacters s));
    in
      (lib.strings.toUpper firstLetter) + remainingLetters;

    capitalizeProper = s: capitalize (lib.strings.toLower s);
  };
}
