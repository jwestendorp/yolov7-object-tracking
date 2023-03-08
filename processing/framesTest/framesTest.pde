

//HashMap<String, String[]> fileNamesMap;
String[] folders;
ArrayList<Recognition> objects = new ArrayList<Recognition>();

void setup() {
  folders = getDirs();
  size(576, 1024, P2D);
}

void draw() {
  float r =random(20);

  if (r<1) {
    String rFolder = folders[ int( random(folders.length) ) ];
    println(rFolder);

    objects.add(
      new Recognition(rFolder)
      ) ;

    println(objects.size());
  }



  for (Recognition object : objects) {
    object.update();
  }
}
