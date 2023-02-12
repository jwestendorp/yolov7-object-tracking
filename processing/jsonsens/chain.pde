String nextLink() {

  
  println(index);
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
