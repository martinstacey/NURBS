                                                                                           //SLIDERS - MARTIN STACEY
float [] slVal = {5, 5, 2, 2, 6, 10, 10};                                                  //Initial Values Sliders
Slider sl [] = new Slider [slVal.length];                                                  //Declare Sliders

void setupsl() {                                                                           //Instanciate all Sliders
  sl[0] = new Slider(20, 40*(0+1), 200, 3, 10, slVal[0], "CtrlPointsX", false);            //X,Y, Length, Initial Value, String, Display as Float? 
  sl[1] = new Slider(20, 40*(1+1), 200, 3, 10, slVal[1], "CtrlPointsY", false);
  sl[2] = new Slider(20, 40*(2+1), 200, 1, 3, slVal[2], "DegreeX", false);
  sl[3] = new Slider(20, 40*(3+1), 200, 1, 3, slVal[3], "DegreeY", false);  
  sl[4] = new Slider(20, 40*(4+1), 200, 4, 15, slVal[4], "N Sides", false);
  sl[5] = new Slider(20, 40*(5+1), 200, 5, 20, slVal[5], "X Steps", false);
  sl[6] = new Slider(20, 40*(6+1), 200, 5, 20, slVal[6], "Y Steps", false);

}
void drawsl() {                                                                            //Display all Sliders, get ther Value
  for (int i=0; i<sl.length; i++) sl[i].display();
  for (int i=0; i<sl.length; i++)  slVal [i] = sl [i].value;
}
void presssl() {                                                                          //Press all sliders (Change Value)
  for (int i=0; i<sl.length; i++) if (sl[i].isOver()) sl[i].lock = true;
}
void releasesl() {                                                                        //Release all sliders (Stop Changing value)  
  for (int i=0; i<sl.length; i++) sl[i].lock = false;
}

class Slider {
  float x, y, minX, maxX, value;
  float  minV, maxV, inV;
  boolean lock = false;
  boolean flt = false;
  int bsize=30; 
  String tittle;
  Slider (float posX, float posY, float maxX, float minV, float maxV, float inV, String tittle, boolean flt) {
    this.minX = posX;
    this.x=map(inV, minV, maxV, posX, minX+maxX);
    this.y=posY;
    this.maxX=maxX;
    this.minV=minV;
    this.maxV=maxV;
    this.inV=inV;
    this.tittle=tittle;
    this.flt = flt;
  }
  void display() {                                                                          //Display and write value according to position                                                                       
    pushStyle();
    colorMode(RGB, 255);
    if (flt) value = map(x, minX, minX+maxX, minV, maxV);  
    else value = int(map(x, minX, minX+maxX, minV, maxV));      
    float mx = constrain(mouseX, minX, minX+maxX );     
    if (lock) x = mx;
    fill(255);
    stroke(200);
    strokeWeight(1);
    rect(minX, y, maxX, 2.5);         
    pushMatrix();
    translate(0, 0, 1);
    ellipse(x, y, bsize, bsize);              
    fill(100);  
    textAlign(CENTER, CENTER);
    if (flt) text(nf(value, 0, 2), x+1, y-2);
    else text(int(value), x+1, y-2); 
    textAlign(LEFT, CENTER);
    text(tittle, minX, y-20);
    popMatrix();
    popStyle();
  }   
  void displaymove(float ren) {                                                              //To use when you want it as an output
    pushStyle();
    colorMode(RGB, 255);
    x=map(ren, minV, maxV, minX, minX+maxX);
    if (flt) value = map(x, minX, minX+maxX, minV, maxV);  
    else value = int(map(x, minX, minX+maxX, minV, maxV));      
    float mx = constrain(mouseX, minX, minX+maxX );     
    if (lock) x = mx;
    strokeWeight(1);
    fill(255);
    stroke(200);
    rect(minX, y, maxX, 2.5); 
    pushMatrix();
    translate(0, 0, 1);
    ellipse(x, y, bsize, bsize);              
    fill(100);  
    textAlign(CENTER, CENTER);
    if (flt) text(nf(value, 0, 2), x+1, y-2);
    else text(int(value), x+1, y-2); 
    textAlign(LEFT, CENTER);
    text(tittle, minX, y-20);
    popMatrix();
    popStyle();
  }
  boolean isOver() {
    return (x+(bsize/2) >= mouseX) && (mouseX >= x-(bsize/2)) && (y+(bsize/2) >= mouseY) && (mouseY >= y-(bsize/2));
  } 
  float flSlider() {
    return value;
  }
}