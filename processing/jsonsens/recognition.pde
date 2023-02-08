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

    print(str(files.length));

    int index= int(random(0, files.length) ) ;
    //println(index);

    fileName = files[ index];
    println("file: ", fileName);
    mov = new Movie(ref, "clips/"+fileName);
    mov.loop();
  }

  void update() {
    
    //manually looping............................
    if( is_movie_finished(mov) ) mov.jump(0);

    if (mov.available()) {
      mov.read();
    }else{
    println("No frame available: " ,fileName);
    }
      //if (true) {


      String fileBase = fileName.split(".mp4")[0];
      JSONArray coordsList = masks.getJSONArray(fileBase);
      
      if (coordsList ==null){
        println("NO MASK IN THE DATABASE! ", fileBase);
      return;
      }
      
      //println("jo", mov, fileBase, coordsList);
      //println(mov.time(), mov.duration(), coordsList.size());
      int frameIndex = int (  (  (mov.time()%mov.duration())  / mov.duration()) *coordsList.size() );
      //println(fileName, "idnex; ", str(frameIndex));
      int[] coords = JSonArray2IntArray( coordsList.getJSONArray(frameIndex) );

      int x1, x2, y1, y2;
      x1= coords[1];  
      x2= coords[2];  
      y1= coords[3];  
      y2= coords[4];

      //mov.loadPixels();
      int[] maskArray =new int[mov.width* mov.height];
      //int[] maskArray =new int[mov.pixels.length];


      for (int x=0; x<mov.width; x++) {
        for (int y=0; y<mov.height; y++) {

          int i = x + y*mov.width;
          if (x < x1  || y < y1 || x > x2 || y > y2 ) maskArray[i] = 0;
          else maskArray[i] = 255;
          //maskArray[i] = int(random(0, 255));
        }
      }



      image(mov, x, y, w, h);
      //image(mov, x, y, mov.width, mov.height);

  }
}
