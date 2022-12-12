import { readFileSync, writeFileSync } from "fs";
import chainJson from "./chain.json" assert { type: "json" };

const txtFile = "./runs/detect/video.mp4/chain.txt";

if (chainJson.files.includes(txtFile))
  console.warn("already includes, ", txtFile);
else main();

function main() {
  var string = readFileSync(txtFile, "utf8");
  let lines = [...string.split("\n").filter((x) => x.length > 0), "_END"];
  let chain = chainJson.chain;

  let previous = "_START";

  lines.forEach((line, i) => {
    if (!chain[previous]) chain[previous] = { links: {}, count: 0 };
    if (!chain[previous].links[line]) chain[previous].links[line] = 0;

    let val = chain[previous].links[line];
    chain[previous].links[line] = val + 1;
    chain[previous].count += 1;

    previous = line;
  });

  let obj = {
    files: [...chainJson.files, txtFile],
    chain,
  };

  let data = JSON.stringify(obj);
  writeFileSync("chain.json", data);
}
