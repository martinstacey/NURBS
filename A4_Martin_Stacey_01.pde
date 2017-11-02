NurbsS s;                                                        //NURBS SURFACES MARTIN STACEY 

void setup() {
  s = new NurbsS();                                              //Instanciate Nurbs Surface
  size(1000, 1000, P3D);
  setupsl();                                                     //Setup Sliders and Buttons
  setupbt();
}

void draw() {
  background(255);
  drawsl();                                                      //Draw Sliders and buttons
  drawbt();                  
  //lights();
  noStroke();
  translate(width/2, height/2, -height/2);
  sphere(5);
  rotateX(-PI/3);
  translate(-width/2, -height/2, width/2);                       //NURBS SURFACE ACTIONS:
  s.ctrlPts(int(slVal[0]), int(slVal[1]));                       //Make ControlPoints
  s.makeKnots(int(slVal[2]), int(slVal[3]));                     //Make Knots
  s.drawAxis(int(slVal[5]), int(slVal[6]));                      //Draw Axis
  s.figure(int(slVal[5]), int(slVal[6]), int(slVal[4]));         //Draw Figure
}
void mousePressed() {
  presssl();                                                     //PressSliders and Buttons
  pressbt();                                                                                                           
}

void mouseReleased() {
  releasesl();                 
}