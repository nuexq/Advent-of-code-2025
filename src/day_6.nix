# it works
let
  lib = import <nixpkgs/lib>;
  inherit (lib) strings foldl' init last range substring stringToCharacters;
  inherit (builtins) map filter length elemAt stringLength head;

  input = ''
    123 328  51 64 
     45 64  387 23 
      6 98  215 314
    *   +   *   +  
  '';

  cleanedInput = filter (x: x != "") (strings.splitString "\n" input);

  numbers = map (x: filter (y: y != "") (strings.splitString " " x))
    (init cleanedInput);
  operations =
    filter (x: x != "") (strings.splitString " " (last cleanedInput));

  problems = map (i:
    let
      col =
        map (j: (elemAt (elemAt numbers j) i)) (range 0 ((length numbers) - 1));
    in col) (range 0 ((length (elemAt numbers 0)) - 1));

  compute = problems:
    foldl' (total: idx:
      let
        numbers = elemAt problems idx;
        operation = elemAt operations idx;

        ints = map strings.toInt numbers;

        result = if operation == "+" then
          foldl' (a: b: a + b) 0 ints
        else
          foldl' (a: b: a * b) 1 ints;
      in total + result) 0 (range 0 (length problems - 1));

  paddedProblems = foldl' (acc: problem:
    let
      start = if acc == [ ] then
        0
      else
        (foldl' (sum: col: sum + stringLength (head col)) 0 acc) + (length acc);

      width =
        foldl' (m: s: if stringLength s > m then stringLength s else m)
        0 problem;

      col = map (row: substring start width row) (init cleanedInput);
    in acc ++ [ col ]) [ ] problems;

  part2Problems = map (col:
    let
      new = map (i:
        foldl' (acc: j:
          let colElemnt = elemAt (stringToCharacters (elemAt col j)) i;
          in if acc == "" then colElemnt else acc + colElemnt) ""
        (range 0 ((length col) - 1))) (range 0 ((stringLength (head col)) - 1));
    in new) paddedProblems;

  part1 = compute paddedProblems;
  part2 = compute part2Problems;

in { inherit part1 part2; }
