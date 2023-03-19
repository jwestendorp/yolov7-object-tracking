
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

    int sw =int(float(w)*SCALE);
    int sh = int(float(h)*SCALE);
    image(img, constrain( x-(sw/2), -(sw/2), width+(sw/2) ), constrain( y-(sh/2), -(sh/2), height+(sh/2) ), sw, sh);

    currentFrame = (currentFrame+1)%(frames.length-1);
  }
}
