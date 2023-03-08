// https://stackoverflow.com/questions/20068852/how-to-cast-jsonarray-to-int-array
public static int[] JSonArray2IntArray(JSONArray jsonArray) {
  int[] intArray = new int[jsonArray.size()];
  for (int i = 0; i < intArray.length; ++i) {
    intArray[i] = jsonArray.getInt(i);
  }
  return intArray;
}


public static ArrayList getKeys(HashMap map) {
  return new ArrayList(map.keySet());
}

String[] getDirs(String dir) {
  // we'll have a look in the data folder
  java.io.File folder = new java.io.File(dataPath(dir));
  return sort( folder.list() );
}

String[] getFiles(String dir) {
  java.io.File folder = new java.io.File(dataPath(dir));
  println(folder);
  String[] filenames = sort( folder.list() );

  return filenames;
}


// https://forum.processing.org/one/topic/listing-files-in-a-folder.html
HashMap<String, String[]> getFileNames(String dir) {

  // we'll have a look in the data folder
  java.io.File folder = new java.io.File(dataPath(dir));

  HashMap<String, String[]> hm = new HashMap<String, String[]>();

  // list the files in the data folder
  String[] filenames = sort( folder.list() );
  //println(filenames);

  int i=0;
  int prevIndex=0;
  //String prev =filenames[0].split("-")[0];
  String prev ="";

  // first determine the size of the array
  for (String name : filenames) {

    String tag = name.split("-")[0];
    //boolean  isLast=(i==filenames.length -1);
    //print(tag);


    //if ( (! prev.equals(tag))  ) {

    //if (isLast) i++;

    hm.put(tag, new String[i-prevIndex+1]);
    if ( (! prev.equals(tag))  ) prevIndex=i;
    prev = tag;
    //}

    i++;
  }



  //then fill the array
  prev="";
  i=0;
  for (String name : filenames) {

    String tag = name.split("-")[0];
    //println(tag);

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

// https://github.com/processing/processing-video/issues/182
boolean is_movie_finished(Movie m) {
  return m.duration() - m.time() < 0.05;
}
