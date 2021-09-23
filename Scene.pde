class Scene {
  // scene array
  String [] defaultScene = {"L", "R"};
  String [] defaultReverb = {"reverb_L", "reverb_R"};
  ArrayList<PImage> scene = new ArrayList<PImage>();
  ArrayList<PImage> sceneReverb = new ArrayList<PImage>();
  // blends
  PImage sceneB;
  PImage revB;
  PImage sceneRevB;

  Scene() {
    loadScene("default");
  }
  
  void loadScene(String name) {
    // load scene
    for(int i = 0; i< defaultScene.length ; i++){
      scene.add(loadImage("data/scenes/default/" + defaultScene[i] + ".png"));
      sceneReverb.add(loadImage("data/scenes/default/reverb_" + defaultScene[i] + ".png"));
    }
    
    sceneB = scene.get(0);
    //sceneB.filter(BLUR, 10);
    revB = sceneReverb.get(0);
    //revB.filter(BLUR, 10);
    
    for(int i = 1; i< scene.size() ; i++){
      sceneB.blend(scene.get(i), 0, 0, 500, 500, 0, 0, 500, 500, ADD);
      revB.blend(sceneReverb.get(i), 0, 0, 500, 500, 0, 0, 500, 500, ADD);
    }
    
    
    PGraphics p = createGraphics(500, 500);
    p.beginDraw();
    revB.filter(BLUR, 4);
    sceneB.filter(BLUR, 4);
    p.tint(0, 0, 100);
    p.image(revB, 0, 0);
    p.tint(180, 10, 10, 80);
    p.image(sceneB, 0, 0);
    p.endDraw();
    //sceneB = p;
    sceneRevB = p;
    //sceneRevB.blend(revB, 0, 0, 500, 500, 0, 0, 500, 500, ADD);
  }

  String getValuesAt(int x, int y) {
    return "";
  }
  
  String getReverbAt(int x, int y) {
    return "";
  }

  void displayScene(PGraphics c) {
   // println("DISPLAY thr SCENE");
   //c.tint(220, 90, 25, 20);
   c.image(sceneRevB, 0, 0);
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
  
}
