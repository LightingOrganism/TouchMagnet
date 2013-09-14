//build a map of ledPos[logical led positions] = map of led positions on canvas

        

void mapper() {

  int internalX = 0;
  int internalY = 0;



  //  hardcode examples  

  int ledStripNo = 0;
  for (int i = 5; i < canvasH; i+=(canvasH)/ledsH) {

    internalX = i;
    internalY = 5;//starting point on canvas

    for (int x = 0; x < ledsW; x++) {//start and number of pixels on strip
      //v strip #
      ledPos[xyPixels(x, ledStripNo, ledsW)] = xyPixels(internalX, internalY, canvasW);
      //internalX++;//direction
      internalX++;
    }
    ledStripNo++;
  }

 internalX = 1;
  internalY = 10;//starting point on canvas

  for (int x = 0; x < ledsW; x++) {//start and number of pixels on strip
    //v strip #
    ledPos[xyPixels(x, 0, ledsW)] = xyPixels(internalX, internalY, canvasW);
    //internalX++;//direction
    internalX++;
  }

  internalX = 1;
  internalY = 15;//starting point on canvas

  for (int x = 0; x < ledsW; x++) {//start and number of pixels on strip
    //v strip #
    ledPos[xyPixels(x, 1, ledsW)] = xyPixels(internalX, internalY, canvasW);
    //internalX++;//direction
    internalX++;
  }
 
  internalX = 1;
  internalY = 20;//starting point on canvas

  for (int x = 115; x < ledsW; x++) {//start and number of pixels on strip
    //v strip #
    ledPos[xyPixels(x, 2, ledsW)] = xyPixels(internalX, internalY, canvasW);
    //internalX++;//direction
    internalX++;
  }

  internalX = 1;
  internalY = 25;//starting point on canvas

  for (int x = 0; x < ledsW; x++) {//start and number of pixels on strip
    //v strip #
    ledPos[xyPixels(x, 3, ledsW)] = xyPixels(internalX, internalY, canvasW);
    //internalX++;//direction
    internalX++;
  }

}






int xyPixels(int x, int y, int yScale) {
  return(x+(y*yScale));
}

int xPixels(int pxN, int yScale) {
  return(pxN % yScale);
}

int yPixels(int pxN, int yScale) {
  return(pxN / yScale);
}

void setupPixelPusher() {
  ledPos = new int[ledsW*ledsH]; //create array of positions of leds on canvas
  mapper();
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  background(0);
}

void drawPixelPusher() {
  loadPixels();

 // Pixel blackP = new Pixel((byte)0, (byte)0, (byte)0);

  if (testObserver.hasStrips) {
    registry.startPushing();
     List<Strip> strips = registry.getStrips( );
 //   List<Strip> strips1 = registry.getStrips(1);
 //   strips1.addAll(registry.getStrips(2));  
 //   strips1.addAll(registry.getStrips(3));  
    //List<Strip> strips2 = registry.getStrips(2);      

    colorMode(HSB, 255);

    for (int y = 0; y < ledsH; y++) {     
      for (int x = 0; x < ledsW; x++) {


        thisLedPos = ledPos[xyPixels(x, y, ledsW)];
        
        //  int lX = xPixels(thisLedPos, ledsW);
        //  int lY = yPixels(thisLedPos, ledsW);
        //   pixels[xyPixels(x,y,canvasW)] = color(r, g, b);
        color c = pixels[thisLedPos];
        
        
       /* 
        c = color(hue(c), saturation(c), brightness(c) - dimmer1); 
        
        if (y >= 0 && y <= 23) //bookshelves
          c = color(hue(c), saturation(c), brightness(c) - dimmer2); 
        
        if (y >= 24 && y <= 38) //glass shelves
          c = color(hue(c), saturation(c), brightness(c) - dimmer3); 
        
        if (y >= 48 && y <= 53) //banquettes
          c = color(hue(c), saturation(c), brightness(c) - dimmer4);
   
        if (y >= 54  && y <= 71)  //soffit
          c = color(hue(c), saturation(c), brightness(c) - dimmer6);
          
        if ((y >= 72 && y <= 78) || y == 83)  //vip shelves, soffit
          c = color(hue(c), saturation(c), brightness(c) - dimmer5);
        
        if (y >= 80 && y <= 88)  //vip bar
          c = color(hue(c), saturation(c), brightness(c) - dimmer5);
         */ 
        
        Pixel p = new Pixel((byte)red(c), (byte)green(c), (byte)blue(c));
        if (y < strips.size()) {
        //if (y < strips1.size() && y!=34) {
        //if (y < strips1.size() && y==65) {
          strips.get(y).setPixel(p, x);
        }

        //if (y < strips2.size()) {
        //  strips2.get(y).setPixel(blackP, x);
        //}
        
        
        



      }
    }
    
  }
}

