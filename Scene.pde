class Scene {
  
  Scene() {
  
  }
  
  void loadScene(String name) {
  
  }

  String getValuesAt(int x, int y) {
    return "";
  }
  
  String getReverbAt(int x, int y) {
    return "";
  }

  void displayScene() {
   // scene 
   for(int i = 0; i< defaultScene.length ; i++){
      tint(255, 10);
      image(scene.get(i), cOffX, cOffY);
      noTint();
     // sceneReverb.add(loadImage("data/scenes/default/" + defaultScene[i] + ".png"));
   }
   
   // reverb
   for(int i = 0; i< defaultScene.length ; i++){
     // scene.add(loadImage("data/scenes/default/" + defaultScene[i] + ".png"));
     // sceneReverb.add(loadImage("data/scenes/default/" + defaultScene[i] + ".png"));
    }
  }
  
}
