class Scene {
  int speakers;
  // scene array
  String [] defaultScene = {"L", "R"};
  String [] defaultReverb = {"reverb_L", "reverb_R"};
  ArrayList<PImage> scene = new ArrayList<PImage>();
  ArrayList<PImage> sceneReverb = new ArrayList<PImage>();
  // blends
  PImage sceneB;
  PImage revB;
  PImage sceneRevB;
  PImage sceneMap = null;

  Scene() {
    loadScene("stereo_LR");
  }
  
  void loadScene(String name) {
    try {
      sceneMap = loadImage("scenes/"+name+"/map.png");
    } catch (Exception e) {
      e.printStackTrace();
    }
    // load scene
    String [] files = this.getFileList(sketchPath() +"/data/scenes/" + name);
    for(int i = 0; i< files.length ; i++){
      if (files[i].startsWith("reverb")) {
        sceneReverb.add(loadImage("data/scenes/"+name+"/" + files[i]));
      } else {
        scene.add(loadImage("data/scenes/"+name+"/" + files[i]));
      }     
      
    }
    speakers = scene.size();
    println(scene.size());
    sceneB = scene.get(0).copy();
    //sceneB.filter(BLUR, 10);
    revB = sceneReverb.get(0).copy();
    //revB.filter(BLUR, 10);
    
    for(int i = 1; i< scene.size() ; i++){
      sceneB.blend(scene.get(i), 0, 0, 500, 500, 0, 0, 500, 500, ADD);
      revB.blend(sceneReverb.get(i), 0, 0, 500, 500, 0, 0, 500, 500, ADD);
    }
    
    // visual
    PGraphics p = createGraphics(500, 500);
    p.beginDraw();
    revB.filter(BLUR, 2);
    sceneB.filter(BLUR, 2);
    p.tint(0, 0, 100);
    p.image(revB, 0, 0);
    p.tint(180, 50, 20, 60);
    p.image(sceneB, 0, 0);
    p.noTint();
    //p.image(sceneReverb.get(1),0,0);
    if(sceneMap != null) {
      p.image(sceneMap, 0, 0);
      //tint(43, 100, 100);
    }
   // p.image(sceneReverb.get(1), 0, 0);
    p.endDraw();
    //sceneB = p;
    sceneRevB = p;
    //sceneRevB.blend(revB, 0, 0, 500, 500, 0, 0, 500, 500, ADD);
  }

  float[] getValuesAt(int x, int y) {
    float [] val = new float [scene.size()*2];
    for(int i = 0; i< scene.size() ; i++){
      val [i] = brightness(scene.get(i).get(x, y));
      val [speakers+i] = brightness(sceneReverb.get(i).get(x, y));
      //val [speakers+i] = ;
      
    }
    return val;
  }
  
  String getReverbAt(int x, int y) {
    return "";
  }

  void displayScene(PGraphics c) {
   // println("DISPLAY thr SCENE");
   //c.tint(220, 90, 25, 20);
   // c.image(sceneRevB, 0, 0);
   c.image(scene.get(1), 0, 0);
   
   //c.noTint();
   //c.tint(0, 90, 25, 20);
   //c.image(revB, 0, 0);
   //c.noTint();
   //for(int i = 0; i< sceneReverb.size() ; i++){
   //   c.tint(220, 90, 25, 20);
   //   c.image(sceneReverb.get(i), 0, 0);
   //   c.noTint();
   //  // sceneReverb.add(loadImage("data/scenes/default/" + defaultScene[i] + ".png"));
   //}
   //// scene 
   //for(int i = 0; i< scene.size() ; i++){
   //   c.tint(0, 90, 25, 20);
   //   c.image(scene.get(i), 0, 0);
   //   c.noTint();
   //  // sceneReverb.add(loadImage("data/scenes/default/" + defaultScene[i] + ".png"));
   //}   
   
  }
  
  
  public String[] getFileList(String path) {
    java.io.File folder = new java.io.File(path);
    String[] filenames = {};
    
    for (String file :  folder.list()) {
        // Check if string ends with extension
        if (!file.startsWith("map")) {
          filenames = append(filenames, file);        
        }
    }
    
    return filenames;
  }
}
