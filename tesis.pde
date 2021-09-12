import controlP5.*;
import processing.javafx.PGraphicsFX2D;
import codeanticode.tablet.*;
import oscP5.*;
import netP5.*;

// libraries
ControlP5 Cp5;
Tablet tablet;
OscP5 oscP5;
NetAddress myRemoteLocation;
//
PGraphics c;
Canvas canvas;
boolean isDrawing = false;

// modes
byte IDLE = 10;
byte DRAW = 40;
byte PLAY = 20;
// idle by default
byte mode = IDLE;

void setup() {
  size(600, 600, P2D);
  // surface.setResizable(true);
  c = createGraphics(500, 500, P2D);
  //fullScreen();
  background(255);
  tablet = new Tablet(this); //<>//
  
  canvas = new Canvas(c, 50, 50, tablet);
  canvas.setUsingTablet(false);
  canvas.drawCanvas();
  colorMode(HSB, 360, 100, 100);
  
  //frameRate(30);
  frameRate(10);
}

void draw() {
  
  // background(0,0, 100);
  if (mousePressed) {
    canvas.drawPoints();
  }
  
  if (keyPressed && key == 's') {
    canvas.saveTrajectory();    
  }
}


void mousePressed() {
  isDrawing = true;
  frameRate(DRAW);
}

void mouseReleased() {
  frameRate(IDLE);
  isDrawing = false;
  // set END cmp to last path point
  canvas.closePath();
  canvas.renderPoints();
}

void keyPressed() {
// clearCanvas
  if (keyPressed && key == 'q') {
    canvas.removePoints();
    canvas.drawCanvas();
  } 
}
