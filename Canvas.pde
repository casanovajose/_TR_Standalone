import oscP5.*;

class Canvas {
  PVector location;
  PVector size;
  ArrayList <Point> points;
  ArrayList<OscBundle> traj = new ArrayList<OscBundle>();
  PGraphics cnv;
  PImage prev;
  Tablet tablet;
  int x, y, xSize, ySize;
  float pf = 5; // pressure factor
  boolean usingTablet;
  int m; // marker count
  PFont font;
  int pm; // point marker
  Scene scene;
  boolean displayScene = true;

  Canvas(PGraphics cnv, int x, int y, int xSize, int ySize, Tablet tablet) {
    this.font = loadFont("CourierNewPSMT-48.vlw");
    cnv.textFont(font, 12);
    this.usingTablet = false;
    //this.size = new PVector(w, h);
    // this.location = new PVector(x, y);
    this.points = new ArrayList<Point>();
    this.cnv = cnv;
    this.cnv.smooth(0);
    
    // tablet support
    this.tablet = tablet; 
    
    this.x = x;
    this.y = y;
    this.xSize = xSize;
    this.ySize = ySize;

    this.m = 1;
    
    this.scene = new Scene();
  }

  void setUsingTablet(boolean t) {this.usingTablet = t;}
  
  void drawCanvas() {
    cnv.beginDraw();
    cnv.colorMode(HSB, 360, 100, 100, 100);
    cnv.background(0, 10, 100, 3);
    cnv.image(scene.sceneRevB, 0, 0);
    //cnv.image(scene.sceneReverb.get(0), 0, 0);
    //cnv.image(scene.sceneReverb.get(1), 0, 0);
    if(prev != null) { cnv.image(prev, 0, 0);}
    // frame
    drawRectFrame(cnv);
    cnv.endDraw();
    image(cnv, x, y);
  }
  
  boolean isInsideCanvas() {    
    if(mouseX > x && mouseX < x + xSize &&
       mouseY > y && mouseY < y + ySize
    ) {
      return true;
    }
    return false;
  }

  void drawPoints(boolean first) {
    
    cnv.beginDraw();
    cnv.colorMode(HSB, 360, 100, 100, 100);
    cnv.background(0, 10, 100, 3);
    cnv.image(scene.sceneRevB, 0, 0);
    //cnv.image(scene.sceneReverb.get(0), 0, 0);
    //cnv.image(scene.sceneReverb.get(1), 0, 0);
    if(prev != null) { cnv.image(prev, 0, 0);}
    if(isInsideCanvas()){      
      Point p = new Point(mouseX-x, mouseY-y, pmouseX-x, pmouseY-y, 250, 500);
      
      // if too long check interpolation for long lines              
      float vel = map(p.vel, 0, 50, 20, 340);
      // println("vel", vel);
      cnv.strokeWeight(this.usingTablet ? map(tablet.getPressure(), 0, 1, 0.5, pf*2) : 2 );
      cnv.stroke(vel, 80, 80, 50);
      if(first) {    
      } else {
        cnv.line(mouseX-x, mouseY-y, pmouseX-x, pmouseY-y);
      }    
      // marks    
      // TODO modulo according speed
      drawTextMarker(cnv);
      // points
      drawPointMarker(cnv, vel);
      p.setValues(scene.getValuesAt(p.x, p.y));
      points.add(p);
    }
        
    cnv.fill(0,0,0);    
    cnv.noStroke();
    cnv.ellipse(250, 500, 6, 6);
    drawRectFrame(cnv);
    cnv.endDraw();    
    prev = cnv.copy();    
    image(prev, x, y);
        
  }
  
  void closePath() {
    if(!isInsideCanvas()){return;};
    points.get(points.size() - 1).setCmd("END");
  }
  
  
  void capturePoints() {
    
  }
  
  void renderPoints() {
    // CONVERT POINTS TO SHAPE
  }

  void saveTrajectory(String name) {
    name = trim(name);
    if(name.length() == 0) { name = "default";}
    
    String[] _points = new String[points.size()]; 

    for (int i = 0; i < points.size(); i++) {
      _points[i] = points.get(i).toString();
    }

    saveStrings("traj/"+name+".tr", _points);
  }
  
  void loadTrajectory(String name) {
    // list files an find the t traj
  }
  
  void removePoints() {
    points.removeAll(points);
    m = 1;
    // cnv.background(0, 0, 100);
  }
  
  void loadTrajBundles() {
    for(int i = 0; i < points.size(); i++) {
      traj.add(points.get(i).toBundle());
    }
  }
  
  void drawRectFrame(PGraphics c) {
    c.noFill();
    c.strokeWeight(1);
    c.stroke(0, 0, 100);
    c.rect(0, 0, cnv.width-1, cnv.height-1);   
  }
  
  void drawTextMarker(PGraphics c) {
    if (points.size() % 30 == 0) {
      c.fill(0, 10, 100); 
      c.textFont(font, 13);
      c.text(m, mouseX-x, mouseY-y);
      m++;
    }
  }
  
  void drawPointMarker(PGraphics c, float v) {
    float press = this.usingTablet ? map(tablet.getPressure(), 0, 1, 1, pf) : 1;
    c.strokeWeight(press * 2);
    c.stroke(v, 80, 80, 20);
    c.point(mouseX-x, mouseY-y);
  }
}
