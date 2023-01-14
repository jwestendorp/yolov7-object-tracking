import { readFileSync, writeFileSync } from "fs";
import fs from "fs/promises";
import path from "path";
// import chainJson from "./stats.json" assert { type: "json" };

// const dir = "./runs/detect/video.mp4/";
const dir = process.argv[2];

// if (chainJson.files.includes(txtFile))
//   console.warn("already includes, ", txtFile);
// else main();

let obj = {};

const readDirectory = async (dir) => {
  const files = await (
    await fs.readdir(dir)
  ).filter((x) => path.extname(x) === ".csv");

  // console.log(files);

  files.forEach((file) => {
    var string = readFileSync(dir + file, "utf8");
    let lines = string.split("\n");
    let firstLine = lines[0];

    let [frameNr, x1, x2, y1, y2] = firstLine.split(",").map((x) => Number(x));

    let label = file.split("-")[0];

    if (obj[label]) obj[label] = [...obj[label], [x1, x2, y1, y2]];
    else obj[label] = [[x1, x2, y1, y2]];
    console.log(file, x1, x2, y1, y2);
  });

  console.log(obj);

  let data = JSON.stringify(obj);
  let crumbs = dir.split("/");
  writeFileSync(`./markov/stats-${crumbs[crumbs.length - 2]}.json`, data);
};

readDirectory(dir);

// function main() {
//   var string = readFileSync(txtFile, "utf8");
//   let lines = [...string.split("\n").filter((x) => x.length > 0), "_END"];
//   let chain = chainJson.chain;

//   let previous = "_START";

//   lines.forEach((line, i) => {
//     if (!chain[previous]) chain[previous] = { links: {}, count: 0 };
//     if (!chain[previous].links[line]) chain[previous].links[line] = 0;

//     let val = chain[previous].links[line];
//     chain[previous].links[line] = val + 1;
//     chain[previous].count += 1;

//     previous = line;
//   });

//   let obj = {
//     files: [...chainJson.files, txtFile],
//     chain,
//   };

//   let data = JSON.stringify(obj);
//   writeFileSync("chain.json", data);
// }
