let merge = {};
let files = [];

for await (const { name } of Deno.readDir("./markov/stats-braindead")) {
  console.log(name);
  let json = JSON.parse(
    await Deno.readTextFile(`./markov/stats-braindead/${name}`)
  );
  Object.entries(json).forEach(([key, values]) => {
    merge[key] = merge[key] ? [...merge[key], ...values] : values;
  });
}

try {
  await Deno.writeTextFile(
    `./markov/stats-braindead.json`,
    // JSON.stringify({ files, chain: merge })
    JSON.stringify({ ...merge })
  );
} catch (e) {
  console.log(e);
}
