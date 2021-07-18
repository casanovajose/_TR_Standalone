// DRAG & MOVE WINDOWS

// Make the DIV element draggable:
dragElement(document.getElementById("window1"));

function dragElement(elmnt) {
  var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
  if (document.getElementById(elmnt.id + "-header")) {
    // if present, the header is where you move the DIV from:
    document.getElementById(elmnt.id + "-header").onmousedown = dragMouseDown;
  } else {
    // otherwise, move the DIV from anywhere inside the DIV:
    elmnt.onmousedown = dragMouseDown;
  }

  function dragMouseDown(e) {
    e = e || window.event;
    e.preventDefault();
    // get the mouse cursor position at startup:
    pos3 = e.clientX;
    pos4 = e.clientY;
    document.onmouseup = closeDragElement;
    // call a function whenever the cursor moves:
    document.onmousemove = elementDrag;
  }

  function elementDrag(e) {
    e = e || window.event;
    e.preventDefault();
    // calculate the new cursor position:
    pos1 = pos3 - e.clientX;
    pos2 = pos4 - e.clientY;
    pos3 = e.clientX;
    pos4 = e.clientY;
    // set the element's new position:
    elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
    elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
  }

  function closeDragElement() {
    // stop moving when mouse button is released:
    document.onmouseup = null;
    document.onmousemove = null;
  }
}

// UTILS

function renderSVGs(id, xml_string){
  var doc = new DOMParser().parseFromString(`<svg class="paths" xmlns="http://www.w3.org/2000/svg" width="400" height="400">${xml_string}</svg>`, 'application/xml');
  var el = document.getElementById(id)
  el.appendChild(
    el.ownerDocument.importNode(doc.documentElement, true)
  )
}

function removeAuxXml(id) {
  var el = document.getElementById(id)
  el.innerHTML = "";
}

function getPathPoints(path) {
  points = [];
  // TODO apply transformation
  path.forEach((point) => {
	  points.push(point.join(" "))
  });
  return points.join(",")
}

function calculatePathsPoints(className, resolution) {
  const svgs = document.getElementsByClassName(className);
  const paths = [];
  
  Array.from(svgs).forEach((svg) => {
    const path = svg.getElementsByTagName("path")[0];
    const pathLength = Math.floor(path.getTotalLength());
    const res = pathLength / resolution;
    const pointsPath = [];
    for (let i = 0; i <= resolution; i++) {
      const pt = path.getPointAtLength(i*res);
      pt.x = Math.round(pt.x);
      pt.y = Math.round(pt.y);
      pointsPath.push({x: pt.x, y: pt.y});
    }
    // console.log("res ", res);
    // console.log("PATHS res ", pointsPath);
    paths.push(pointsPath);
  });

  return paths;
}

function drawPathPoints(canvas, points) {
  points.forEach(function(point, index) {
    const circle = new fabric.Circle({
      radius: 2,
      fill: 'none',
      left: point.x,
      top: point.y,
      originX: 'center',
      originY: 'center',
      hasBorders: true,
      hasControls: false,
      name: index
    });
    canvas.add(circle);
  });
}

// THE CANVASes CODE
(function() {
  const $ = function(id){return document.getElementById(id)};
  let currentPoints = [];
  let currentSVGs = [];

  const canvas = this.__canvas = new fabric.Canvas('c', {
    isDrawingMode: true,
    width: 400,
    height: 400,
    skipOffScreen: true
  });

  fabric.Object.prototype.transparentCorners = false;
  // buttons
  const compileEl = $('compile'),
    //drawingOptionsEl = $('drawing-mode-options'),
    //drawingColorEl = $('drawing-color'),
    clearEl = $('clear-canvas')
    saveEl = $('traj_save');
    resolutionEl = $('resolution');
    onMessageEl = $("on_message"); 
    offMessageEl = $("off_message");
    srcEl = $("traj_src");
    titleEl = $("traj_title");

  // clear the canvas
  clearEl.onclick = function() { 
    canvas.clear() 
  };
  
  // save the path
  compileEl.onclick = function() {
    // refresh resolution points
    currentSVGs = [];
    currentPoints = [];
    canvas.remove(...canvas.getObjects("circle"));

    const objects = canvas.getObjects("path");
    // add paths svgs to limboc
    let svgString = "";
    objects.forEach((svg) => {
      svgString= svg.toSVG();
      renderSVGs("limbo", svgString);
      currentSVGs.push(svgString);
    });
    
    // get the resolution points
    const pointsArray = calculatePathsPoints("paths", resolutionEl.value);
    currentPoints = pointsArray;
    // draw resolution points
    pointsArray.forEach((points) => {
      drawPathPoints(canvas, points);
    });
    
    // clean limbo
    removeAuxXml("limbo");
    // object.on("modified", function(a) { 
    // });
    
    // console.log("paths",  getPathPoints(object.path));
  };

  saveEl.onclick = function() {
    axios.post('http://localhost:8666/traj', {
      onMessage: onMessageEl.checked || false,
      offMessage: offMessageEl.checked || false,
      source: srcEl.value,
      title: titleEl.value,
      svg: currentSVGs,
      points: currentPoints
    })
    .then(function (response) {
      console.log(response);
    })
    .catch(function (error) {
      console.log(error);
    });
  }

  // activate drawing mode
  // drawingModeEl.onclick = function() {
  //   canvas.isDrawingMode = !canvas.isDrawingMode;
  //   if (canvas.isDrawingMode) {
  //     drawingModeEl.innerHTML = 'Enter edit mode';
  //     //drawingOptionsEl.style.display = '';
  //   }
  //   else {
  //     drawingModeEl.innerHTML = 'Enter drawing mode';
  //     //drawingOptionsEl.style.display = 'none';
  //   }
  // };

//   if (fabric.PatternBrush) {
//     var vLinePatternBrush = new fabric.PatternBrush(canvas);
//     vLinePatternBrush.getPatternSrc = function() {

//       var patternCanvas = fabric.document.createElement('canvas');
//       patternCanvas.width = patternCanvas.height = 10;
//       var ctx = patternCanvas.getContext('2d');

//       ctx.strokeStyle = this.color;
//       ctx.lineWidth = 5;
//       ctx.beginPath();
//       ctx.moveTo(0, 5);
//       ctx.lineTo(10, 5);
//       ctx.closePath();
//       ctx.stroke();

//       return patternCanvas;
//     };

//     var hLinePatternBrush = new fabric.PatternBrush(canvas);
//     hLinePatternBrush.getPatternSrc = function() {

//       var patternCanvas = fabric.document.createElement('canvas');
//       patternCanvas.width = patternCanvas.height = 10;
//       var ctx = patternCanvas.getContext('2d');

//       ctx.strokeStyle = this.color;
//       ctx.lineWidth = 5;
//       ctx.beginPath();
//       ctx.moveTo(5, 0);
//       ctx.lineTo(5, 10);
//       ctx.closePath();
//       ctx.stroke();

//       return patternCanvas;
//     };

//     var squarePatternBrush = new fabric.PatternBrush(canvas);
//     squarePatternBrush.getPatternSrc = function() {

//       var squareWidth = 10, squareDistance = 2;

//       var patternCanvas = fabric.document.createElement('canvas');
//       patternCanvas.width = patternCanvas.height = squareWidth + squareDistance;
//       var ctx = patternCanvas.getContext('2d');

//       ctx.fillStyle = this.color;
//       ctx.fillRect(0, 0, squareWidth, squareWidth);

//       return patternCanvas;
//     };

//     var diamondPatternBrush = new fabric.PatternBrush(canvas);
//     diamondPatternBrush.getPatternSrc = function() {

//       var squareWidth = 10, squareDistance = 5;
//       var patternCanvas = fabric.document.createElement('canvas');
//       var rect = new fabric.Rect({
//         width: squareWidth,
//         height: squareWidth,
//         angle: 45,
//         fill: this.color
//       });

//       var canvasWidth = rect.getBoundingRect().width;

//       patternCanvas.width = patternCanvas.height = canvasWidth + squareDistance;
//       rect.set({ left: canvasWidth / 2, top: canvasWidth / 2 });

//       var ctx = patternCanvas.getContext('2d');
//       rect.render(ctx);

//       return patternCanvas;
//     };

//     var img = new Image();
//     img.src = '../assets/honey_im_subtle.png';

//     var texturePatternBrush = new fabric.PatternBrush(canvas);
//     texturePatternBrush.source = img;
//   }

//   $('drawing-mode-selector').onchange = function() {

//     if (this.value === 'hline') {
//       canvas.freeDrawingBrush = vLinePatternBrush;
//     }
//     else if (this.value === 'vline') {
//       canvas.freeDrawingBrush = hLinePatternBrush;
//     }
//     else if (this.value === 'square') {
//       canvas.freeDrawingBrush = squarePatternBrush;
//     }
//     else if (this.value === 'diamond') {
//       canvas.freeDrawingBrush = diamondPatternBrush;
//     }
//     else if (this.value === 'texture') {
//       canvas.freeDrawingBrush = texturePatternBrush;
//     }
//     else {
//       canvas.freeDrawingBrush = new fabric[this.value + 'Brush'](canvas);
//     }

//     if (canvas.freeDrawingBrush) {
//       var brush = canvas.freeDrawingBrush;
//       brush.color = drawingColorEl.value;
//       if (brush.getPatternSrc) {
//         brush.source = brush.getPatternSrc.call(brush);
//       }
//       brush.width = parseInt(drawingLineWidthEl.value, 10) || 1;
//       brush.shadow = new fabric.Shadow({
//         blur: parseInt(drawingShadowWidth.value, 10) || 0,
//         offsetX: 0,
//         offsetY: 0,
//         affectStroke: true,
//         color: drawingShadowColorEl.value,
//       });
//     }
//   };

//   drawingColorEl.onchange = function() {
//     var brush = canvas.freeDrawingBrush;
//     brush.color = this.value;
//     if (brush.getPatternSrc) {
//       brush.source = brush.getPatternSrc.call(brush);
//     }
//   };
//   drawingShadowColorEl.onchange = function() {
//     canvas.freeDrawingBrush.shadow.color = this.value;
//   };
//   drawingLineWidthEl.onchange = function() {
//     canvas.freeDrawingBrush.width = parseInt(this.value, 10) || 1;
//     this.previousSibling.innerHTML = this.value;
//   };
//   drawingShadowWidth.onchange = function() {
//     canvas.freeDrawingBrush.shadow.blur = parseInt(this.value, 10) || 0;
//     this.previousSibling.innerHTML = this.value;
//   };
//   drawingShadowOffset.onchange = function() {
//     canvas.freeDrawingBrush.shadow.offsetX = parseInt(this.value, 10) || 0;
//     canvas.freeDrawingBrush.shadow.offsetY = parseInt(this.value, 10) || 0;
//     this.previousSibling.innerHTML = this.value;
//   };

//   if (canvas.freeDrawingBrush) {
//     canvas.freeDrawingBrush.color = drawingColorEl.value;
//     canvas.freeDrawingBrush.source = canvas.freeDrawingBrush.getPatternSrc.call(this);
//     canvas.freeDrawingBrush.width = parseInt(drawingLineWidthEl.value, 10) || 1;
//     canvas.freeDrawingBrush.shadow = new fabric.Shadow({
//       blur: parseInt(drawingShadowWidth.value, 10) || 0,
//       offsetX: 0,
//       offsetY: 0,
//       affectStroke: true,
//       color: drawingShadowColorEl.value,
//     });
//   }
})();
