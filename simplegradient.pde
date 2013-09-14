/* By Lighting Organism */

int t=0;
int tScale = 1;
int type = 0;
int speed = 50;

boolean invert = false;

class simplegradientRenderer extends AudioRenderer {
  
  int rotations;

  simplegradientRenderer(AudioSource source) {
      //rotations =  (int) source.sampleRate() / source.bufferSize();
    }
 

  
  boolean toggle = true; 
  
  boolean invert = false;
  
  
  void setup() {
    size(canvasW, canvasH);
     colorMode(HSB, 255);
    
    //  speed = (int)map(speed,0,255,245,265);
  }
  
  void draw() {
    
    tScale = (int)map(vFader4, 0, 255, 1, 100);
    
        if (mousePressed && (mouseButton == LEFT)){
          type++;
          if (type > 1){
            type=0;
          }
        }
   switch(type){
    
     case 0: 
    for (int i=0; i<width; i++) {
      speed = (int)map(vFader5, 0, 255, 0, 10);
  
      if (invert == false) {
        t+=tScale;
  
        if (t >= speed) {
          invert = true;
        }
      }
      else {
        t-=tScale;
        if (t <= 0) {
          invert = false;
        }
      }
      //float val = map(t, width, 255, 0, 255);
      stroke(t+setcolorMode,vFader2,vFader3-t);
      line(i, 0, i, height);
    }
    break;
    
    case 1:
    for (int i=0; i<height; i++) {
      //speed = (int)map(mouseY, 0, height, 245, 265);
      speed = (int)map(vFader5, 0, 255, 0, 10);
      
      if (invert == false) {
        t+=tScale;
  
        if (t >= speed) {
          invert = true;
        }
      }
      else {
        t-=tScale;
        if (t <= 0) {
          invert = false;
        }
      }
      //float val = map(t, width, 255, 0, 255);
      stroke(setcolorMode,vFader2,t-vFader3);
      line(0, i, width, i);
    }
    break;
   }  
  }
  public void directiontoggle(float oscToggle) {
    //int mI = (int)placeholder;
    if (oscToggle == 1) {
    toggle = false;
    type++;
    if (type > 1){
            type=0;
          }
    }
    if (oscToggle == 0){
    toggle = true;
    type++;
    if (type > 1){
            type=0;
          }
    }
  }
}  

