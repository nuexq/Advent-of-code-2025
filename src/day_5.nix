let
  lib = import <nixpkgs/lib>;
  inherit (lib) count strings any range unique;
  inherit (builtins) map filter elemAt fromJSON length concatMap;

  input = ''
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
  '';

  cleanedLines = map (line: filter (s: s != "") (strings.splitString "\n" line))
    (lib.strings.splitString "\n\n" input);

  ranges = elemAt cleanedLines 0;
  avaible_ingredient = elemAt cleanedLines 1;

  part1 = count (x: x) (map (ing:
    let
      avaible = any (range:
        let parts = strings.splitString "-" range;
        in if ((fromJSON (elemAt parts 0)) <= (fromJSON ing)
          && (fromJSON (elemAt parts 1)) >= (fromJSON ing)) then
          true
        else
          false) ranges;
    in avaible) avaible_ingredient);

  part2 = length (unique (concatMap (r:
    let
      parts = strings.splitString "-" r;
      from = fromJSON (elemAt parts 0);
      to = fromJSON (elemAt parts 1);
    in range from to) ranges));

in { inherit part1 part2; }

