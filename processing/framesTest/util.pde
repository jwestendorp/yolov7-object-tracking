String[] getDirs() {
  // we'll have a look in the data folder
  java.io.File folder = new java.io.File(dataPath("clips"));
  return sort( folder.list() );
}


String[] getFiles(String dir) {
  java.io.File folder = new java.io.File(dataPath("clips/"+dir));
  println(folder);
  String[] filenames = sort( folder.list() );

  return filenames;
}

HashMap<String, String[]> getFileNames(String dir) {

  // we'll have a look in the data folder
  java.io.File folder = new java.io.File(dataPath(dir));


  HashMap<String, String[]> hm = new HashMap<String, String[]>();

  // list the files in the data folder
  String[] filenames = sort( folder.list() );
  println(filenames);

  int i=0;
  int prevIndex=0;
  String prev =filenames[0];

  // first determine the size of the array
  for (String name : filenames) {

    String tag = name.split("-")[0];
    boolean  isLast=(i==filenames.length -1);

    if ( (! prev.equals(tag)) || isLast ) {

      if (isLast) i++;

      hm.put(prev, new String[i-prevIndex]);
      prevIndex=i;
      prev = tag;
    }

    i++;
  }

  //then fill the array
  prev="";
  i=0;
  for (String name : filenames) {

    String tag = name.split("-")[0];

    if (prev.length()<1) {
      prev = tag;
    } else if (! prev.equals(tag)) {
      prev = tag;
      i=0;
    }

    String[] arr = hm.get(tag);

    arr[i]=name;
    hm.put(tag, arr);
    i++;
  }


  return hm;
}
