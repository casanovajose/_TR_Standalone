import controlP5.*;
import processing.javafx.PGraphicsFX2D;
import codeanticode.tablet.*;
Tablet tablet;


// libraries
ControlP5 Cp5;
//
PGraphics c;
Canvas canvas;

void setup() {
  size(600, 600, P2D);
  // surface.setResizable(true);
  c = createGraphics(500, 500, P2D);
  //fullScreen();
  background(255);
  tablet = new Tablet(this);
  canvas = new Canvas(c, 100, 200, tablet);
  canvas.drawCanvas();
  colorMode(HSB, 360, 100, 100);
  
  //frameRate(30);
}

void draw() {
  //background(0);
  if (mousePressed) {
    canvas.drawPoint();
  }
  
  if (keyPressed && key == 's') {
    canvas.saveTrajectory();    
  }
  
  // clearCanvas
  if (keyPressed && key == 'q') {
    canvas.drawCanvas();    
  } 
}


void mousePressed() {
  
}
