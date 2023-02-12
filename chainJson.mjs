import { readFileSync, writeFileSync } from "fs";
// import chainJson from "./markov/braindead/chain.json" assert { type: "json" };
// import { argv } from "process";

console.log(process.argv);

// const txtFile = "./runs/detect/vj-tophu/braindead-57.mp4/chain.txt";
const txtFile = process.argv[2];

// if (chainJson.files.includes(txtFile))
//   console.warn("already includes, ", txtFile);
// else main();

function main() {
  var string = readFileSync(txtFile, "utf8");
  let lines = [...string.split("\n").filter((x) => x.length > 0), "_END"];
  // let chain = chainJson.chain;
  let chain = {};
  let frameCount = 0;
  // let detectionCount = 0;
  let objects = {};

  let previous = "_START";

  lines.forEach((line, i) => {
    line
      .split(";")
      .filter((x) => x.length > 0 && x !== "_END")
      .forEach((rec) => {
        let split = rec.split("_");
        let count = parseInt(split[0]);
        let obj = split[1];

        if (objects[obj]) objects[obj] = objects[obj] + count;
        else objects[obj] = count;
      });

    if (!chain[previous]) chain[previous] = { links: {}, count: 0 };
    if (!chain[previous].links[line]) chain[previous].links[line] = 0;

    let val = chain[previous].links[line];
    chain[previous].links[line] = val + 1;
    chain[previous].count += 1;

    previous = line;
    frameCount++;
    // detectionCount += line.split(";").length;
  });

  // let obj = {
  //   files: [...chainJson.files, txtFile],
  //   chain,
  // };

  // let data = JSON.stringify(obj);
  let detectionCount = Object.values(objects).reduce((a, c) => {
    console.log(a);
    return a + c;
  }, 0);

  console.log(detectionCount);
  let data = JSON.stringify({
    frameCount,
    detectionCount,
    objects,
    chain,
  });
  let crumbs = txtFile.split("/");
  writeFileSync(`./markov/chain-${crumbs[crumbs.length - 2]}.json`, data);
  console.log(data);
}

main();
