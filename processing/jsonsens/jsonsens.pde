import processing.video.*;



String[] folders;
JSONObject chain;
JSONObject stats;
JSONObject masks;
String index = "_START";
PImage img;
ArrayList<Recognition> objects = new ArrayList<Recognition>();


HashMap<String, String[]> fileNamesMap;
boolean done = false;
String clipDir = "clips";


void keyReleased() {
  if (key == 's' || key=='S') {
    done=true;
  }
}


void setup() {

  chain = loadJSONObject("chain-toks.json").getJSONObject("chain");
  stats = loadJSONObject("stats-toks.json");
  masks = loadJSONObject("masks-braindead.json");

  img = loadImage("test.jpg");
  size(576, 1024,P2D);

  fileNamesMap = getFileNames(clipDir);
  colorMode(RGB, 255, 255, 255, 255) ; 

}


void handleListChange(String newIndex) {
  println(index + " ---> " + newIndex);

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


void draw() {

  if (done) {
    stopRec();
    background(250, 10, 0);
    return;
  }

  background(0);



  String next = nextLink();
  if ( next.equals("_END") ) {
    println("DONE!");
    done = true;
    return;
  }

  handleListChange(next);
  //println(objects.size());

  for (Recognition object : objects) {
    object.update();
  }

  index = next;
  if (!done )rec();
}
