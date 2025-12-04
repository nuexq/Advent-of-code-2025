const input = `
11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
1698522-1698528,446443-446449,38593856-38593862,565653-565659,
824824821-824824827,2121212118-2121212124
`;

const real_input: [string, string][] = input
  .trim()
  .split(",")
  .map((id) => id.trim().split("-") as [string, string]);

let part1Total = 0;
let part2Total = 0;

// Part 1
function partOne(range: [string, string]): number | null {
  let minLen = range[0].length;
  if (
    minLen % 2 !== 0 &&
    10 ** minLen > Number(range[1])
  ) return null;
  if (minLen % 2 !== 0) {
    range[0] = (10 ** range[0].length).toString();
    minLen = range[0].length;
  }
  let result: number[] = [];

  let halfLen = minLen / 2;
  let multiplier = 10 ** halfLen + 1;

  let xMin = Math.ceil(Number(range[0]) / multiplier);
  let xMax = Math.floor(Number(range[1]) / multiplier);

  xMin = Math.max(xMin, 10 ** (halfLen - 1));
  xMax = Math.min(xMax, 10 ** halfLen - 1);

  for (let x = xMin; x <= xMax; x++) {
    let candidate = x * multiplier;
    result.push(candidate);
  }
  return result.reduce((a, b) => a + b, 0);
}

// Part 2
function partTwo(range: [string, string]): number {
  let minLen = range[0].length;
  let maxLen = range[1].length;
  let result = new Set<number>();
  
  for (let totalLen = minLen; totalLen <= maxLen; totalLen++) {
    for (let i = 2; i <= totalLen; i++) {
      let d = totalLen / i;
      if (!Number.isInteger(d)) continue;

      let multiplier = (10 ** (i * d) - 1) / (10 ** d - 1);

      let xMin = Math.ceil(Number(range[0]) / multiplier);
      let xMax = Math.floor(Number(range[1]) / multiplier);

      xMin = Math.max(xMin, 10 ** (d - 1));
      xMax = Math.min(xMax, 10 ** d - 1);

      for (let x = xMin; x <= xMax; x++) {
        result.add(x * multiplier);
      }
    }
  }
  return [...result].reduce((a, b) => a + b, 0);
}

real_input.forEach(([a, b]) => {
  const p1 = partOne([a, b]);
  if (p1 !== null) {
    part1Total += p1;
  }

  const p2 = partTwo([a, b]);
  part2Total += p2;
});

console.log(`Part 1: ${part1Total}`);
console.log(`Part 2: ${part2Total}`);
