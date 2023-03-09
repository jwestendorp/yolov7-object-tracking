
//class Recognition extends PApplet{
class Recognition {
  int x, y, w, h;
  String fileName;
  String tag;
  PImage  img;
  String[] frames;
  int currentFrame=0;

  Recognition( int x1, int x2, int y1, int y2, String iname) {
    x=x1;
    y=y1;
    w=x2-x1;
    h=y2-y1;
    tag=iname;
    
    // pick a random file
    String tag= iname.split("-")[0];
    String[] files = fileNamesMap.get(tag);

    int index= int(random(0, files.length) ) ;
 
    fileName = files[ index];
    println(tag+", "+fileName);

    frames = getFiles(clipDir + "/" + fileName);

  }

  void update() {

    String frame = frames[currentFrame];
    PImage img = loadImage(clipDir + "/" + fileName + "/" + frame);
    image(img, x, y, w, h);
    
    currentFrame = (currentFrame+1)%(frames.length-1);
    
  }
}
