let str = "";
for await (const { name } of Deno.readDir("./sourceVideos/vj-tophu")) {
  // console.log(name);
  if (name.includes("braindead"))
    // console.log(`python crop-ffmpeg.py --source "${name}"`);
    console.log(
      `node statsJson.mjs "./runs/detect/sourceVideos/vj-tophu/${name}/"`
    );
}

// console.log(str);
