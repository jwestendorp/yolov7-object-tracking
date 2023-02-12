for await (const dir of Deno.readDir("./vj-tophu")) {
  if (!dir.name.includes("braindead")) continue;
  for await (const file of Deno.readDir(`./vj-tophu/${dir.name}`)) {
    await Deno.copyFile(
      `./vj-tophu/${dir.name}/${file.name}`,
      `./braindeadClips/${file.name}`
    );
  }
}
