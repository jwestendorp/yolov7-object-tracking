let str = "";
for await (const { name } of Deno.readDir("./sourceVideos/vj-tophu")) {
  // if (name.includes("high"))
  console.log(`python crop-ffmpeg.py --source "${name}"`);
  // console.log(
  //   `python crop-ffmpeg.py --source "./sourceVideos/vj-tophu/${name}"`
  // );
  str += `python crop-ffmpeg.py --source "./sourceVideos/vj-tophu/${name}" ;`;
}

// console.log(str);
