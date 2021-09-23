import oscP5.*;

class Canvas {
  PVector location;
  PVector size;
  ArrayList <Point> points;
  ArrayList<OscBundle> traj = new ArrayList<OscBundle>();
  PGraphics cnv;
  PImage prev;
  Tablet tablet;
  int x, y;
  float pf = 5; // pressure factor
  boolean usingTablet;
  int m; // marker count
  PFont font;
  Scene scene;
  boolean displayScene = true;

  Canvas(PGraphics cnv, int x, int y, Tablet tablet) {
    this.font = loadFont("CourierNewPSMT-48.vlw");
    cnv.textFont(font, 128);
    this.usingTablet = true;
    //this.size = new PVector(w, h);
    // this.location = new PVector(x, y);
    this.points = new ArrayList<Point>();
    this.cnv = cnv;
    this.cnv.smooth(0);
    
    // tablet support
    this.tablet = tablet; 
    
    this.x = x;
    this.y = y;
    //println(this.cnv);
    this.m = 1;
    
    this.scene = new Scene();
  }

  void setUsingTablet(boolean t) {this.usingTablet = t;}
  
  void drawCanvas() {
    cnv.beginDraw();
    cnv.colorMode(HSB, 360, 100, 100, 100);
    cnv.background(0, 10, 100, 3);
    cnv.image(scene.sceneRevB, 0, 0);
    cnv.noFill();
    cnv.stroke(0);
    cnv.rect(0, 0, cnv.width-1, cnv.height-1);
    cnv.endDraw();
    image(cnv, x, y);
  }
  
  boolean isInsideCanvas() {    
    if(mouseX > location.x && mouseX < location.x + size.x &&
       mouseY > location.y && mouseY < location.y + size.y
    ) {
      return true;
    }
    return false;
  }

  void drawPoints() {
    cnv.beginDraw();
    cnv.background(0, 10, 100, 3);
    cnv.image(scene.sceneRevB, 0, 0);
    if(prev != null) { cnv.image(prev, 0, 0);}
    cnv.colorMode(HSB, 360, 100, 100, 100);
    
    Point p = new Point(mouseX-x, mouseY-y, pmouseX-x, pmouseY-y, 250, 500);
    println(tablet.getPressure() );
    float press = this.usingTablet ? map(tablet.getPressure(), 0, 1, 1, pf) : 1;
    
    cnv.strokeWeight(press);
    // if too long check interpolation for long lines
              
    float vel = map(p.vel, 0, 50, 20, 340);
    //println(vel);
    cnv.stroke(vel, 80, 80);
    cnv.line(mouseX-x, mouseY-y, pmouseX-x, pmouseY-y);
    // marks
    
    // TODO modulo according speed
    if (points.size() % 30 == 0) {
      cnv.fill(0, 10, 100); 
      cnv.textFont(font, 15);
      // cnv.strokeWeight(10);
      // cnv.textSize(15);
      cnv.text(m, mouseX-x, mouseY-y);
      m++;
    } else {
      cnv.strokeWeight(press*2);
      cnv.stroke(vel, 80, 80, 60);
      cnv.point(mouseX-x, mouseY-y);
    }
        
    cnv.fill(0,0,0);    
    cnv.noStroke();
    cnv.ellipse(250, 500, 6, 6);
    cnv.noFill();
    cnv.stroke(0);
    cnv.rect(0, 0, cnv.width-1, cnv.height-1);
    
    cnv.endDraw();
    
    prev = cnv.copy();
    
    image(prev, x, y);
    points.add(p);    
  }
  
  void closePath() {
    points.get(points.size() - 1).setCmd("END");
  }
  
  
  void capturePoints() {
    
  }
  
  void renderPoints() {
    // CONVERT POINTS TO SHAPE
    //this.drawPoints();
  }

  void saveTrajectory() {
    String[] _points = new String[points.size()]; 

    for (int i = 0; i < points.size(); i++) {
      _points[i] = points.get(i).toString();
    }
    int nro = 0;
    saveStrings("traj/traj"+nro, _points);
  }
  
  void loadTrajectory(int t) {
    // list files an find the t traj
  
  }
  
  void removePoints() {
    points.removeAll(points);
    m = 1;
    cnv.background(0, 0, 100);
  }
  
  void loadTrajBundles() {
    for(int i = 0; i < points.size(); i++) {
      traj.add(points.get(i).toBundle());
    }
  }
}
