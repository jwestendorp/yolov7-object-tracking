final String sketchname = getClass().getName();

import com.hamoid.*;
VideoExport videoExport;

void rec() {
  if (frameCount == 1) {
    int s = second();  // Values from 0 - 59
    int m = minute();  // Values from 0 - 59
    int h = hour(); 
    int d = day(); 
    int month = month(); 
    String date = str(d)+ "-" + str(month)+ " " + str(h) + "-" + str(m) + "-" + str(s) ;
    println(date);
    videoExport = new VideoExport(this, "/render/"+date+".mov");
    videoExport.setFrameRate(30);  
    videoExport.startMovie();
  }
  videoExport.saveFrame();
}

void stopRec() {
  videoExport.endMovie();
  exit();
}
