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
RadioButton loopSelect;
RadioButton useTablet;
Textfield trajNameInput;
String trajName = "";

Textfield source;
Button saveButton;
Slider tempo;

boolean isPaused;

// modes
byte IDLE = 35;
byte DRAW = 40;
byte PLAY = 50;
// idle by default
byte mode = IDLE;
boolean displayScene = false;
//
int cOffX = 20;
int cOffY = 65;


//
int sceneIdx = 1;
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
   
   String [] optionsLoop = {"loop", "no loop"};
   String [] optionsTablet = {"tablet", "no tablet"};
   
   //loop = Controls.getSwitch(cp5, "loop", Controls.colUp*4 , 1, -20);
   loopSelect = Controls.getRadioFixedOptions(cp5, "loopSelector", optionsLoop, "loop", Controls.colUp*4 , 1, -30);
   play = Controls.getButton(cp5, "play", playDefault, playActive , Controls.colUp*5 , 1, -20);
   
   pause = Controls.getButton(cp5, "pause", pauseDefault, pauseActive, Controls.colUp*5 + 50 , 1, -20);
   stopButton = Controls.getButton(cp5, "stopButton", stopDefault, stopActive, Controls.colUp*5 + 100 , 1, -20);
   
   useTablet = Controls.getRadioFixedOptions(cp5, "useTablet", optionsTablet, "no tablet", Controls.column , 1, -30);
   
  // separator
  tempo = Controls.getSliderH(cp5, "duration", 0.005, 4, Controls.colUp, 1, -20);
  tempo.setValue(0.5);
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
  background(0, 0, 0);
  
  canvas.drawScene();  
  if (mousePressed && mode != PLAY) {
    canvas.drawPoints(firstClicked);
    firstClicked = false;    
  } else {
    canvas.drawCanvas();
  }
  if (!isPaused && mode == PLAY && traj.size() > 0) {
    stroke(green);
    strokeWeight(8);
    if(ti < points.size()) {
      Point p = points.get(ti);      
      point(p.x+cOffX, p.y+cOffY);      
    }
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
    //frameRate(IDLE);
    firstClicked = false;
    // set END cmp to last path point
    canvas.closePath();
    //canvas.renderPoints();
  }
}

public void saveButton(int value){
  String n = trajNameInput.getText();
  n = trim(n).toLowerCase().replace(".tr","");
  canvas.loadTrajBundles();
  canvas.saveTrajectory(n);
  traj = canvas.traj;
  points = canvas.points;
  ti = 0;
  int idx = +trajList.getItems().size();
  println("New traj index: " + trajList.getItem(n));
  if (trajList.getItem(n) == null) {
    trajList.addItem(n, idx);    
  }
  trajList.activate(n);
  
}

public void play(int value) {
  canvas.loadTrajBundles();
  traj = canvas.traj;
  points = canvas.points;
  println(value);
  mode = PLAY;
  isPaused = false;
  frameRate(mode);
  thread("trajTimer");
}

public void pause(int value){
   isPaused = true;
}

public void stopButton(int value){
  ti = 0;
  mode = IDLE;
  // frameRate(mode);
}

public void clearButton(int value){
  ti = 0;
  canvas.removePoints();
  canvas.drawCanvas();
  canvas.prev = null;
  mode = IDLE;
}

public void sceneList(int a) {
  String name = sceneList.getItem(a).getName();
  println("switching to scene " + name);
  canvas.scene.loadScene(name);
}

void keyPressed() {}
void keyReleased() {}


public void separator(String text, int c ,int r, int w, int h) {
    text("---"+text+"---", c, r, w, h);
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage msg) {
  switch (msg.addrPattern()) {
    case "/play":
      println("play");
    case "/stop":
      println("stop");
    case "/pause":
      println("pause");
    case "/duration":
      println("duration");
    case "/traj":
      println("traj");
    
    default:
      break;  
  }
  
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+msg.addrPattern());
  println(" typetag: "+msg.typetag());
}

void trajTimer() {
  int lastEvent = millis();
  while(!isPaused && canvas.traj.size() > 0) {
    //point(random(6,width), random(8, height));
    if(millis()- lastEvent > 1000 * tempo.getValue()) {
      if (ti >= points.size()) { ti = 0;}
      oscP5.send(canvas.traj.get(ti), myRemoteLocation);
      ti++;
      lastEvent = millis();
    }
  } 
}
