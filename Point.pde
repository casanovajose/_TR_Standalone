
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
  float press = 0;
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
    String d = join(nf(dist), " ");
    String r = join(nf(rev), " ");
    println(press);
    return x+" "+y+" "+vel+" "+press+" "+cmd+" "+ d + " "+ r +";" ;    
  }
  
  OscBundle toBundle() {
    OscBundle b = new OscBundle();
    OscMessage msg = new OscMessage("/x"); 
    msg.add(x); b.add(msg); msg.clear();
    msg.setAddrPattern("/y"); msg.add(y); b.add(msg); msg.clear();
    msg.setAddrPattern("/vel"); msg.add(vel); b.add(msg); msg.clear();
    msg.setAddrPattern("/press"); msg.add(press); b.add(msg); msg.clear();
    msg.setAddrPattern("/cmd"); msg.add(cmd); b.add(msg); msg.clear();
    // dist + rev
    msg.setAddrPattern("/scene"); msg.add(this.dist); b.add(msg); msg.clear();    
    msg.setAddrPattern("/rev"); msg.add(this.rev); b.add(msg); msg.clear();
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
