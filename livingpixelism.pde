 /* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/17043*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */
  /* Tweaked by Lighting Organism */

 int scl = 1; 
  int res = 3;
  //int res = 4;
  //int scl = 2; 
  //int res = 6;
  //int scl = 1; 
  //int res = 6;
  //int scl = 3;
  //int res = 5;
  int dirs = 5 , rdrop = 12, lim = 128;
  int palette = 0, pattern = 2, soft =2;
  int dx, dy, w, h, s;
  boolean border;
  PImage img;
  
  
float[] pat;


/////////////////////////////////////////////////
//                                             //
class TuringRenderer extends AudioRenderer {

//    The Secret Life of Turing Patterns       //
//                                             //
/////////////////////////////////////////////////

// Inspired by the work of Jonathan McCabe
// (c) Martin Schneider 2010

//int vFader3 = 0;

int rotations;

 TuringRenderer(AudioSource source) {
    //rotations =  (int) source.sampleRate() / source.bufferSize();
  }

/*
  int scl = 2, dirs = 9, rdrop = 10, lim = 128;
  int res = 6, palette = 0, pattern = 2, soft = 2;
  int dx, dy, w, h, s;
  boolean border, invert;
  float[] pat;
  PImage img;
  */ 
  void setup() {
    size(canvasW, canvasH);
    colorMode(HSB, 255);
    
    int vFader2 = 255;
    int vFader3 = 0;
    int setContrastModeF = 6;
    //int vFader3 = 127;
    
    reset();
   
  }
  
  void reset() {
    w = width/res; 
    h = height/res; 
    s = w*h;
    img = createImage(w, h, RGB);
    pat = new float[s];
    // random init
    for(int i=0; i<s; i++)  
      pat[i] = floor(random(480));
  }
  
  synchronized void draw() {
    
    // constrain the mouse position
    if(border) {
      mouseX = constrain(mouseX,0,width-1);
      mouseY = constrain(mouseY,0,height-1);
    } 
      
    // add a circular drop of chemical
    if(mousePressed) {
        if(mouseButton != CENTER) {
        int x0 =  mod((mouseX-dx)/res, w);
        int y0 = mod((mouseY-dy)/res, h);
        int r = rdrop * scl / res ;
        for(int y=y0-r; y<y0+r;y++)
          for(int x=x0-r; x<x0+r;x++) {
            int xwrap = mod(x,w), ywrap = mod(y,w);
            if(border && (x!=xwrap || y!=ywrap)) continue;          
            if(dist(x,y,x0,y0) < r)
              pat[xwrap+w*ywrap] = mouseButton == LEFT ? 255 : 1;
          }
      }
    }
  
    // calculate a single pattern step
    pattern();
    
    // draw chemicals to the canvas
    img.loadPixels();
    for(int x=0; x<w; x++)
      for(int y=0; y<h; y++) {
        int c = (x+dx/res)%w + ((y+dy/res)%h)*w;
        int i = x+y*w;
        float val = invert ? 255-pat[i]: pat[i];
        
         //setContrastModeF = (int)map(vFader4, 0, 255, 1, 50);
        float setContrastModeF = (float)map(vFader4, 0, 255, 0.001, .06); 
        
        switch(palette) {
          //case 0: img.pixels[c] = color((val-setcolorMode)/setContrastModeF, vFader2, val-vFader3); break;
          //case 0: img.pixels[c] = color((setcolorMode-10)+30*sin(TWO_PI*x/width), vFader2, vFader3-val); break;
          //case 0: img.pixels[c] = color(((setcolorMode-10)+20*sin(PI*x/width)-val)/setContrastModeF, vFader2, val-vFader3); break;
         //          
         case 0: img.pixels[c] = color(setcolorMode + 20 * sin(val*setContrastModeF), vFader2,val-vFader3 + 127 * sin(val*0.0004));  break;
          case 1: img.pixels[c] = color(128+val/4, 255, val); break;
          case 2: img.pixels[c] = color(val,val,255-val); break;
          case 3: img.pixels[c] = color(val,178,vFader3/val); break;
          case 4: img.pixels[c] = color(val/10,255,vFader3); break;
          case 5: img.pixels[c] = color(val*5,255,val); break;
        }
      }
    img.updatePixels();
    
    // display the canvas
    if(soft>0) smooth(); else noSmooth();
    image(img, 0, 0, res*w, res*h);
    if(soft==2) filter(BLUR);
    
     
    
  }

  public void keyPressed() {
    switch(key) {
      case 'r': reset(); break;
      case 'p': pattern = (pattern + 1) % 3; break;
      case 'c': palette = (palette + 1) % 6; break;
      case 'b': border = !border; dx=0; dy=0; break;
      case 'i': invert = !invert; break;
      case 's': soft = (soft + 1) % 3; break;
      case '+': lim = min(lim+8, 255); break;
      case '-': lim = max(lim-8, 0); break;
      case CODED:
        switch(keyCode) {
          case LEFT: scl = max(scl-1, 2); break;
          case RIGHT:scl = min(scl+1, 6); break; 
          case UP:   res = min(res+1, 5); reset(); break;
          case DOWN: res = max(res-1, 1); reset(); break;
        }
        break;
    }
  }
  
  // moving the canvas
  public void mouseDragged() {
    if(mouseButton == CENTER && !border) {
      dx = mod(dx + mouseX - pmouseX, width);
      dy = mod(dy + mouseY - pmouseY, height);
    }
  }
  
  // floor modulo
  final int mod(int a, int n) {
    return a>=0 ? a%n : (n-1)-(-a-1)%n;
  }
  
  
  
 
  void onClick(float mX, float mY) {
    //print("something noticeable");
     
    
    // add a circular drop of chemical
      float cX = mX * canvasW;
      float cY = mY * canvasH;
      int oX = (int)cX;
      int oY = (int)cY;
        int x0 = mod((oX-dx)/res, w);
        int y0 = mod((oY-dy)/res, h);
        int r = rdrop * scl / res ;
        for(int y=y0-r; y<y0+r;y++)
          for(int x=x0-r; x<x0+r;x++) {
            int xwrap = mod(x,w), ywrap = mod(y,w);
            if(border && (x!=xwrap || y!=ywrap)) continue;          
            if(dist(x,y,x0,y0) < r)
             pat[xwrap+w*ywrap] = 255;  
          }
  }
  void directiontoggle(float oscToggle) {
    //int mI = (int)placeholder;
    if (oscToggle == 1) {
    invert = false;
    type++;
    if (type > 1){
            type=0;
          }
    }
    if (oscToggle == 0){
    invert = true;
    type++;
    if (type > 1){
            type=0;
          }
    }
  } 
  
  
// this is where the magic happens ...

void pattern() {
  
  // random angular offset
  float R = random(TWO_PI);

  // copy chemicals
  float[] pnew = new float[s];
  for(int i=0; i<s; i++) pnew[i] = pat[i];

  // create matrices
  float[][] pmedian = new float[s][scl];
  float[][] prange = new float[s][scl];
  float[][] pvar = new float[s][scl];

  // iterate over increasing distances
  for(int i=0; i<scl; i++) {
    float d = (2<<i) ; 
    
    // update median matrix
    for(int j=0; j<dirs; j++) {
      float dir = j*TWO_PI/dirs + R;
      int dx = int (d * cos(dir));
      int dy = int (d * sin(dir));
      for(int l=0; l<s; l++) {  
        // coordinates of the connected cell
        int x1 = l%w + dx, y1 = l/w + dy;
        // skip if the cell is beyond the border or wrap around
        if(x1<0) if(border) continue; else x1 = w-1-(-x1-1)% w; else if(x1>=w) if(border) continue; else x1 = x1%w;
        if(y1<0) if(border) continue; else y1 = h-1-(-y1-1)% h; else if(y1>=h) if(border) continue; else y1 = y1%h;
        // update median
        pmedian[l][i] += pat[x1+y1*w] / dirs;
        
      }
    }
    
    // update range and variance matrix
    for(int j=0; j<dirs; j++) {
      float dir = j*TWO_PI/dirs + R;
      int dx = int (d * cos(dir));
      int dy = int (d * sin(dir));
      for(int l=0; l<s; l++) {  
        // coordinates of the connected cell
        int x1 = l%w + dx, y1 = l/w + dy;
        // skip if the cell is beyond the border or wrap around
        if(x1<0) if(border) continue; else x1 = w-1-(-x1-1)% w; else if(x1>=w) if(border) continue; else x1 = x1%w;
        if(y1<0) if(border) continue; else y1 = h-1-(-y1-1)% h; else if(y1>=h) if(border) continue; else y1 = y1%h;
        // update variance
        pvar[l][i] += abs( pat[x1+y1*w]  - pmedian[l][i] ) / dirs;
        // update range
        
        prange[l][i] += pat[x1+y1*w] > (lim + i*10) ? +1 : -1;    
   
      }
    }     
  }

  for(int l=0; l<s; l++) {  
    
    // find min and max variation
    int imin=0, imax=scl;
    float vmin = MAX_FLOAT;
    float vmax = -MAX_FLOAT;
    for(int i=0; i<scl; i+=1) {
      if (pvar[l][i] <= vmin) { vmin = pvar[l][i]; imin = i; }
      if (pvar[l][i] >= vmax) { vmax = pvar[l][i]; imax = i; }
    } 
    
    // turing pattern variants
    switch(pattern) {
      case 0: for(int i=0; i<=imin; i++)    pnew[l] += prange[l][i]; break;
      case 1: for(int i=imin; i<=imax; i++) pnew[l] += prange[l][i]; break;
      case 2: for(int i=imin; i<=imax; i++) pnew[l] += prange[l][i] + pvar[l][i]/2; break;
    }
      
  }

  // rescale values
  float vmin = MAX_FLOAT;
  float vmax = -MAX_FLOAT;
  for(int i=0; i<s; i++)  {
    vmin = min(vmin, pnew[i]);
    vmax = max(vmax, pnew[i]);
  }       
  float dv = vmax - vmin;
  for(int i=0; i<s; i++) 
    pat[i] = (pnew[i] - vmin) * 255 / dv;
   
}


}


