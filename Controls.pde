import controlP5.*;

public static class Controls {
  final static int colUp = 80;
  final static int column = 530;
  final static int row = 50;
  final static int itmHeight = 22;
  final static int itmWidth = 160;
  
  
  public static void config(ControlP5 c, PFont f) {
    //ControlFont.sharp();
    ControlFont ff = new ControlFont(f, 12);
    //ff.RENDER_2X = true;
    c.setFont(ff);  
    // change the original colors
    c.setColorForeground(0x0050E320);
    c.setColorBackground(0xff224422);
    c.setColorCaptionLabel(0xff00e300);
    //c.setColor(new CColor());
    c.setColorActive(0xff00e300); 
  }
  
    
    
  public static RadioButton  getRadioOptions(ControlP5 c, String name , String path, String ext,  boolean withNew, String selected, int r) {
    String [] items = getFileList(path, ext, withNew);
    RadioButton  ddl = c.addRadioButton (name)
            .setPosition(column ,r*row)
            //.addItems(items)
            //.setSize(itmWidth, 200)
            .setItemHeight(itmHeight-10)
            .setNoneSelectedAllowed(false)
            .toUpperCase(true)
            //.setBarHeight(itmHeight)
            //.setBarVisible(true)
            //.setOpen(false)            
            ;    
    
    for(int i = 0; i < items.length; i++) {
      ddl.addItem(items[i], i);
    }
    ddl.activate(selected);
    return ddl;
  }
  
  public static RadioButton  getRadioFixedOptions(ControlP5 c, String name , String [] items, String selected, int col, int r, int offsetY) {    
    RadioButton  ddl = c.addRadioButton (name)
            .setPosition(col ,r*row+offsetY)
            //.addItems(items)
            .setSize(10,10)
            .setItemHeight(itmHeight-10)
            .setNoneSelectedAllowed(false)
            .toUpperCase(true)
            //.setBarHeight(itmHeight)
            //.setBarVisible(true)
            //.setOpen(false)            
            ;    
    
    for(int i = 0; i < items.length; i++) {
      ddl.addItem(items[i], i);
    }
    ddl.activate(selected);
    return ddl;
  }
  
  public static Button getButton(ControlP5 c, String name, PImage def, PImage active, int col, int r, int offsetY) {
    Button b = c.addButton(name)
      .setPosition(col ,r*row+offsetY)
      .setSize(25, 25)
      .updateSize()
      
    ;
    if (def != null){
      b.setImage(def, Controller.DEFAULT);
      b.setImage(active, Controller.ACTIVE);
    }
    return b;
  }
  
  public static Textfield getTextInput(ControlP5 c, String name, int r) {
    Textfield t = c.addTextfield(name)
      .setPosition(column, r*row)
      .setSize(itmWidth, itmHeight)
    ;    
    return t;
  }
  
  public static Slider getSliderH(ControlP5 c, String name, float min, float max, int col, int r, int offsetY) {
    Slider s = c.addSlider(name)
      .setPosition(col, row*r+offsetY)
      .setRange(min , max)
      .setScrollSensitivity(0.01)
      .setSize(itmWidth, itmHeight)
      ;
    return s;
  }
  
  public static Toggle getSwitch(ControlP5 c, String name, int col, int r, int offsetY) {
    Toggle ch = c.addToggle(name)
      .setPosition(col, row*r+offsetY)
      .setSize(15, 15)
      .setValue(false)
      //.isLabelVisible(false)
      .setCaptionLabel("l") 
      ;
    return ch;
  }
    
  //----------------
  //---------- utils
  //----------------
  public static String[] getFileList(String path, String ext, boolean withNew) {
    java.io.File folder = new java.io.File(path);
    String[] filenames = {};
    if (withNew) { 
      filenames = append(filenames, "<NEW>");
    } 
    
    for (String file :  folder.list()) {
        // Check if string ends with extension
        if (file.endsWith(ext)) {
          filenames = append(filenames, file.replace(".tr", ""));        
        }
    }
    
    return filenames;
  }
}
