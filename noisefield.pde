/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/3897*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */
  /* Tweaked by Lighting Organism */
  
  int NUM_PARTICLES = 1000; 

class NoiseFieldRenderer extends AudioRenderer {

  int rotations;


  NoiseFieldRenderer(AudioSource source) {
    rotations =  (int) source.sampleRate() / source.bufferSize();
  }



  int oX = mouseX;
  int oY = mouseY;

  ParticleSystem p;
  void setup()
  {
    smooth();
    size(canvasW, canvasH);
    colorMode(HSB, 255);
    background(0);

    int setTraceModeF = 10;
    int setSpeed = 20;
    int setContrastModeF = 2;
    p = new ParticleSystem();
  }

  synchronized void draw()
  {
    colorMode(HSB, 255);
    noStroke();
    int setTraceModeF = (int)map(vFader4, 0, 255, 0, 100);
    fill(0, setTraceModeF);
    rect(0, 0, width, height);

    try {
      p.update();
      p.render();
      throw new NullPointerException();
    }
    catch (NullPointerException e) {
    }
  }


  public void onClick(float mX, float mY) {
    float cX = mX * canvasW;
    float cY = mY * canvasH;
    oX = (int)cX;
    oY = (int)cY;
  }
}

class Particle
{
  PVector position, velocity;



  Particle()
  {
    position = new PVector(random(width), random(height));
    velocity = new PVector();
  }

  void update()
  {
    int setSpeed = (int)map(vFader5, 0, 255, 1, 40);
    velocity.x = setSpeed*(noise(noisefield.oX/10+position.y/100)-0.5);
    velocity.y = setSpeed*(noise(noisefield.oY/10+position.x/100)-0.5);
    position.add(velocity);

    if (position.x<0)position.x+=width;
    if (position.x>width)position.x-=width;
    if (position.y<0)position.y+=height;
    if (position.y>height)position.y-=height;
  }

  void render()
  {
    int setContrastModeF = (int)map(vFader6, 0, 255, 1, 10);
    stroke((setcolorMode+10)+20*sin(setContrastModeF*HALF_PI*noisefield.rotations), vFader2, vFader3);
    line(position.x, position.y, position.x-velocity.x, position.y-velocity.y);
  }
}

class ParticleSystem
{
  Particle[] particles;
  
  ParticleSystem()
  {
    particles = new Particle[NUM_PARTICLES];
    for(int i = 0; i < NUM_PARTICLES; i++)
    {
      particles[i]= new Particle();
    }
  }
  
  void update()
  {
    for(int i = 0; i < NUM_PARTICLES; i++)
    {
      particles[i].update();
    }
  }
  
  void render()
  {
    for(int i = 0; i < NUM_PARTICLES; i++)
    {
      particles[i].render();
    }
  }
}
