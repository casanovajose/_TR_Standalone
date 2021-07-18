const { Bundle, Client } = require("node-osc");
const express = require('express');
const cors = require('cors');

const app = express()
app.use(express.json());
app.use(cors());

const config = {
  resolution: 1000,
  mode: "S",
  port: 8666,
  host: "127.0.0.1",
  osc: {
    port: 666,
    host: "127.0.0.1"
  }
}

let traj = [];
let tempo = 1000; // in ms

app.post('/traj', (req, res) => {
  traj = calculateTraj(req.body.points[0]);
  tempo = req.body.tempo*1000; // compute interval in ms
  res.send('');
})

app.listen(config.port, () => {
  console.log(`_TR waiting for orders at ${config.host}:${config.port}`)
})

const client = new Client("127.0.0.1", config.osc.port || 666);
const trajectories = {}

// math
function calcAngleDegrees(x, y) {
return Math.atan2(y, x) * 180 / Math.PI;
}

//const createTrajectory

function linspace(a,b,n) {
    if(typeof n === "undefined") n = Math.max(Math.round(b-a)+1,1);
    if(n<2) { return n===1?[a]:[]; }
    var i,ret = Array(n);
    n--;
    for(i=n;i>=0;i--) { ret[i] = (i*b+(n-i)*a)/n; }
    return ret;
}

function circle (radius, steps, centerX, centerY){
    const traj = []
    var xValues = [centerX];
    var yValues = [centerY];
    for (var i = 0; i < steps; i++) {
        const point = {}
        point.x = Math.round((centerX + radius * Math.cos(2 * Math.PI * i / steps)));
        point.y = Math.round((centerY + radius * Math.sin(2 * Math.PI * i / steps)));
        // pan
        point.angle =  Math.abs(Math.atan2(point.y - radius, point.x - radius) * (180 / Math.PI)); // in radians
        //point.r = point.x /  (2*radius);
        //point.l = 1 - point.x / (2*radius)
        // dist
        point.amp  =   (2*radius) - point.y;
        traj.push(point)
        
    }
    //console.log(traj);
    return traj;
}

// console.log();
function calculateTraj(points, on = false, off = false) {
  return points.map((p) => {

    const point = {
      x: p.x,
      y: p.y,
      spd: 1,
      angle: Math.abs(Math.atan2(p.y - 400, p.x - 200) * (180 / Math.PI)),
      dist: 400 - p.y
    }
    if (on) {
      point.on = on;
    }
    if (off) {
      point.off = off;
    }

    return point;
  });

}

let i = 0;
let j = 0;
//const traj = circle(190, 300, 200, 200);

let del = 50;
function readTraj() {
  if (traj.length > 0) {
    const data = [
      ["/x", traj[i].x], ["/y", traj[i].y], ["/dist", traj[i].dist], ["/ang", traj[i].angle]
    ]
    // const data = [["/
    if (traj[i].on) {
        data.push(["/on"])
    }
    
    if (traj[i].on) {
        data.push(["/off"]);
    }
       

    // console.log(j);
    // a bundle without an explicit time tag
    const bundle = new Bundle(...data);
    client.send(bundle);
    console.log(data)
    
    i = (i+1)% (traj.length);
  // console.log("i ", i)
  }
  console.log("tempo ", tempo);  
  setTimeout(readTraj, tempo);
}
readTraj()





// a bundle with a timetag of 10
// bundle.append(new Bundle(10, ["/note", 440]));

