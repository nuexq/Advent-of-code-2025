let
  lib = import <nixpkgs/lib>;
  elemAt = builtins.elemAt;
  inherit (lib) count;

  input = ''
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
  '';

  cleanedLines = builtins.filter (s: s != "")
    (map lib.strings.trim (lib.strings.splitString "\n" input));

  initialGrid = map (line: lib.strings.stringToCharacters line) cleanedLines;

  colsNum = builtins.length (elemAt initialGrid 0);
  rowsNum = builtins.length initialGrid;

  inBounds = r: c: r >= 0 && r < rowsNum && c >= 0 && c < colsNum;
  get = r: c: grid: if inBounds r c then elemAt (elemAt grid r) c else ".";

  solution = grid:
    let
      result = builtins.genList (r:
        builtins.genList (c:
          let
            cell = get r c grid;
            neighbors = count (x: x == "@") [
              (get (r - 1) (c - 1) grid)
              (get (r - 1) c grid)
              (get (r - 1) (c + 1) grid)
              (get r (c - 1) grid)
              (get r (c + 1) grid)
              (get (r + 1) (c - 1) grid)
              (get (r + 1) c grid)
              (get (r + 1) (c + 1) grid)
            ];
            died = cell == "@" && neighbors < 4;
            newCell = if died then "." else cell;
          in { inherit newCell died; }) colsNum) rowsNum;

      newGrid = map (row: map (x: x.newCell) row) result;

      deaths = builtins.foldl'
        (acc: row: acc + builtins.length (builtins.filter (x: x.died) row)) 0
        result;

    in { inherit newGrid deaths; };

  totalDeaths = grid:
    let step = solution grid;
    in if grid == step.newGrid then
      step.deaths
    else
      step.deaths + (totalDeaths step.newGrid);

  part1 = (solution initialGrid).deaths;
  part2 = totalDeaths initialGrid;

in { inherit part1 part2; }

