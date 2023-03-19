String nextLink() {

  
  //println(index);
  //println(chain.getJSONObject(index));
  JSONObject links = chain.getJSONObject(index).getJSONObject("links");
  int count = chain.getJSONObject(index).getInt("count");

  String[] keys; //https://forum.processing.org/two/discussion/5344/how-can-i-access-a-jsonobject-keys-set.html

  // the keys of all the links for this index
  keys = (String[]) links.keys()
    .toArray(new String[links.size()]);

  float luckyNr = random(0.0, 1.0);
  float accum =0.0;

  for (int i=0; i<keys.length; i++) {

    int value = links.getInt(keys[i]);

    float prob = float(value) / float(count);
    accum += prob;


    if (accum >= luckyNr) {
      return  keys[i];
    }
  }
  println("unexpected end");
  return "_END";
}

void handleListChange(String newIndex) {
  //println(index + " ---> " + newIndex);

  IntDict from =new IntDict(); // give an empty dict when index = _START
  if (! index.equals("_START")) from= linkDict(index);
  IntDict to = linkDict(newIndex);
  IntDict diff = new IntDict();


  // diff to
  for (String k : to.keyArray()) {
    int delta ;

    if ( from.hasKey(k) ) delta = to.get(k) - from.get(k);
    else  delta = to.get(k);

    diff.set(k, delta);
  }

  // diff from
  for (String k : from.keyArray()) {
    if (! to.hasKey(k) ) {
      int delta = -from.get(k);
      diff.set(k, delta);
    }
  }

  print("From->to "); 
  println(from, to);
  print("diff");
  println(diff);

  // update the list according to the diff

  for (String object : diff.keyArray() ) {
    int delta = diff.get(object);

    for (int i =0; i<abs(delta); i++ ) {
      if (delta > 0) addItem(object);
      if (delta < 0) removeItem(object);
    }
  }
}

// will make a dict from the index string
// e.g. '4_bird'  --> {'bird': 4}
IntDict linkDict(String str) {
  IntDict dict = new IntDict();
  String[] links = splitTokens(str, ";");

  for (String s : links) {
    int value = int(splitTokens(s, "_")[0]);
    String i = splitTokens(s, "_")[1];
    dict.set(i, value);
  }

  return dict;
}


void removeItem(String name) {
  ArrayList<Integer> indices = new ArrayList<Integer>();

  for (int i=0; i<objects.size(); i++) {
    if (objects.get(i).tag.equals(name)) indices.add(i);
  }

  if ( !(indices.size() > 0) ) return;

  int randomIndex = int( random( indices.size()) );
  objects.remove(randomIndex);
}

void addItem(String name) {

  if (fileNamesMap.get(name)==null) {
    println("No files exists for tag: ", name);
    return;
  }

  JSONArray pList = stats.getJSONArray(name);
  //print("plist; ", name); 
  //println(pList);
  int randomIndex = int( random( pList.size()) );
  int[] values = JSonArray2IntArray( pList.getJSONArray(randomIndex) );

  objects.add(
    new Recognition( values[0], values[1], values[2], values[3], name)
    ) ;
}
