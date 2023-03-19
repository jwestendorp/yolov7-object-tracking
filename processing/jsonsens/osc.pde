/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage msg) {
  /* print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());

  String adress = msg.addrPattern();

  if (msg.checkAddrPattern("/index")==true) {
    println("new index: "   );

    int i=msg.get(0).intValue();
    index = videoMap[i];

    println(str(i) +" ->" + index );
  }


  if (msg.checkAddrPattern("/frameRate")==true) {
    println("new fr: "   );
    int i=msg.get(0).intValue();
    println(str(i) );
  }
  
    if (msg.checkAddrPattern("/scale")==true) {
    println("new fr: "   );
    float i=msg.get(0).floatValue();
    println(str(i) );
    SCALE=i;
  }
}
