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
PImage playActive;
PImage playDefault;
PImage pauseActive;
PImage pauseDefault;
PImage stopActive;
PImage stopDefault;

PImage saveActive;
PImage saveDefault;
PImage clearActive;
PImage clearDefault;
// loop - checkbox
// tempo - slider + numeric
// play - button
// pause - button
// stop - button
// traj list / radio button
// scene list
//ControlFont.RENDER_2X = true;
RadioButton trajList;
RadioButton sceneList;
Button play;
Button pause;
Button stopButton;
Button clearButton;
//Button clear;
CheckBox loop;
Textfield trajNameInput;
String trajName = "";

Textfield source;
Button saveButton;
Slider tempo;

boolean isPaused;

// modes
byte IDLE = 20;
byte DRAW = 40;
byte PLAY = 30;
// idle by default
byte mode = IDLE;
boolean displayScene = false;
//
int cOffX = 20;
int cOffY = 65;

void setup() {
  size(780, 600, P2D);
  colorMode(HSB, 360, 100, 100);
  background(0, 0, 0);
  font = loadFont("CourierNewPSMT-48.vlw");
  //font = loadFont("Corbel-Bold-48.vlw");
  textFont(font, 12);
  path = sketchPath();
  isPaused = false;
  // images - stupid and anoying icons
  playDefault = loadImage("icons/play_g.png");
  playActive = loadImage("icons/play_ga.png");
  pauseDefault = loadImage("icons/pause_g.png");
  pauseActive = loadImage("icons/pause_ga.png");
  stopDefault = loadImage("icons/stop_g.png");
  stopActive = loadImage("icons/stop_ga.png");
  
  saveDefault = loadImage("icons/save_g.png");
  saveActive = loadImage("icons/save_ga.png");
  clearDefault = loadImage("icons/clear_g.png");
  clearActive = loadImage("icons/clear_ga.png");  
  
  // GUI
   cp5 = new ControlP5(this);
   Controls.config(cp5, font);
   
   play = Controls.getButton(cp5, "play", playDefault, playActive , Controls.colUp*5 , 1, -20);
   
   pause = Controls.getButton(cp5, "pause", pauseDefault, pauseActive, Controls.colUp*5 + 50 , 1, -20);
   stopButton = Controls.getButton(cp5, "stopButton", stopDefault, stopActive, Controls.colUp*5 + 100 , 1, -20);
   
   // separator
   tempo = Controls.getSliderH(cp5, "tempo", 0.1, 20, Controls.colUp, 1, -20);
   // separator
   
   //
   trajNameInput = Controls.getTextInput(cp5, "trajName", 2);
   saveButton = Controls.getButton(cp5, "saveButton", saveDefault, saveActive, Controls.column + Controls.itmWidth + 5 , 2, 2);
   clearButton = Controls.getButton(cp5, "clearButton", clearDefault, clearActive, Controls.column + Controls.itmWidth + 30 , 2, 2);
   trajList = Controls.getRadioOptions(cp5, "trajList", path+"/traj", ".tr", true, "<NEW>", 3);
   // separator
   sceneList = Controls.getRadioOptions(cp5,"sceneList", path+"/data/scenes", "", false, "default", 8);
   
  
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
  //println(trajNameInput.getText());
  background(0, 0, 0);
  if (mousePressed && mode != PLAY) {
    canvas.drawPoints(firstClicked);
    firstClicked = false;
    
  } else {
    canvas.drawCanvas();
  }
    
  if (!isPaused && mode == PLAY && traj.size() > 0) {
    if (ti >= points.size()) { ti = 0;}
    oscP5.send(traj.get(ti), myRemoteLocation);
    
    stroke(green);
    strokeWeight(8);
    Point p = points.get(ti);
    point(p.x+cOffX, p.y+cOffY);
    ti++;
  }
  
  if(isPaused) {
    Point p = points.get(ti);
    point(p.x+cOffX, p.y+cOffY);
  }
  
  fill(green);
  separator("TRAJECTORY", Controls.column, Controls.row *2-35, Controls.itmWidth, Controls.itmHeight);
  separator("SCENE", Controls.column, Controls.row *8-35, Controls.itmWidth, Controls.itmHeight);
  text("TRAJ POINTS: "+canvas.points.size(), cOffX, height -20);
  // 
  text("_TR", cOffX, 30);
  //println(mouseY);
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

public void saveButton(int value){
  canvas.saveTrajectory(trajNameInput.getText());
  canvas.loadTrajBundles();
  traj = canvas.traj;
  points = canvas.points;
  ti = 0;
}

public void play(int value){
  println(value);
  mode = PLAY;
  isPaused = false;
  frameRate(mode);
}

public void pause(int value){
   isPaused = true;
}

public void stopButton(int value){
  ti = 0;
  mode = IDLE;
  frameRate(mode);
}

public void clearButton(int value){
  ti = 0;
  canvas.removePoints();
  canvas.drawCanvas();
  canvas.prev = null;
  mode = IDLE;
}

void keyPressed() {}
void keyReleased() {}

public void separator(String text, int c ,int r, int w, int h) {
    text("---"+text+"---", c, r, w, h);
}
