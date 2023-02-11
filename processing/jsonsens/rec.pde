final String sketchname = getClass().getName();

import com.hamoid.*;
VideoExport videoExport;

void rec() {
  if (frameCount == 1) {
    videoExport = new VideoExport(this, "/render/"+sketchname+"2"+".mov");
    videoExport.setFrameRate(30);  
    videoExport.startMovie();
  }
  videoExport.saveFrame();
}

void stopRec() {
  videoExport.endMovie();
  exit();
}
