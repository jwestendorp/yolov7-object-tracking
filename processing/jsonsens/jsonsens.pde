JSONObject json;
String index = "_START";


void setup() {

  json = loadJSONObject("chain.json").getJSONObject("chain");
}

String nextIndex() {

  JSONObject links = json.getJSONObject(index).getJSONObject("links");
  int count = json.getJSONObject(index).getInt("count");

  String[] keys; //https://forum.processing.org/two/discussion/5344/how-can-i-access-a-jsonobject-keys-set.html

  // the keys of all the links for this index
  keys = (String[]) links.keys()
    .toArray(new String[links.size()]);

  float luckyNr = random(0.0, 1.0);
  float accum =0.0;
  println(str(luckyNr));

  for (int i=0; i<keys.length; i++) {

    int value = links.getInt(keys[i]);

    float prob = float(value) / float(count);
    accum += prob;


    if (accum >= luckyNr) {
      print(index + "----> " );

      println(index + ", " + ", " + str(accum)+ ", " + str(luckyNr));
      return index = str(keys[i]);
    }
  }
}


void draw() {

  if ( index.equals("_END") ) {
    println("DONE!");
    return;
  }
  
  index = nextIndex();
}
