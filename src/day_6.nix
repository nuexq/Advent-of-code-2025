let
  lib = import <nixpkgs/lib>;
  inherit (lib) strings foldl' init last range;
  inherit (builtins) map filter length elemAt;

  input = ''
    123 328  51 64 
     45 64  387 23 
      6 98  215 314
    *   +   *   +  
  '';
  # input = builtins.readFile ./input.txt;

  cleanedInput = filter (x: x != "") (strings.splitString "\n" input);

  numbers = map (x: filter (y: y != "") (strings.splitString " " x))
    (init cleanedInput);
  operations =
    filter (x: x != "") (strings.splitString " " (last cleanedInput));

  part1 = foldl' (sum: idx:
    let
      problem = foldl' (acc: num:
        let
          curr = strings.toInt (elemAt (elemAt numbers num) idx);
          opertation = elemAt operations idx;
        in if opertation == "+" then
          curr + acc
        else if num == 0 then
          curr * 1
        else
          curr * acc) 0 (range 0 ((length numbers) - 1));
    in problem + sum) 0 (range 0 ((length (elemAt numbers 0)) - 1));

in { inherit part1; }
