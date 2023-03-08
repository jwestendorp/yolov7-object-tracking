let str = "";
for await (const { name } of Deno.readDir("./sourceVideos/toks2")) {
  // console.log(name);
  // if (name.includes("braindead"))
  // console.log(`python crop-ffmpeg.py --source "${name}"`);

  // let f = name.split(".mov")[0];

  // console.log(
  //   `mkdir "${f}"
  //   ffmpeg -i "${name}" "${f}/frame%04d.png" -hide_banner`
  //   // `python crop-ffmpeg.py --source "./sourceVideos/toks/${name}"`
  // );
  console.log(`python cutFrames.py --source "./sourceVideos/toks2/${name}"`);
}

// console.log(str);
