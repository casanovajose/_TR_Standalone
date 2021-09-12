


class Canvas {
  PVector location;
  PVector size;
  ArrayList <Point> points;
  PGraphics cnv;
  Tablet tablet;
  int x, y;
  float pf; // pressure factor
  boolean usingTablet;
  int m; // marker count
  PFont font;

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
  }

  void setUsingTablet(boolean t) {this.usingTablet = t;}
  
  void drawCanvas() {
    cnv.beginDraw();
    cnv.colorMode(HSB, 360, 100, 100, 100);
    cnv.fill(0, 0, 100);
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
    cnv.colorMode(HSB, 360, 100, 100, 100);
    Point p = new Point(mouseX-x, mouseY-y, pmouseX-x, pmouseY-y, 250, 500);
    
    float press = this.usingTablet ? tablet.getPressure() * pf : 1;
    
    cnv.strokeWeight(press);
    // if too long check interpolation for long lines
              
    
    // println(vel);
    float vel = map(p.vel, 0, 100, 20, 340);
    //println(p.a);
    cnv.stroke(vel, 50, 80);
    cnv.line(mouseX-x, mouseY-y, pmouseX-x, pmouseY-y);
    // marks
    
    // TODO modulo according speed
    ///println(vel);
    if (points.size() % 30 == 0) {
     
      cnv.textFont(font, 15);
      // cnv.strokeWeight(10);
      //cnv.textSize(22);
      cnv.text(m, mouseX-x, mouseY-y);
      m++;
    } else {
      cnv.strokeWeight(4);
      cnv.point(mouseX-x, mouseY-y);
    }
    
    cnv.fill(0,0,0);    
    //
    cnv.noStroke();
    cnv.ellipse(250, 500, 6, 6);
    cnv.endDraw();
    image(cnv, x, y);
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
}
