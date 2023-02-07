JSONObject chain;
JSONObject stats;
JSONObject masks;
String index = "_START";
PImage img;
ArrayList<Recognition> objects = new ArrayList<Recognition>();
PApplet sketchPApplet;

HashMap<String, String[]> fileNamesMap;

void setup() {
  sketchPApplet=this;

  chain = loadJSONObject("chain-braindead.json").getJSONObject("chain");
  stats = loadJSONObject("stats-braindead.json");
  masks = loadJSONObject("masks-braindead.json");

  img = loadImage("test.jpg");
  size(1920, 1080);

  fileNamesMap = getFileNames("clips");
  colorMode(RGB, 255, 255, 255, 255) ; 

  // init
  //index = nextLink();
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


void movieEvent(Movie m) {
  m.read();

  // remove background black
  m.loadPixels();
  int numPixels = m.width * m.height;
  for (int i = 0; i < numPixels; i++) {

    color currColor = m.pixels[i];
    // Extract the red, green, and blue components of the current pixel's color
    int currR = (currColor >> 16) & 0xFF;
    int currG = (currColor >> 8) & 0xFF;
    int currB = currColor & 0xFF;


    if ( currR+currB+currG ==0 ) {
      //println("keying");
      m.pixels[i] = color(#006699, 0);
    }
  }


  m.updatePixels();
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
  JSONArray pList = stats.getJSONArray(name);
  //print("plist; ", name); 
  //println(pList);
  int randomIndex = int( random( pList.size()) );
  int[] values = JSonArray2IntArray( pList.getJSONArray(randomIndex) );

  objects.add(
    new Recognition(sketchPApplet, values[0], values[1], values[2], values[3], name)
    ) ;
}


void draw() {

  if ( index.equals("_END") ) {
    println("DONE!");
    return;
  }

  String next = nextLink();

  handleListChange(next);
  //println(objects.size());

  for (Recognition object : objects) {
    object.update();
  }

  index = next;
}
