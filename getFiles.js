let str = "";
for await (const { name } of Deno.readDir("./sourceVideos/toks")) {
  // console.log(name);
  // if (name.includes("braindead"))
  // console.log(`python crop-ffmpeg.py --source "${name}"`);
  console.log(
    `node statsJson.mjs "./runs/detect/sourceVideos/toks/${name}/"`
    // `python crop-ffmpeg.py --source "./sourceVideos/toks/${name}"`
  );
}

// console.log(str);
