import processing.video.*;

//class Recognition extends PApplet{
class Recognition {
  int x, y, w, h;
  String fileName;
  String tag;
  Movie mov;
  PImage  img;

  Recognition(PApplet ref, int x1, int x2, int y1, int y2, String iname) {
    x=x1;
    y=y1;
    w=x2-x1;
    h=y2-y1;
    tag=iname;
    

    img =loadImage("test.jpg");


  // pick a random file
    String tag= iname.split("-")[0];
    String[] files = fileNamesMap.get(tag);

    //println("name", iname);
    
    //print(str(files.length));

    int index= int(random(0, files.length) ) ;
    //println(index);

    fileName = files[ index];
    println("file: ", fileName);
    mov = new Movie(ref, "clips/"+fileName);
    mov.loop();
    
    
    String fileBase = fileName.split(".mp4")[0];
    // get the crop mask
      JSONArray coordsList = masks.getJSONArray(fileBase);
      println(fileBase);
      println(coordsList);
  }

  void update() {
    image(mov, x, y, w, h);
  }

  //void movieEvent(Movie m) {
  //  m.read();
  //}
}
