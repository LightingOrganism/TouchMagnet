/* By http://www.marcinignac.com */

class NoiseParticlesRenderer extends AudioRenderer {


  int cP = color(255, 255, 255);
  Color javaColor; 

  float noiseScale = 0.005;
  float noiseZ = .8;
  int particlesDensity = 4;
  int particleMargin = 164;  
  Particle[] particles;
  int[] currFrame;
  int[] prevFrame;
  int[] tempFrame;
  int i = 0;
  boolean okToDraw = false;
  boolean drawNext = false;
  ImgProc imgProc = new ImgProc();
  int speed=2;
//  float setcolorMode = 200;

  NoiseParticlesRenderer(AudioSource source) {
    //speed =  (int) source.sampleRate() / source.bufferSize();
  }

  void setup() {
    colorMode(HSB, 255);
    currFrame = new int[width*height];
    prevFrame = new int[width*height];
    tempFrame = new int[width*height];
    //setcolorMode = 200;
    vFader3 = 255;
    for (int i=0; i<width*height; i++) {
      currFrame[i] = color(0, 0, 0);
      prevFrame[i] = color(0, 0, 0);
      tempFrame[i] = color(0, 0, 0);
      

    }



    particles = new Particle[(width+particleMargin*2)/particlesDensity*(height+particleMargin*2)/particlesDensity];
    int i = 0;
    for (int y=-particleMargin; y<height+particleMargin; y+=particlesDensity) {
      for (int x=-particleMargin; x<width+particleMargin; x+=particlesDensity) {
        if (i == particles.length) {
          println(i);
          break;
        }
        //color control - insert audio option
        //purple
        //int c = color(180+60*sin(PI*x/width), 200, 255*sin(PI*y/width));
        //candle
        int c = color(5+20*sin(PI*x/width), 255, 225*sin(PI*y/width));
        //increased saturation
        //int c = color(200+60*sin(PI*x/width), 225, 255*sin(PI*y/width));
        //int c = color(360*sin(PI*x/width), 127, 255*sin(PI*y/width));
        particles[i++] = new Particle(x, y, c);
      }
    }
  }




  synchronized void draw() {
    okToDraw = false;
    noiseZ += 2*noiseScale;

    imgProc.blur(prevFrame, tempFrame, width, height);
    imgProc.scaleBrightness(tempFrame, tempFrame, width, height, 0.2);  
    arraycopy(tempFrame, currFrame);
    for (int i=0; i<particles.length; i++) {
      particles[i].update();
      if (particles.length > i - 3)
      particles[i].draw();
    }  
    imgProc.drawPixelArray(currFrame, 0, 0, width, height);
    arraycopy(currFrame, prevFrame);

    if (drawNext)
      resetParticles();

    okToDraw = true;
    //brush

    if (mousePressed && (mouseButton == LEFT))
      onClick(mouseX, mouseY);
    if (mousePressed && (mouseButton == RIGHT)) {
    }
  }



  public void onClick(float mX, float mY) {
    float cX = mX * canvasW;
    float cY = mY * canvasH;
    int oX = (int)cX;
    int oY = (int)cY;
    onClick(oX, oY);
  }

  public void onClick(int mX, int mY) {
    int brush = 16;
    for (int y=mY - brush; y < brush + mY; y+=particlesDensity) {
      for (int x=mX - brush; x < brush + mX; x+=particlesDensity) {
        //    for(int y=-particleMargin; y<height+particleMargin; y+=particlesDensity) {
        //    for(int x=-particleMargin; x<width+particleMargin; x+=particlesDensity) {
        if (i == particles.length) {
          println(i);
          i=0;
        }
        //       int c = color(50+50*sin(PI*x/width), 127, 255*sin(PI*y/width));
        //int c = color(200*sin(PI*x/width), 227, 255*sin(PI*y/width));
        //int c = color(setcolorMode*sin(PI*x/width), 225, 255*sin(PI*y/width));
        
        //int c = color(10+20*sin(PI*x/width), 200, 255*sin(PI*y/width));
        //static color
       // int c = color(setcolorMode+20*sin(PI*x/width), 255*sin(PI*(200)/width), 255);
        //add variability
        int c = color(setcolorMode/*+20*sin(PI*x/width)*/, vFader2/**sin(PI*(y+200)/width)*/, vFader3);
        particles[i++] = new Particle(x, y, c);
        //particles[i++] = new Particle(x, y, cP);
      }
    }
  }

  class Particle {
    float x;
    float y;
    int c;
    float speed = 1;
    Particle(int x, int y, int c) {
      this.x = x;
      this.y = y;
      this.c = c;
    }
    void update() {
      float noiseVal = noise(x*noiseScale, y*noiseScale, noiseZ);
      //set direction/randomness
      float angle = noiseVal*-1.5*PI;
      float speed = (float)map(vFader5, 0, 255, .15, 10);
      x += speed * cos(angle);
      y += speed * sin(angle);

      if (x < -particleMargin) {
        x += width + 2*particleMargin;
      } 
      else if (x > width + particleMargin) {
        x -= width + 2*particleMargin;
      }

      if (y < -particleMargin) {
        y += height + 2*particleMargin;
      } 
      else if (y > height + particleMargin) {
        y -= height + 2*particleMargin;
      }
    }
    void draw() {
      if ((x >= 0) && (x < width-1) && (y >= 0) && (y < height-1)) {
        int currC = currFrame[(int)x + ((int)y)*width];
        currFrame[(int)x + ((int)y)*width] = blendColor(c, currC, ADD);
      }
    }
  }


  public void clearParticles(float placeholder) {
    int mI = (int)placeholder;
    clearParticles(mI);
  }


  public void clearParticles(int placeholder) {
    if (okToDraw)
      resetParticles();
    else
      drawNext = true;
  }

  void resetParticles() {
    okToDraw = false;
    particles = new Particle[(width+particleMargin*2)/particlesDensity*(height+particleMargin*2)/particlesDensity];
    int i = 0;
    for (int y=-particleMargin; y<height+particleMargin; y+=particlesDensity) {
      for (int x=-particleMargin; x<width+particleMargin; x+=particlesDensity) {
        if (i == particles.length) {
          println(i);
          break;
        }
        //color control - insert audio option
        //purple
        //int c = color(180+60*sin(PI*x/width), 200, 255*sin(PI*y/width));
        //earthy
        //int c = color(18+60*sin(PI*x/width), 200, 255*sin(PI*y/width));
        //increased saturation
        //int c = color(200*sin(PI*x/width), 225, 255*sin(PI*y/width));
        //int c = color(360*sin(PI*x/width), 127, 255*sin(PI*y/width));
        //variable color
        //int c = color((setcolorMode-50)+40*sin(PI*x/width), 225, 255*sin(PI*y/width));
        int c = color((setcolorMode)+20*sin(PI*x/width), vFader2*sin(PI*(y)/width), vFader3*sin(PI*y/width));
        particles[i++] = new Particle(x, y, c);
      }
    }
    drawNext = false;
    okToDraw = true;
  }


/*
  public void setcolorMode(float colorspectrum) {
    setcolorMode = (int)map(colorspectrum, 0, 1, 0, 255);
  }    
*/

  public class ImgProc {

    void ImgProc() {
    }

    void drawPixelArray(int[] src, int dx, int dy, int w, int h) {  
      //backBuf.loadPixels();
      //arraycopy(src, backBuf.pixels);
      //backBuf.updatePixels();
      //image(backBuf, dx, dy);
      loadPixels();
      int x;
      int y;
      for (int i=0; i<w*h; i++) {
        x = dx + i % w;
        y = dy + i / w;
        pixels[x  + y * w] = src[i];
      }
      updatePixels();
    }

    void blur(int[] src, int[] dst, int w, int h) {
      int c;
      int r;
      int g;
      int b;
      for (int y=1; y<h-1; y++) {
        for (int x=1; x<w-1; x++) {      
          r = 0;
          g = 0;
          b = 0;
          for (int yb=-1; yb<=1; yb++) {
            for (int xb=-1; xb<=1; xb++) {
              c = src[(x+xb)+(y-yb)*w];      
              r += (c >> 16) & 0xFF;
              g += (c >> 8) & 0xFF;
              b += (c) & 0xFF;
            }
          }      
          r /= 9;
          g /= 9;
          b /= 9;
          dst[x + y*w] = 0xFF000000 | (r << 16) | (g << 8) | b;
        }
      }
    }

    //you must be in RGB colorModel
    void scaleBrightness(int[] src, int[] dst, int w, int h, float s) {
      int r;
      int g;
      int b;
      int c;
      int a;
      float as = s;
      s = 1.0;
      for (int y=0; y<h; y++) {
        for (int x=0; x<w; x++) {
          c = src[x + y*w];
          a = (int)(as *((c >> 24) & 0xFF));
          r = (int)(s * ((c >> 16) & 0xFF));
          g = (int)(s *((c >> 8) & 0xFF));
          b = (int)(s *((c) & 0xFF));      
          dst[x + y*w] = (a << 24) | (r << 16) | (g << 8) | b;
          //ch = hue(c);
          //cs = saturation(c);
          //cb = brightness(c) * s;
          //dst[x + y*w] = color(ch, cs, cb);
          //dst[x + y*w] = src[x + y*w];
        }
      }
    }
  }
}

