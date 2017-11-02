                                                                                      //BUTTONS - MARTIN STACEY
boolean [] bstate = {true, true, false, true};                                      //Initial State
Button bt [] = new Button [bstate.length];

void setupbt() {                                                                      //Instanciate
  bt[0] = new Button(30, 40*8, 25, "Move with Perlin Noise", bstate[0]);                    //X,Y, Circle Size, String, Initial State
  bt[1] = new Button(30, 40*9, 25, "Show cPts", bstate[1]);
  bt[2] = new Button(30, 40*10, 25, "Show XYZ", bstate[2]);
  bt[3] = new Button(30, 40*11, 25, "Pyramids", bstate[3]);
}
void drawbt() {                                                                       //Draw all buttons
  for (int i=0; i<bt.length; i++)  bt[i].display();
  for (int i=0; i<bt.length; i++)  bstate[i]=bt[i].onoff();
}
void pressbt() {                                                                      //Press Button
  for (int i=0; i<bt.length; i++)  bt[i].press();
}

class Button {
  int x, y, bSize;
  String label;
  boolean state;
  Button(int x, int y, int bSize, String label, boolean state) {
    this.x = x;
    this.y = y;
    this.bSize = bSize;
    this.label = label;
    this.state = state;
  }
  void display() {
    pushStyle();
    colorMode(RGB, 255);
    strokeWeight(1);
    stroke(200);
    pushMatrix();
    translate(0, 0, 1);
    textAlign(CENTER, CENTER);
    if (state) {
      stroke(200);
      fill(255);
      ellipse(x, y, bSize, bSize);
      fill(100);
          
      text("ON", x, y);
    } else {
      fill(255);
      ellipse(x, y, bSize, bSize);
      fill(100);
      text("OFF", x, y);
    } 
    textAlign(LEFT, CENTER);
    text(label, x+bSize, y);
    popStyle();
    popMatrix();
  }
  void press() {
    if (mouseX > (x - bSize/2) && mouseX < (x + bSize/2)  &&mouseY > (y - bSize/2) && mouseY < (y + bSize/2)) state = !state;
  }
  boolean onoff() {
    return state;
  }
}