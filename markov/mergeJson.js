let merge = {};
let files = [];

for await (const { name } of Deno.readDir("./markov/final")) {
  console.log(name);
  let json = JSON.parse(await Deno.readTextFile(`./markov/final/${name}`));
  let chain = json.chain;

  files = [...files, name];

  Object.entries(chain).forEach(([key, val]) => {
    let { links, count } = val;

    let prev = merge[key];
    console.log(prev);

    if (!prev) merge[key] = { links, count };
    else {
      let newLinks = prev.links;

      Object.entries(links).forEach(([link, i]) => {
        if (newLinks[link]) newLinks[link] += i;
        else newLinks[link] = i;
      });

      merge[key] = {
        links: newLinks,
        count: prev.count + count,
      };
    }
    // console.log(merge);
  });
}

try {
  await Deno.writeTextFile(
    `./markov/chain-toks.json`,
    JSON.stringify({ files, chain: merge })
  );
} catch (e) {
  console.log(e);
}
