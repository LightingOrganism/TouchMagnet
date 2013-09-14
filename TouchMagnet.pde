//TouchMagnet alpha1.00 by Lighting Organism 2013 lightingorganism.com
//Dustin Edwards dustin@lightingorganism.com
//Dan Cote dan@lightingorganism.com

    /*
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    */

/*
Thank you to Heroic Robotics heroicrobotics.com/
for the PixelPusher hardware, protocols, and library.
And thank you to openprocessing.org and contributors.
*/

import ddf.minim.*;

import javax.swing.JColorChooser;
import java.awt.Color; 

import hypermedia.net.*;

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;

import processing.core.*;
import java.util.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

DeviceRegistry registry;

TestObserver testObserver;

boolean dmxEnable = false;
boolean pixEnable = true;


int ledsW = 48 * 5;
int ledsH = 32;
int dmxAddr = 100;
int dmxUniv = 1;
int[] ledPos;
int[] dmxPos;
int thisLedPos;
int thisDmxPos;

int canvasW = 256;
int canvasH = 64;


int setcolorMode = 10;
int vFader2 = 255;
int vFader3 = 120;
int vFader4 = 128;
int vFader5 = 0;
int vFader6 = 0;
int vFader7 = 0;
int vFader8 = 0;
int dimmer1 = 0;
int dimmer2 = 0;
int dimmer3 = 0;
int dimmer4 = 0;
int dimmer5 = 0;
int dimmer6 = 0;
int dimmer7 = 0;
int dimmer8 = 0;
int dimmer9 = 0;
int dimmer10 = 0;

int faderWait = 0;

Minim minim;

AudioInput in;
AudioRenderer radar;
HeatmapRenderer heatmap;
NoiseParticlesRenderer noiseParticles;
FluidRenderer fluidje;
PerlinColorRenderer perlincolor;
NoiseFieldRenderer noisefield;
FitzhughRenderer fitzhugh;
TuringRenderer turing;
stainedglassRenderer stainedglass;
simplegradientRenderer simplegradient;
AudioRenderer[] visuals; 

int select;

void setup() {
  //size(canvasW, canvasH);
  size(canvasW, canvasH);
  frameRate(60);
  //  colorMode(HSB, 255);

  // setup player
  minim = new Minim(this);

  // get a line in from Minim, default bit depth is 16
  //in = minim.getLineIn(Minim.STEREO, 512);

  // setup renderers
  noiseParticles = new NoiseParticlesRenderer(in);
  perlincolor = new PerlinColorRenderer(in);
  //radar = new RadarRenderer(in);
  fluidje = new FluidRenderer(in);
  heatmap = new HeatmapRenderer(in);
  noisefield = new NoiseFieldRenderer(in);
  fitzhugh = new FitzhughRenderer(in);
  turing = new TuringRenderer(in);
  stainedglass = new stainedglassRenderer(in);
  simplegradient = new simplegradientRenderer(in);


  visuals = new AudioRenderer[] {
    noiseParticles, perlincolor, heatmap, fluidje, noisefield, fitzhugh, turing, stainedglass, simplegradient
  };

  // activate first renderer in list
  select = 0;
  //in.addListener(visuals[select]);
  visuals[select].setup();

  if (pixEnable == true)
    setupPixelPusher();
  if (dmxEnable == true)
    setupDMX();
  //setup oscp5
  oscP5 = new OscP5(this, 12000);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("255.255.255.255", 9000);

  /* osc plug service
   * osc messages with a specific address pattern can be automatically
   * forwarded to a specific method of an object. in this example 
   * a message with address pattern /test will be forwarded to a method
   * test(). below the method test takes 2 arguments - 2 ints. therefore each
   * message with address pattern /test and typetag ii will be forwarded to
   * the method test(int theA, int theB)
   */
  oscP5.plug(this, "oscOnClick", "/luminous/xy");
  oscP5.plug(this, "oscSketch1", "/luminous/sketch1");
  oscP5.plug(this, "oscSketch2", "/luminous/sketch2");
  oscP5.plug(this, "oscSketch3", "/luminous/sketch3");
  oscP5.plug(this, "oscSketch4", "/luminous/sketch4");
  oscP5.plug(this, "oscSketch5", "/luminous/sketch5");
  oscP5.plug(this, "oscSketch6", "/luminous/sketch6");
  oscP5.plug(this, "oscSketch7", "/luminous/sketch7");
  oscP5.plug(this, "oscSketch8", "/luminous/sketch8");
  oscP5.plug(this, "oscSketch9", "/luminous/sketch9");
  oscP5.plug(this, "oscSketch10", "/luminous/sketch10");
  oscP5.plug(this, "oscSketch11", "/luminous/sketch11");

  oscP5.plug(this, "oscEffect1", "/luminous/effect1");
  oscP5.plug(this, "oscEffect2", "/luminous/effect2");
  oscP5.plug(this, "oscEffect3", "/luminous/effect3");
  oscP5.plug(this, "oscEffect4", "/luminous/effect4");
  oscP5.plug(this, "oscEffect5", "/luminous/effect5");

  //faders
  oscP5.plug(this, "oscFader1", "/luminous/fader1");
  oscP5.plug(this, "oscFader2", "/luminous/fader2");
  oscP5.plug(this, "oscFader3", "/luminous/fader3");
  oscP5.plug(this, "oscFader4", "/luminous/fader4");
  oscP5.plug(this, "oscFader5", "/luminous/fader5");
  oscP5.plug(this, "oscFader6", "/luminous/fader6");
  oscP5.plug(this, "oscFader7", "/luminous/fader7");
  oscP5.plug(this, "oscFader8", "/luminous/fader8");

  //dimmers
  oscP5.plug(this, "oscDimmer1", "/luminous/dimmer1");
  oscP5.plug(this, "oscDimmer2", "/luminous/dimmer2");
  oscP5.plug(this, "oscDimmer3", "/luminous/dimmer3");
  oscP5.plug(this, "oscDimmer4", "/luminous/dimmer4");
  oscP5.plug(this, "oscDimmer5", "/luminous/dimmer5");
  oscP5.plug(this, "oscDimmer6", "/luminous/dimmer6");
  oscP5.plug(this, "oscDimmer7", "/luminous/dimmer7");
  oscP5.plug(this, "oscDimmer8", "/luminous/dimmer8");
  oscP5.plug(this, "oscDimmer9", "/luminous/dimmer9");
  oscP5.plug(this, "oscDimmer10", "/luminous/dimmer10");
}


void oscSketch1(float iA) {
  //in.removeListener(visuals[select]);
  select = 0;
  //in.addListener(visuals[select]);
  //visuals[select].setup();
  colorMode(HSB, 255);
}
void oscSketch2(float iA) {
  //in.removeListener(visuals[select]);
  select = 1;
  //in.addListener(visuals[select]);
  visuals[select].setup();
  //add code to prevent double tap
}
void oscSketch3(float iA) {
  //in.removeListener(visuals[select]);
  select = 2;
  //in.addListener(visuals[select]);
  visuals[select].setup();
}
void oscSketch4(float iA) {
  //in.removeListener(visuals[select]);
  select = 3;
  //in.addListener(visuals[select]);
  visuals[select].setup();
}
void oscSketch5(float iA) {
  //in.removeListener(visuals[select]);
  select = 4;
  //in.addListener(visuals[select]);
  visuals[select].setup();
}
void oscSketch6(float iA) {
  //in.removeListener(visuals[select]);
  select = 5;
  //in.addListener(visuals[select]);
  visuals[select].setup();
}
void oscSketch7(float iA) {
  //in.removeListener(visuals[select]);
  select = 6;
  //in.addListener(visuals[select]);
  visuals[select].setup();
}
void oscSketch8(float iA) {
  //in.removeListener(visuals[select]);
  select = 7;
  //in.addListener(visuals[select]);
  visuals[select].setup();
  
  colorMode(RGB);
}
void oscSketch9(float iA) {
  //in.removeListener(visuals[select]);
  select = 8;
  //in.addListener(visuals[select]);
  visuals[select].setup();
}
/*void oscSketch10(float iA) {
  //in.removeListener(visuals[select]);
  select = 9;
  //in.addListener(visuals[select]);
  visuals[select].setup();
}
void oscSketch11(float iA) {
  //in.removeListener(visuals[select]);
  select = 10;
  //in.addListener(visuals[select]);
  visuals[select].setup();
}*/

void oscOnClick(float iA, float iB) {
  if (select == 0)
    noiseParticles.onClick(iA, iB);
  if (select == 1)
    perlincolor.onClick(iA, iB);
  if (select == 2)
    heatmap.onClick(iA, iB);
  if (select == 3)
    fluidje.onClick(iA, iB);
  if (select == 4)
    noisefield.onClick(iA, iB);
  if (select == 5)
    fitzhugh.onClick(iA, iB);
    if (select == 6)
    turing.onClick(iA, iB);
    if (select == 7)
    stainedglass.onClick(iA, iB);
    //if (select == 8)
    //simplegradient.onClick(iA, iB);
}

void oscEffect1(float iA) {
  noiseParticles.clearParticles(iA);
}
void oscEffect2(float iA) {
  heatmap.heattoggle(iA);
}
void oscFader1(float faderIn) {
  setcolorMode = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscFader2(float faderIn) {
  vFader2 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscFader3(float faderIn) {
  vFader3 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscFader4(float faderIn) {
  vFader4 = (int)map(faderIn, 0, 1, 0, 255);
}  
public void oscFader5(float faderIn) {
  vFader5 = (int)map(faderIn, 0, 1, 0, 255);
}  
public void oscFader6(float faderIn) {
  vFader6 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscFader7(float faderIn) {
  vFader7 = (int)map(faderIn, 0, 1, 0, 255);
}  
public void oscFader8(float faderIn) {
  vFader8 = (int)map(faderIn, 0, 1, 0, 255);
}    

public void oscDimmer1(float faderIn) {
  dimmer1 = (int)map(faderIn, 0, 1, 0, 255);
}  
public void oscDimmer2(float faderIn) {
  dimmer2 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscDimmer3(float faderIn) {
  dimmer3 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscDimmer4(float faderIn) {
  dimmer4 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscDimmer5(float faderIn) {
  dimmer5 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscDimmer6(float faderIn) {
  dimmer6 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscDimmer7(float faderIn) {
  dimmer7 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscDimmer8(float faderIn) {
  dimmer8 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscDimmer9(float faderIn) {
  dimmer9 = (int)map(faderIn, 0, 1, 0, 255);
}
public void oscDimmer10(float faderIn) {
  dimmer10 = (int)map(faderIn, 0, 1, 0, 255);
}

void oscFaderSet() {

  if ((millis() - faderWait) > 750) {
    faderWait = millis();
    OscMessage faderOut;
    float faderOutFloat;

    faderOut = new OscMessage("/luminous/fader1");
    faderOutFloat = (float)map(setcolorMode, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader2");
    faderOutFloat = (float)map(vFader2, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader3");
    faderOutFloat = (float)map(vFader3, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader4");
    faderOutFloat = (float)map(vFader4, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader5");
    faderOutFloat = (float)map(vFader5, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader6");
    faderOutFloat = (float)map(vFader6, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader7");
    faderOutFloat = (float)map(vFader7, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/fader8");
    faderOutFloat = (float)map(vFader8, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/dimmer1");
    faderOutFloat = (float)map(dimmer1, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/dimmer2");
    faderOutFloat = (float)map(dimmer2, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/dimmer3");
    faderOutFloat = (float)map(dimmer3, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/dimmer4");
    faderOutFloat = (float)map(dimmer4, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/dimmer5");
    faderOutFloat = (float)map(dimmer5, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);

    faderOut = new OscMessage("/luminous/dimmer6");
    faderOutFloat = (float)map(dimmer6, 0, 255, 0, 1);
    faderOut.add(faderOutFloat);
    oscP5.send(faderOut, myRemoteLocation);
  }
}

void draw() {    
  oscFaderSet();
  visuals[select].draw();
  if (pixEnable == true)
    drawPixelPusher();
  if (dmxEnable == true)
    drawDMX();
}




void keyPressed() {
if (key == ' '){
  //in.removeListener(visuals[select]);
  select++;
  select %= visuals.length;
  //in.addListener(visuals[select]);
  visuals[select].setup();
}
else {
  if (select == 6)
  {
  turing.keyPressed();
  }
}
}


void stop()
{
  // always close Minim audio classes when you are done with them
  //in.close();
  minim.stop();
  super.stop();
}

void mouseClicked() {
  try {
    fluidje.mouseClicked();
    throw new NullPointerException();
  }
  catch (NullPointerException e) {
  }
}

void mouseDragged() {
  try {
    fluidje.mouseClicked();
    throw new NullPointerException();
  }
  catch (NullPointerException e) {
  }
}



/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* with theOscMessage.isPlugged() you check if the osc message has already been
   * forwarded to a plugged method. if theOscMessage.isPlugged()==true, it has already 
   * been forwared to another method in your sketch. theOscMessage.isPlugged() can 
   * be used for double posting but is not required.
   */
  if (theOscMessage.isPlugged()==false) {
    /* print the address pattern and the typetag of the received OscMessage */
    println("### received an osc message.");
    println("### addrpattern\t"+theOscMessage.addrPattern());
    println("### typetag\t"+theOscMessage.typetag());
  }
}

