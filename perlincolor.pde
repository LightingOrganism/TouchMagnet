class PerlinColorRenderer extends AudioRenderer {

  
// Perlin Noise Demo - Jim Bumgardner
  //dje mod
  
float kNoiseDetail = 0.001;
float r;
float speed= .01;
float ox = 400;
float oy = 400;
float cX = 0;
float cY = 0;
 
int rotations;

 PerlinColorRenderer(AudioSource source) {
    //rotations =  (int) source.sampleRate() / source.bufferSize();
  } 
 
void setup()
{
  //size(256,256);
  r = width/PI;
     
  //noiseDetail(3,.6);
  noiseDetail(2,.9);
  colorMode(HSB, 1); //setupPixelPusher();
  setcolorMode = 5;
  vFader2 = 255;
  vFader3 = 255;
  vFader5 = 55;
}
 
 
synchronized void draw()
{
  colorMode(HSB, 1);
  //ox += max(-speed,min(speed,(mouseX-width/2)*speed/r));
  //oy += max(-speed,min(speed,(mouseY-height/2)*speed/r));
  ox += max(-speed,min(speed,(cX-width/2)*speed/r));
  oy += max(-speed,min(speed,(cY-height/2)*speed/r));
 
 
  for (int y = 0; y < height; ++y)
  {
    for (int x = 0; x < width; ++x)
    {
      //change colors
      //setcolorMode
      //set(x,y,color(.1-y*.1/height,4-v,.7+v*v));
     float setcolorModeF = (float)map(setcolorMode, 0, 255, 0.08, .98);
     float setSatModeF = (float)map(vFader2, 0, 255, 0, 1);
     float setBrightModeF = (float)map(vFader3, 0, 255, 0, 1);
     float setContrastModeF = (float)map(vFader4, 0, 255, 0, .6);
     float setSpeedModeF = (float)map(vFader5, 0, 255, .00001, .0008);
     

      //float v = noise(ox+x*kNoiseDetail,oy+y*kNoiseDetail,millis()*setSpeedModeF);     
      //float v = noise(ox+x*kNoiseDetail,oy+y*kNoiseDetail,millis()*.0001);     
      float v = noise(ox+x*kNoiseDetail,oy+y*kNoiseDetail,millis()*setSpeedModeF);
      //set(x,y,color(setcolorModeF-y*.05/height,(4-v)*setSatModeF,(setContrastModeF+v*v)*setBrightModeF));    
      set(x,y,color((setcolorModeF+.1)-v,setSatModeF,(v*setContrastModeF+v)*setBrightModeF)); 
    }
  }
    colorMode(RGB,255);
 
//drawPixelPusher();
}

public void onClick(float mX, float mY) {
    cX = mX * canvasW;
    cY = mY * canvasH;
    //int oX = (int)cX;
    //int oY = (int)cY;
    //ox += max(-speed,min(speed,(cX-width/2)*speed/r));
    //oy += max(-speed,min(speed,(cY-height/2)*speed/r));
    
    //move_clouds(oX, oY, 25, .25);
  }

/*  
void move_clouds(int i, int j, int r, float delta)
  {
    ox += max(-speed,min(speed,(ox-width/2)*speed/r));
    oy += max(-speed,min(speed,(oy-height/2)*speed/r));
  //ox += max(-speed,min(speed,(ox-width/2)*speed/r));
  //oy += max(-speed,min(speed,(oy-height/2)*speed/r));
 
 
    for (int y = 0; y < height; ++y)
    {
      for (int x = 0; x < width; ++x)
      {
        float v = noise(ox+x*kNoiseDetail,oy+y*kNoiseDetail,millis()*.0002);
      //change colors
      //setcolorMode
      //set(x,y,color(.1-y*.1/height,4-v,.7+v*v)); 
        set(x,y,color(.1-y*.1/height,4-v,.3+v*v));    
      }
    }
  }*/
  

}
