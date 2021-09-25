import controlP5.*;

public static class Controls {
  final static int column = 570;
  final static int row = 50;
  
  
  public static void config(ControlP5 c, PFont f) {
    c.setFont(f, 13);  
    // change the original colors
    c.setColorForeground(0x0050E320);
    c.setColorBackground(0xff224422);
    c.setColorCaptionLabel(0xff00e300);
    //c.setColor(new CColor());
    c.setColorActive(0xff00e300); 
    
  }
  
  public static DropdownList getTrajDropdown(ControlP5 c, String path, int r) {
    String [] items = getTrajList(path);
    DropdownList ddl = c.addDropdownList("trajList")
            .setPosition(column ,r*row)
            .addItems(items)
            .setSize(150, 200)
            .setItemHeight(20)
            .setBarHeight(20)
            .setBarVisible(true)
            .setOpen(false)
            //.setValueLabel("<NEW>")
            ;    
    
    ddl.setCaptionLabel("<NEW>");    
    return ddl;
  }
  
  public static Button getButton(ControlP5 c, String name,String i, int col, int r) {
    Button b = c.addButton(name)
      .setPosition(column + col ,r*row)
      .setSize(42, 25)
    ;    
    return b;
  }
  
  
  //---------- utils
  
  
  
    public static DropdownList getSceneDropdown(ControlP5 c, String path, int r) {
    String [] items = getSceneList(path);
    DropdownList ddl = c.addDropdownList("sceneList")
            .setPosition(column ,r*row)
            .addItems(items)
            .setSize(150, 200)
            .setItemHeight(20)
            .setBarHeight(20)
            .setBarVisible(true)
            .setOpen(false)
            
            ;    
    
    ddl.setCaptionLabel("DEFAULT");    
    return ddl;
  }
  
  
  public static String[] getTrajList(String path) {
    java.io.File folder = new java.io.File(path+"/traj");
    String[] filenames = {"<new>"};
    
    for (String file :  folder.list()) {
        // Check if string ends with extension
        if (file.endsWith(".tr")) {
          filenames = append(filenames, file);        
        }
    }
    
    return filenames;
  }
  
   public static String[] getSceneList(String path) {
    java.io.File folder = new java.io.File(path+"/data/scenes");
    String[] filenames = {};
    
    for (String file :  folder.list()) {
        // Check if string ends with extension
        //if (file.endsWith(".tr")) {
          filenames = append(filenames, file);        
        //}
    }
    
    return filenames;
  }
  


}
