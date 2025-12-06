let
  lib = import <nixpkgs/lib>;
  inherit (lib) count strings any foldl' sort init max;
  inherit (builtins) map filter elemAt fromJSON;

  input = ''
    10-14
    3-5
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

  ranges = map (r:
    let p = strings.splitString "-" r;
    in [ (fromJSON (elemAt p 0)) (fromJSON (elemAt p 1)) ])
    (elemAt cleanedLines 0);
  avaible_ingredient = elemAt cleanedLines 1;

  sorted = sort (a: b: (elemAt a 0) < (elemAt b 0)) ranges;
  merged = foldl' (acc: curr:
    let
      last = lib.last acc;
      currFrom = elemAt curr 0;
      currTo = elemAt curr 1;
      lastTo = if acc == [ ] then -999 else elemAt last 1;
    in if acc == [ ] || lastTo + 1 < currFrom then
      acc ++ [ curr ]
    else
      init acc ++ [[ (elemAt last 0) (max lastTo currTo) ]]) [ ] sorted;

  part1 = count (x: x) (map (ing:
    let
      avaible = any (range:
        if ((elemAt range 0) <= (fromJSON ing) && (elemAt range 1)
          >= (fromJSON ing)) then
          true
        else
          false) merged;
    in avaible) avaible_ingredient);

  part2 =
    let total = foldl' (sum: r: sum + (elemAt r 1) - (elemAt r 0) + 1) 0 merged;
    in total;
in { inherit part1 part2; }

