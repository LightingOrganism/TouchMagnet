class HeatmapRenderer extends AudioRenderer {

  /*
A touch heatmap with integration with led pixels.
   Dan Cote, Dustin Edwards - GPLv2
   
   */

  /* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/46554*@* */
  /* !do not delete the line above, required for linking your tweak if you re-upload */


  // Array to store the heat values for each pixel
  float heatmap[][][] = new float[2][canvasW][canvasH];
  // The index of the current heatmap
  int index = 0;
  // A color gradient to see pretty colors
  Gradient g;


  int rotations;
  boolean toggle = true;

  HeatmapRenderer(AudioSource source) {
    //rotations =  (int) source.sampleRate() / source.bufferSize();
  }

  void setup()
  {
    //size(ssize, ssize, P3D);
    colorMode(RGB, 255);
    g = new Gradient();
    /*
    g.addColor(color(0, 0, 0));
     g.addColor(color(102, 11, 0));
     g.addColor(color(140, 29, 72));
     g.addColor(color(204, 50, 0));
     g.addColor(color(200, 40, 102));
     g.addColor(color(111, 20, 75));
     g.addColor(color(191, 0, 50));
     g.addColor(color(255, 102, 0));
     g.addColor(color(204, 0, 20));
     g.addColor(color(153, 0, 0));
     g.addColor(color(255, 153, 102));
     g.addColor(color(255, 255, 255));
     g.addColor(color(0, 0, 0));
     
    g.addColor(color(102, 11, 0));
    g.addColor(color(204, 50, 0));
    g.addColor(color(111, 0, 75));
    g.addColor(color(10, 0, 50));
    g.addColor(color(102, 11, 0));
    g.addColor(color(0, 0, 0));
    g.addColor(color(151, 10, 0));
    g.addColor(color(204, 0, 20));
    g.addColor(color(153, 0, 0));
    g.addColor(color(250, 153, 0));
    g.addColor(color(255, 200, 200));
    g.addColor(color(0, 0, 0));
*/
    g.addColor(color(102, 11, 0));
    g.addColor(color(204, 50, 0));
    g.addColor(color(111, 0, 75));
    g.addColor(color(10, 0, 50));
    g.addColor(color(102, 11, 0));
    g.addColor(color(0, 0, 0));
    g.addColor(color(151, 10, 0));
    g.addColor(color(204, 0, 20));
    g.addColor(color(153, 0, 0));
    g.addColor(color(250, 153, 0));
    g.addColor(color(255, 200, 200));
    g.addColor(color(255, 255, 255));
    g.addColor(color(200, 125, 125));
    g.addColor(color(0, 0, 0));


    //add gradient color
    //hsb picker


    // Initalize the heat map (make sure everything is 0.0)
    for (int i = 0; i < canvasW; ++i)
      for (int j = 0; j < canvasH; ++j)
        heatmap[index][i][j] = 0.0;
  }

  synchronized void draw()
  {
    colorMode(RGB, 255);
    // See if heat (or cold) needs applied
    if (mousePressed && (mouseButton == LEFT))
      apply_heat(mouseX, mouseY, 25, .25);
    if (mousePressed && (mouseButton == RIGHT))
      apply_heat(mouseX, mouseY, 25, -.2);

    // Calculate the next step of the heatmap
    update_heatmap();

    // For each pixel, translate its heat to the appropriate color
    for (int i = 0; i < canvasW; ++i) {
      for (int j = 0; j < canvasH; ++j) {
        color thisColor = g.getGradient(heatmap[index][i][j]);
        //thisColor = color(red(thisColor) - 50, green(thisColor) - 50, blue(thisColor) - 50 ); //master fade

        set(i, j, thisColor);
      }
    }
  }

  void update_heatmap()
  {
    // Calculate the new heat value for each pixel
    for (int i = 0; i < canvasW; ++i)
      for (int j = 0; j < canvasH; ++j)
        heatmap[index ^ 1][i][j] = calc_pixel(i, j);

    // flip the index to the next heatmap
    index ^= 1;
  }

  float calc_pixel(int i, int j)
  {
    float total = 0.0;
    int count = 0;

    // This is were the magic happens...
    // Average the heat around the current pixel to determin the new value
    for (int ii = -1; ii < 2; ++ii)
    {
      for (int jj = -1; jj < 2; ++jj)
      {
        if (i + ii < 0 || i + ii >= width || j + jj < 0 || j + jj >= height)
          continue;

        ++count;
        total += heatmap[index][i + ii][j + jj];
      }
    }

    // return the average
    return total / count;
  }

  public void onClick(float mX, float mY) {
    float cX = mX * canvasW;
    float cY = mY * canvasH;
    int oX = (int)cX;
    int oY = (int)cY;
    if (toggle == true)
    apply_heat(oX, oY, 25, .15);
    if (toggle == false)
    apply_heat(oX, oY, 25, -.2);
  }

  public void heattoggle(float oscToggle) {
    //int mI = (int)placeholder;
    if (oscToggle == 1)
      toggle = false;
    if (oscToggle == 0)
      toggle = true;
  }

  void apply_heat(int i, int j, int r, float delta)
  {
    // apply delta heat (or remove it) at location 
    // (i, j) with rad8ius r

    for (int ii = -(r / 2 ); ii < (r / 2); ++ii)
    {
      for (int jj = -(r / 2); jj < (r / 2); ++jj)
      {
        if (i + ii < 0 || i + ii >= width || j + jj < 0 || j + jj >= height)
          continue;

        // apply the heat
        heatmap[index][i + ii][j + jj] += delta;
        heatmap[index][i + ii][j + jj] = constrain(heatmap[index][i + ii][j + jj], 0.0, 20.0);
      }
    }
  }
}

