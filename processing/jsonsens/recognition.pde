import processing.video.*;

//class Recognition extends PApplet{
class Recognition {
  int x, y, w, h;
  String name;
  Movie mov;
  PImage  img;

  Recognition(PApplet ref, int ix, int iy, int iw, int ih, String iname) {
    x=ix;
    y=iy;
    w=iw;
    h=ih;
    name=iname;

    img =loadImage("test.jpg");
    mov = new Movie(ref, "bird-0.mp4");
    mov.loop();


    String tag= iname.split("-")[0];
    String[] files = fileNamesMap.get(tag);
    

    String randomFile = files[ int(random(0,files.length) ) ];
        println("file: " , randomFile);
    
    
  }

  void update() {
    image(mov, x, y, w, h);
  }

  //void movieEvent(Movie m) {
  //  m.read();
  //}
}
