import oscP5.*;

class Point {
  int x;
  int y;
  int px;
  int py;
  //
  int ox;
  int oy;
  //
  int vel;
  int press;
  //
  float[] dist;
  float[] rev;
  //double a;
  //int dist;
  String cmd;
  
  Point(int x, int y, int px, int py, int offsetX, int offsetY) {
    this.x = x;
    this.y = y;
    this.ox = offsetX;
    this.oy = offsetY;
    this.px = px;
    this.py = py;
    this.cmd = "_";
    this.calcVel();    
    // this.calcAngDist();
  }
  
  void setValues(float[] val) {
    this.dist = subset(val, 0, val.length/2);
    this.rev = subset(val, val.length/2, val.length/2);
    //println(this.rev);
  }
  
  String toString() {
    return x+","+y+","+vel+","+cmd ;
    
  }
  
  OscBundle toBundle() {
    OscBundle b = new OscBundle();
    OscMessage msg = new OscMessage("/x"); 
    msg.add(x); b.add(msg); msg.clear();
    msg.setAddrPattern("/y"); msg.add(y); b.add(msg); msg.clear();
    // dist + rev
    msg.setAddrPattern("/scene"); msg.add(dist); b.add(msg); msg.clear();
    
    msg.setAddrPattern("/rev"); msg.add(rev); b.add(msg); msg.clear();
    return b;
  }
  
  void calcVel () {
    float velX = abs(x-px);
    float velY = abs(y-py);
    this.vel = int((velX + velY) / 2);
  }
  
  /**
  * Converts cartesian to polar
  */
  void calcAngDist () {
    //this.a = abs( (float)Math.toDegrees(Math.atan2(y-oy, x-ox)));
    //this.dist = (int) Math.sqrt(ox*ox + oy*oy);
  }
  
  /**
  * cmd is intended for Trajectory level in order to add messages like ON / OFF in OSC Bundles
  */
  void setCmd(String msg) {
    this.cmd = msg;
  }
}
