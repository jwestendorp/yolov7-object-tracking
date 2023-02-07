let path =
  "C:/Users/jonix/PycharmProjects/yolov7-object-tracking/crop/sourceVideos/vj-tophu";
for await (const { name, isDirectory, isFile } of Deno.readDir(path)) {
  if (isDirectory) {
    for await (const file of Deno.readDir(`${path}/${name}`)) {
      // console.log(`${path}/${name}`);
      if (file.isFile) {
        console.log(file.name);
        await Deno.copyFile(
          `${path}/${name}/${file.name}`,
          `C:/Users/jonix/PycharmProjects/yolov7-object-tracking/crop/allVideos/${file.name}`
        );
      }
    }
  }
}

// console.log(str);
