// Run with NodeJS v20:
// node ./extractAddresses.js

const { readFileSync, writeFileSync } = require("fs");

async function main() {
  const rawAddresses = readFileSync("./rawAddresses.txt");

  let addresses = rawAddresses
    .toString()
    .match(/contract\\": \\"0x[0-9a-fA-F]{40}/g)
    .join(",")
    .match(/0x[0-9a-fA-F]{40}/g);

  addresses.sort();
  addresses = [...new Set(addresses)];

  console.log(addresses);
  writeFileSync("./filteredAddresses.txt", addresses.join(",\n"));
}

main();
