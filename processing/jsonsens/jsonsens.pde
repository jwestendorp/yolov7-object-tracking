import processing.video.*;

import oscP5.*;
import netP5.*;
import spout.*;

OscP5 oscP5;
NetAddress myRemoteLocation;



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

int FRAMERATE = 1;
float SCALE =1;


void keyReleased() {
  if (key == 's' || key=='S') {
    done=true;
  }
}

Spout spout;
void setup() {

  oscP5 = new OscP5(this, 12000);
  spout = new Spout(this);
  spout.createSender("processing");

  chain = loadJSONObject("chain-final.json").getJSONObject("chain");
  stats = loadJSONObject("stats-final.json");
  masks = loadJSONObject("masks-braindead.json");

  img = loadImage("test.jpg");
  size(576, 1024, P2D);

  fileNamesMap = getFileNames(clipDir);
  JSONObject json = getJsonFromMap(fileNamesMap);
  saveJSONObject(json, "data/new.json");
  colorMode(RGB, 255, 255, 255, 255) ;

}





void draw() {
  
  frameRate(FRAMERATE);

  if (index.equals("_START"))return;

  if (done) {
    //stopRec();
    background(0, 0, 0);
    done=false;
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
  spout.sendTexture();
  //if (!done )rec();
}
