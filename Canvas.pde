


class Canvas {
  PVector location; 
  PVector size;
  ArrayList <PVector> points;
  PGraphics cnv;
  Tablet tablet;

  Canvas(PGraphics cnv, int x, int y, Tablet tablet) {
    //this.size = new PVector(w, h);
    this.location = new PVector(x, y);
    points = new ArrayList<PVector>();
    this.cnv = cnv;
    this.cnv.smooth(0);
    
    // tablet support
    this.tablet = tablet; 
    
    println(this.cnv);
  }

  void drawCanvas() {
    cnv.beginDraw();
    // cnv.fill(0, 100, 100);
    cnv.stroke(0);
    cnv.rect(0, 0, cnv.width-1, cnv.height-1);
    cnv.endDraw();
    image(cnv, 0, 0);
  }
  
  boolean isInsideCanvas() {
    
    if(mouseX > location.x && mouseX < location.x + size.x &&
       mouseY > location.y && mouseY < location.y + size.y
    ) {
      return true;
    }
    return false;
  }

  void drawPoint() {
    println();
    //if(isInsideCanvas()) {
      cnv.beginDraw();
      cnv.colorMode(HSB, 360, 100, 100, 100);
      // cnv.stroke(255);
      
      float velX = abs(mouseX-pmouseX);
      float velY = abs(mouseX-pmouseX);
      float vel = velX > velY ? velX : velY;
      float press = tablet.getPressure();
      cnv.strokeWeight(press * 15);
      // if too long check interpolation for long lines
      
      
      
      
      // println(vel);
      vel = map(vel, 0, 100, 20, 340);
      cnv.stroke(vel, 20, 80);
      cnv.line(mouseX, mouseY, pmouseX, pmouseY);  
      cnv.endDraw();
      image(cnv, 0, 0);
      points.add(new PVector(mouseX, mouseY, vel));
      
    //}  
  }

  void saveTrajectory() {
    String[] _points = new String[points.size()]; 

    for (int i = 0; i < points.size(); i++) {
      PVector point = points.get(i);
      _points[i] = point.x+","+point.y+","+point.z;
    }

    saveStrings("traj", _points);
  }
}
