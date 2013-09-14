/* 
dmxP512 
http://motscousus.com/stuff/2011-01_dmxP512
*/
import dmxP512.*;
import processing.serial.*;

DmxP512 dmxOutput;
int universeSize=128;

boolean LANBOX=false;
String LANBOX_IP="192.168.1.77";

boolean DMXPRO=true;
String DMXPRO_PORT="/dev/tty.usbserial-ENVWI7YA";//case matters ! on windows port must be upper cased.
//String DMXPRO_PORT="/dev/ttyUSB0";//case matters ! on windows port must be upper cased.
int DMXPRO_BAUDRATE=115000;

void setupDMX() {


  dmxOutput=new DmxP512(this, universeSize, false);

  if (LANBOX) {
    dmxOutput.setupLanbox(LANBOX_IP);
  }

  if (DMXPRO) {
    dmxOutput.setupDmxPro(DMXPRO_PORT, DMXPRO_BAUDRATE);
  }

  /*wrgb
   for (int d=1; d<200; d+=4){
   
   dmxOutput.set(d,255);
   }
   */
dmxPos = new int[dmxAddr*dmxUniv];
  //starting dmx address, dmx universe, xpos, ypos
//  dmxPos[1] = xyPixels(10, 10, canvasW);

  dmxPos[xyPixels(1, 1, dmxUniv)] = xyPixels(10, 10, canvasW);
  dmxPos[xyPixels(4, 1, dmxUniv)] = xyPixels(10, 50, canvasW);
  dmxPos[xyPixels(7, 1, dmxUniv)] = xyPixels(10, 90, canvasW);
}

void drawDMX() {
  loadPixels();
  //    colorMode(HSB, 255);

  for (int y = 1; y < dmxAddr+1; y+=3) {     
    for (int x = 1; x < dmxUniv+1; x++) {
      thisDmxPos = ledPos[xyPixels(x, y, dmxUniv)];
      color c = pixels[thisDmxPos];          
      dmxOutput.set(y, (int)red(c));
      dmxOutput.set(y+1, (int)green(c));
      dmxOutput.set(y+2, (int)blue(c));
    }
  }
/*
      color c = pixels[1];          
      Pixel p = new Pixel((byte)red(c), (byte)green(c), (byte)blue(c));
      dmxOutput.set(0+1, (int)red(c));
      dmxOutput.set(0+2, (int)green(c));
      dmxOutput.set(0+3, (int)blue(c));
*/
}


