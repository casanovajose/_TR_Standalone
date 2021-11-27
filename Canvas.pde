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
    this.points = new ArrayList<Point>();
    this.cnv = cnv;
    this.cnv.smooth(0);
    
    // tablet support
    this.usingTablet = false;
    this.tablet = tablet; 
    
    this.x = x;
    this.y = y;
    this.xSize = xSize;
    this.ySize = ySize;

    this.m = 1;
    
    this.scene = new Scene();
  }

  void setUsingTablet(boolean t) {this.usingTablet = t;}
  void drawScene() {
    try {
      image(scene.sceneRevB, x, y);      
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  void drawCanvas() {
    cnv.beginDraw();
    cnv.colorMode(HSB, 360, 100, 100, 100);
    if(prev != null) { cnv.image(prev, 0, 0);}
    // frame
    drawRectFrame(cnv);

    cnv.endDraw();
    image(cnv, x, y);
  }
  
  boolean isInsideCanvas() {    
    if(mouseX > x && mouseX < x + xSize && mouseY > y && mouseY < y + ySize) {
      return true;
    }
    return false;
  }

  void drawPoints(boolean first) {    
    cnv.beginDraw();
    cnv.colorMode(HSB, 360, 100, 100, 100);    
    if(prev != null) { cnv.image(prev, 0, 0);}
    if(isInsideCanvas()){      
      Point p = new Point(mouseX-x, mouseY-y, pmouseX-x, pmouseY-y, 250, 500);
      if(usingTablet) {
        p.press = tablet.getPressure();
      }
      
      drawLine(cnv, p, first);
      // marks    
      // TODO modulo according speed
      drawTextMarker(cnv);
      // points
      drawLineMarker(cnv, p);
            
      points.add(p);
    }

    drawRectFrame(cnv);
    cnv.endDraw();    
    prev = cnv.copy();    
    image(prev, x, y);
  }
  
  void drawLine(PGraphics cnv, Point p, boolean first) {
    // if too long check interpolation for long lines 
    if(!first) {
      float vel = map(p.vel, 0, 50, 20, 340);
      float press = map(p.press, 0, 1, 0.5, pf*2);
      cnv.strokeWeight(this.usingTablet ? press : 2 );
      cnv.stroke(vel, 80, 80, 50);    
      cnv.line(p.x, p.y, p.px, p.py);
    }  
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

  boolean isStartPoint(int idx) {
    if (idx == 0) {return true;}
    return points.get(idx-1).cmd.equals("END");
  }

  void saveTrajectory(String name) {
    name = trim(name);
    if(name.length() == 0) { name = "base";}
    
    String[] _points = new String[points.size()]; 

    for (int i = 0; i < points.size(); i++) {
      if (isStartPoint(i)) {
        points.get(i).cmd = "START";
      }
      _points[i] = points.get(i).toString();
    }

    saveStrings("traj/"+name+".tr", _points);
  }

  boolean isFileUsingTablet(String[] lines) {
    for (int i = 0 ; i < lines.length; i++) {
      String [] l = split(lines[i], " ");
      if(float(l[3]) > 0) {
        println("TABLET");
        return true;
      }
    }
    return false;
  }
  
  void loadTrajectory(String name) {
    points.removeAll(points);
    // list files an find the t traj
    String[] lines = loadStrings("traj/"+name+".tr");
    this.usingTablet = isFileUsingTablet(lines);
    // previous points
    int px = 0;
    int py = 0;
    println("there are " + lines.length + " lines");
    cnv.beginDraw();
    for (int i = 0 ; i < lines.length; i++) {
      String [] l = split(lines[i], " ");
      int x = int(l[0]);
      int y = int(l[1]);
      String cmd = l[4];

      Point p = new Point(x, y, px, py, 250, 500);
      px = x;
      py = y; 
      p.cmd = cmd;
      p.press = float(l[3]);
      boolean first = cmd.equals("START");
      points.add(p);
      drawLine(cnv, p, first);      
    }
    cnv.endDraw();    
    prev = cnv.copy();    
    image(prev, x, y);
  }
  
  void removePoints() {
    points.removeAll(points);
    cnv =createGraphics(500, 500, P2D);
    m = 1;
    // cnv.background(0, 0, 100);
  }  

  void clearTraj() {
    this.removePoints();
    this.drawCanvas();
    this.prev = null;
  }

  void loadTrajBundles() {
    traj.removeAll(traj);
    println("Reloading points values for scene: " + scene.name);
    for(int i = 0; i < points.size(); i++) {
      Point p = points.get(i);
      p.setValues(scene.getValuesAt(p.x, p.y));
      traj.add(p.toBundle());
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
      c.textFont(font, 15);
      c.text(m, mouseX-x, mouseY-y);
      m++;
    }
  }
  
  void drawLineMarker(PGraphics c, Point p) {
    float press = this.usingTablet ? map(p.press, 0, 1, 1, pf) : 1;
    c.strokeWeight(press * 2);
    c.stroke(p.vel, 80, 80, 20);
    c.point(mouseX-x, mouseY-y);
  }
}
