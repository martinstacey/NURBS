class NurbsS {                                                                            //NURBS SURFACE CLASS  - MARTIN STACEY
  int ncPtsX, ncPtsY;                                                                     //number of control points
  PVector [][] cPtsPos;                                                                   //control points position
  int degX, degY;                                                                         //degree in x and y (nKnots = degree+ ncPts + 1)
  float[] knotsX, knotsY;                                                                 //Knot Vectors x and y
  float t = 0;                                                                            //Time for noise (perlin noise movement for control points)

  NurbsS() {
  }

  void ctrlPts(int px, int py) {                                                          //MAKE CONTROL POINTS
    ncPtsX = px;                                                                          //Divide grid equally X and Y, (Z with Perlin Noise)
    ncPtsY = py;
    cPtsPos = new PVector [ncPtsX][ncPtsY];
    for (int x = 0; x < ncPtsX; x++) {
      for (int y = 0; y < ncPtsY; y++) {                   
        float posx = x*width/(ncPtsX-1);
        float posz = noise(x*2, y*2, t)*height;                                             
        float posy =  y*(-height/(ncPtsY-1));
        cPtsPos[x][y] = new PVector(posx, posz, posy);
        fill(100);
        stroke(200);     
        if (bstate[1]) {                                                                     //Draw a box in each cPts Position, conect with line
          pushMatrix();
          translate( cPtsPos[x][y].x, cPtsPos[x][y].y, cPtsPos[x][y].z );                     
          box(5); 
          popMatrix();
          if (x>0) {
            line(cPtsPos[x][y].x, cPtsPos[x][y].y, cPtsPos[x][y].z, cPtsPos[x-1][y].x, cPtsPos[x-1][y].y, cPtsPos[x-1][y].z);
          }
          if (y>0) {
            line( cPtsPos[x][y].x, cPtsPos[x][y].y, cPtsPos[x][y].z, cPtsPos[x][y-1].x, cPtsPos[x][y-1].y, cPtsPos[x][y-1].z);
          }
        }
      }
    }
    if (bstate[0]) t=t+0.005;                                                              //If time is running add Perlin Noise
  }

  void makeKnots(int _dx, int _dy) {                                                       //MAKE KNOTS
    degX = _dx;                                                                            //Make knots according to degree of curve
    degY = _dy;
    knotsX = new float [ncPtsX + degX + 1];
    knotsY = new float [ncPtsY + degY + 1];
    float counterX=0;
    float counterY=0;
    float counterMidX=1.0;
    float counterMidY=1.0;  
    for (int kx = 0; kx < knotsX.length; kx++) {                                          //Knots X
      if (kx<degX+1) {                                                                    //First Knots
        knotsX[kx]=counterX;
        counterX+=0.001;
      } else if (kx>=knotsX.length-(degX+1)) {                                            //Last Knots
        counterX-=0.001;
        knotsX[kx]=1.00-counterX;
      } else {
        knotsX[kx] = counterMidX / float(ncPtsX - degX);                                  //Middle Knots
        counterMidX+=1.0;
      }
    }
    for (int ky = 0; ky < knotsY.length; ky++) {                                          //Knots Y
      if (ky<degY+1) {                                                                    //First Knots
        knotsY[ky]=counterY;
        counterY+=0.001;
      } else if (ky>=knotsY.length-(degY+1)) {                                            //Last Knots
        counterY-=0.001;
        knotsY[ky]=1.00-counterY;
      } else {                                                                            //Middle Knots
        knotsY[ky] = counterMidY / float(ncPtsY - degY); 
        counterMidY+=1.0;
      }
    }
  }
  float faderX(float u, int k) {                                                           //Fader using X Values
    return bfuntion(u, k, degX, knotsX);
  }
  float faderY(float v, int k) {                                                           //Fader using Y Values
    return bfuntion(v, k, degY, knotsY);
  }
  float bfuntion(float uv, int k, int d, float [] knots) {                                 //Base Function 
    if (d == 0) { 
      if (uv >= knots[k] && uv < knots[k+1]) return 1;
      else return 0;
    } else {
      float b1 = bfuntion(uv, k, d-1, knots) * (uv - knots[k]) / (knots[k+d] - knots[k]);
      float b2 = bfuntion(uv, k+1, d-1, knots) * (knots[k+d+1] - uv) / (knots[k+d+1] - knots[k+1]);
      return b1+b2;
    }
  }
  PVector surfPos(float u, float v) {                                                        //Find Surface
    PVector pt = new PVector();                                                              //Finished Vector 
    for (int x=0; x<ncPtsX; x++) for (int y=0; y<ncPtsY; y++) {
      PVector pt_k = new PVector(cPtsPos[x][y].x, cPtsPos[x][y].y, cPtsPos[x][y].z); 
      pt_k.mult(faderX(u, x)*faderY(v, y));                                                  //for surfaces multiply faderU*faderV
      pt.add(pt_k);                                                                          //add the above to find the point on the curve for a given u value (u=parameter space of curve, 0<=u<=1)
    }
    return pt;
  }
  void drawAxis(int stepsX, int stepsY) {                                                    //Draw AXXIS
    for (int x = 0; x<stepsX; x++) {                                                        //Count steps
      for (int y = 0; y<stepsY; y++) {
        float mapx = map(x, 0, stepsX-1, knotsX[degX], knotsX[ncPtsX]);                      //Map According to knots
        float mapx2 = map(x+1, 0, stepsX-1, knotsX[degX], knotsX[ncPtsX]);             
        float  mapy, mapy2;
        if (x%2==0) {                                                                        //Move every Even Values Origin (to better fit tessalations)
          mapy = map(y, 0, stepsY-1, knotsY[degY], knotsY[ncPtsY]);             
          mapy2 = map(y+1, 0, stepsY-1, knotsY[degY], knotsY[ncPtsY]);
        } else {
          mapy = map(y+.5, 0, stepsY-1, knotsY[degY], knotsY[ncPtsY]);
          mapy2 = map(y+1, 0, stepsY-1, knotsY[degY], knotsY[ncPtsY]);
        }
        PVector p1 = surfPos(mapx, mapy);                                                      //Create Points (Use Mapped Points)
        PVector p2 = surfPos(mapx2, mapy);
        PVector p3 = surfPos(mapx2, mapy2);
        PVector p4 = surfPos(mapx, mapy2);
        PVector xdir = PVector.sub(p2, p1);
        PVector ydir = PVector.sub(p3, p1);  
        PVector zdir = PVector.sub(p1, xdir.cross(ydir).setMag(ydir.mag()*.5)); 

        if (bstate[2]&&x!=0&&x!=stepsX-1) {                                                     //Create Axis
          strokeWeight(1);
          stroke(255, 0, 0);
          if (x!=stepsX-1) line (p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);                            // X axis
          stroke(0, 255, 0);
          if (y!=stepsY-1) line (p1.x, p1.y, p1.z, p4.x, p4.y, p4.z);                            //Y Axis
          if (x==stepsX-1) line (p2.x, p2.y, p2.z, p3.x, p3.y, p3.z);
          stroke(0, 0, 255);
          if (y!=stepsY-1) line (p1.x, p1.y, p1.z, zdir.x, zdir.y, zdir.z);                      //Z axis
        }
      }
    }
  }

  void figure(int stepsX, int stepsY, int nsides) {                                              //Draw Figures
    PVector[][] estruc = new PVector [stepsX][stepsY];                                           //Store Values generated by Normals
    PVector [][][] piramides = new PVector [stepsX][stepsY][nsides+1];                           //Store Each Point of Pyramid
    for (int x = 0; x<stepsX; x++) {
      for (int y = 0; y<stepsY; y++) {
        float mapx = map(x, 0, stepsX-1, knotsX[degX], knotsX[knotsX.length-degX-1]);            //Record Each step Mapped
        float mapx2 = map(x+1, 0, stepsX-1, knotsX[degX], knotsX[ncPtsX]); 
        float  mapy, mapy2; 
        if (x%2==0) {
          mapy = map(y, 0, stepsY-1, knotsY[degY], knotsY[knotsY.length-degY-1]);
          mapy2 = map(y+1, 0, stepsY-1, knotsY[degY], knotsY[ncPtsY]);
        } else {
          mapy = map(y+0.5, 0, stepsY-1, knotsY[degY], knotsY[knotsY.length-degY-1]);
          mapy2 = map(y+1, 0, stepsY-1, knotsY[degY], knotsY[ncPtsY]);   
        }
        PVector p1 = surfPos(mapx, mapy);                                                         //Create Points (Use Mapped Points)
        PVector p2 = surfPos(mapx2, mapy);
        PVector p3 = surfPos(mapx2, mapy2);
        PVector xdir = PVector.sub(p2, p1);                                                      //Vectors That represent Axis
        PVector ydir = PVector.sub(p3, p1);  
        PVector zdir = PVector.sub(p1, xdir.cross(ydir).setMag(ydir.mag()*noise(x*2, y*2, t))); 
        estruc [x][y] = zdir;                                                                    //Store  Normal Vector to draw piramyd
        float cstepx = map(1/(1.8*cos(PI/6)), 0, stepsX-1, knotsX[degX], knotsX[knotsX.length-degX-1]);    //This are additional steps (used to adjust side of polygon according to number of sides)
        float cstepy = map(1/(2.2*cos(PI/6)), 0, stepsY-1, knotsY[degY], knotsY[knotsY.length-degY-1]);
        float cstepx4 = map(0.46, 0, stepsX-1, knotsX[degX], knotsX[knotsX.length-degX-1]);
        float cstepxin4 = map(.96, 0, stepsX-1, knotsX[degX], knotsX[knotsX.length-degX-1]);
        float cstepyin4 = map(0.46, 0, stepsY-1, knotsY[degY], knotsY[knotsY.length-degY-1]);
        float cstepy4 = map(0.47, 0, stepsY-1, knotsY[degY], knotsY[knotsY.length-degY-1]);

        fill(255);
        stroke(100);

        PVector [] polygon = new PVector [nsides+1];                                              //Create Polygon Inscribed in Circle 
        beginShape();                                                                             //Draw Polygon using Angles (idea from https://processing.org/examples/regularpolygon.html)
        for (int i = 0; i < polygon.length; i ++) {          
          if (nsides==6||nsides==3)polygon [i] =surfPos( mapx + (cos(i*PI*2/nsides) * (cstepx)), mapy+ (sin(i*PI*2/nsides) *(cstepy))); 
          else if (nsides==4) polygon [i] =surfPos( mapx + (cos(i*PI*2/nsides) * (cstepxin4)), mapy+ (sin(i*PI*2/nsides) *(cstepyin4))); 
          else polygon [i] =surfPos( mapx + (cos(i*PI*2/nsides) * (cstepx4)), mapy+ (sin(i*PI*2/nsides) *(cstepy4))); 
          strokeWeight(2);
          stroke(100);
          if (i!=polygon.length-1&&polygon[i].x!=0) vertex(polygon[i].x, polygon[i].y, polygon[i].z);
        }
        endShape(CLOSE);
        piramides[x][y] = polygon;                                                              //Store all vertexes of polygon
        strokeWeight(1);
      }
    }
    if (bstate[3]) {
      for (int x = 1; x<stepsX-1; x++) {                                                        //Count steps
        for (int y = 1; y<stepsY-1; y++) {            
          for (int i = 1; i<nsides; i++) {
            if (piramides[x][y][i].x!=0) {                                                      //Connect all sides of polygon to normal
              beginShape();
              vertex(estruc[x][y].x, estruc[x][y].y, estruc[x][y].z);
              vertex(piramides[x][y][i].x, piramides[x][y][i].y, piramides[x][y][i].z);
              vertex(piramides[x][y][i-1].x, piramides[x][y][i-1].y, piramides[x][y][i-1].z);
              endShape(CLOSE);
            }
          }
        }
      }
    }
  }
}