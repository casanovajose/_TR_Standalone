import controlP5.*;
import processing.javafx.PGraphicsFX2D;
import codeanticode.tablet.*;
import oscP5.*;
import netP5.*;

String path; // sketch path
// libraries
ControlP5 cp5;
Tablet tablet;
OscP5 oscP5;
NetAddress myRemoteLocation;
//current traj
ArrayList<Point> points = new ArrayList<Point>();
ArrayList<OscBundle> traj = new ArrayList<OscBundle>();
// traj index
int ti = 0;
//
PGraphics c;
Canvas canvas;
PFont font;
color green = 0xff00e300; // font color
boolean firstClicked = true;

// controls
// loop - checkbox
// tempo - slider + numeric
// play - button
// pause - button
// stop - button
// traj list / radio button
// scene list
DropdownList trajList;
DropdownList sceneList;
Button play;
Button pause;
Button stop;

// modes
byte IDLE = 15;
byte DRAW = 40;
byte PLAY = 20;
// idle by default
byte mode = IDLE;
boolean displayScene = false;
//
int cOffX = 50;
int cOffY = 50;


void setup() {
  size(780, 600, P2D);
  colorMode(HSB, 360, 100, 100);
  background(0, 0, 0);
  font = loadFont("CourierNewPSMT-48.vlw");
  textFont(font, 12);
  path = sketchPath();
  println(path);
  // GUI
   cp5 = new ControlP5(this);
   Controls.config(cp5, font);
   sceneList = Controls.getSceneDropdown(cp5, path, 7);
   trajList = Controls.getTrajDropdown(cp5, path, 6);
   play = Controls.getButton(cp5, "play", "", 0 , 1);
   pause = Controls.getButton(cp5, "pause", "", 50 , 1);
   stop = Controls.getButton(cp5, "stop", "", 100 , 1);
   
  
  // NETWORK
  // listening port 
  oscP5 = new OscP5(this, 667);  
  // sending port
  myRemoteLocation = new NetAddress("127.0.0.1", 666);
  
  // surface.setResizable(true);
  c = createGraphics(500, 500, P2D);
  tablet = new Tablet(this);   //<>// //<>//
  canvas = new Canvas(c, cOffX, cOffY, 500, 500, tablet);
  canvas.setUsingTablet(false);
  canvas.drawCanvas();
  frameRate(IDLE);    
}

void draw() {
  // println(mode);
  background(0, 0, 0);
  if (mousePressed && mode != PLAY) {
    canvas.drawPoints(firstClicked);
    firstClicked = false;
  } else {
    canvas.drawCanvas();
  }
    
  if (mode == PLAY && traj.size() > 0) {
    if (ti >= traj.size()) { ti = 0;}
    oscP5.send(traj.get(ti), myRemoteLocation);
    stroke(green);
    strokeWeight(8);
    Point p = points.get(ti);
    point(p.x+50, p.y+50);
    ti++;
    
    println(ti);
  }
  
  fill(green);
  text("TRAJ POINTS: "+canvas.points.size(), 50, height -30);
}


void mousePressed() {
  
  if(mode != PLAY) {
    firstClicked = true;
    mode = DRAW;
    frameRate(DRAW);
  }  
}

void mouseMoved() {
  firstClicked = false;
}

void mouseReleased() {
  if(mode != PLAY) {
    frameRate(IDLE);
    firstClicked = false;
    // set END cmp to last path point
    canvas.closePath();
    canvas.renderPoints();
  }
}

void keyPressed() {  
// clearCanvas
  if (keyPressed && key == 'q') {
    ti = 0;
    canvas.removePoints();
    canvas.drawCanvas();
    canvas.prev = null;
    mode = IDLE;
  }
  if (keyPressed && key == 's') {
    canvas.saveTrajectory();
    canvas.loadTrajBundles();
    traj = canvas.traj;
    points = canvas.points;
    ti = 0;
    
  }
  
  if (keyPressed && key == 'p') {
    ti = 0;
    mode = PLAY;
    frameRate(mode);
    
  }
  
  if (keyPressed && key == 'o') {
    ti = 0;
    mode = IDLE;
    frameRate(mode);
  }
  
  if (keyPressed && key == 'd') {
     displayScene = true;
  }
  
  if (keyPressed && key == 'f') {
     selectFolder("Select a folder to process:", "folderSelected");
  }
  
  
}

void keyReleased() {
   displayScene = false;
}

void folderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
  }
}
