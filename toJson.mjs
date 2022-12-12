import { readFileSync, writeFileSync } from "fs";
import chainJson from "./chain.json" assert { type: "json" };

const txtFile = "chain.txt";

if (chainJson.files.includes(txtFile))
  console.warn("already includes, ", txtFile);
else main();

function main() {
  var string = readFileSync(txtFile, "utf8");
  let lines = string.split("\n");

  let chain = chainJson.chain;

  let previous = "_START";

  lines.forEach((line, i) => {
    // let labels =line.split(',')
    //   let index = previous;

    if (!chain[previous]) chain[previous] = { links: {}, count: 0 };
    if (!chain[previous].links[line]) chain[previous].links[line] = 0;

    let val = chain[previous].links[line];
    chain[previous].links[line] = val + 1;
    //   if (!obj[previous].count) obj[previous].count = 0;
    chain[previous].count += 1;

    previous = line;
  });

  console.log(chain);

  let obj = {
    files: [...chainJson.files, txtFile],
    chain,
  };

  // Object.values(obj).forEach((val) => console.log(val));

  let data = JSON.stringify(obj);
  writeFileSync("chain.json", data);
}
