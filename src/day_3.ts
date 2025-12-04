let input = `
987654321111111
811111111111119
234234234234278
818181911112111
`;

let banks = input.trim().split("\n");

function LargestJoltage(
  bank: string,
  depth: number,
  acc: number[] = []
): number[] {
  if (depth === 0) return acc;

  const searchLen = bank.length - depth + 1;

  const window = bank.slice(0, searchLen).split("").map(Number);

  const largest = Math.max(...window);

  const idx = window.indexOf(largest);

  return LargestJoltage(
    bank.slice(idx + 1),
    depth - 1,
    [...acc, largest]
  );
}


function solve(depth: number) {
  const sums = banks
    .map(bank => Number(LargestJoltage(bank, depth).join("")))
    .reduce((a, b) => a + b, 0);

  return sums;
}

console.log(`Part 1: ${solve(2)}`)
console.log(`Part 2: ${solve(12)}`)
