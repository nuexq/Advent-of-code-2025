let
  lib = import <nixpkgs/lib>;
  inherit (lib) strings range toInt lists;
  inherit (builtins)
    map filter length foldl' elemAt toString attrNames concatMap attrValues;

  input = builtins.readFile ./input.txt;

  lines = filter (s: s != "") (strings.splitString "\n" input);
  grid = map strings.stringToCharacters lines;
  height = (length grid) - 1;

  SColPos = lists.findFirstIndex (c: c == "S") null (builtins.head grid);

  simulate = foldl' (acc: row:
    let
      beams = attrNames acc.beams;

      rawBeams = concatMap (beam:
        let
          col = toInt beam;
          val = acc.beams.${toString col};
          nextCell = elemAt (elemAt grid row) col;
        in if nextCell != "^" then [{
          col = col;
          val = val;
        }] else [
          {
            col = col + 1;
            val = val;
          }
          {
            col = col - 1;
            val = val;
          }
        ]) beams;

      newCount = length rawBeams - length beams;

      mergedBeams = foldl' (m: beam:
        let key = toString beam.col;
        in m // { "${key}" = ((m.${key} or 0) + beam.val); }) { } rawBeams;

      isLastRow = row == height;
      newTimelines = if isLastRow then
        foldl' (acc: v: acc + v) 0 (attrValues mergedBeams)
      else
        acc.timeLines;

    in {
      beams = mergedBeams;
      counter = acc.counter + newCount;
      timelines = newTimelines;
    }) {
      beams = { "${toString SColPos}" = 1; };
      counter = 0;
      timelines = 0;
    } (range 1 height);

  simulation = simulate;

in {
  part1 = simulation.counter;
  part2 = simulation.timelines;
}
