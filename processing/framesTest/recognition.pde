
class Recognition {
  int x, y, w, h;
  int currentFrame =0;
  String[] frames;
  String dir;




  Recognition(String d) {
    dir =d;
    frames = getFiles(dir);


    x=int(random(width));
    y=int(random(height));
    w=int(random(width));
    h=int(random(height));
  }


  void update() {
    String frame = frames[currentFrame];
    PImage img = loadImage("clips/"+dir+"/"+frame);
    image(img, x, y, w, h);
    currentFrame = (currentFrame+1)%frames.length;
  }
}
