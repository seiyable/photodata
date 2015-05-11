class Panel {
  //=============== in-class variables ===============
  String  filename;
  PImage  img;
  String  colorName_kanji;
  String  colorName_hira;
  String  colorName_en;
  String  hex_jpn;
  String  hex_ori;
  color   rgb_jpn;
  color   rgb_ori;
  PVector panelPos;
  PVector cropPos;
  float   zoomLevel;
  boolean whole;

  //=============== constructor ===============
  Panel(
  String  _filename, 
  PImage  _img, 
  String  _colorName_kanji, 
  String  _colorName_hira, 
  String  _colorName_en, 
  String  _hex_jpn, 
  String  _hex_ori, 
  PVector _panelPos
    ) {
    filename        = _filename;
    img             = _img;
    colorName_kanji = _colorName_kanji;
    colorName_hira  = _colorName_hira;
    colorName_en    = _colorName_en;
    hex_jpn         = _hex_jpn;
    hex_ori         = _hex_ori;
    rgb_jpn         = unhex("FF" + hex_jpn.substring(1));
    rgb_ori         = unhex("FF" + hex_jpn.substring(1));
    panelPos        = _panelPos;
    cropPos         = new PVector(0, 0);
    zoomLevel       = 1.0;
    whole           = false;
  }

  //=============== display() ===============
  void display() {
    //PImage croppedImage = img.get(int(cropPos.x/zoomLevel), int(cropPos.y/zoomLevel), int(imageWidth/zoomLevel), int(imageHeight/zoomLevel));
    
    pushMatrix();
    translate(panelPos.x, panelPos.y);
    scale(zoomLevel);
    image(img, 0, 0);
    
    textAlign(CENTER);
    textSize(48);
    textFont(myFont);
    text(colorName_kanji, imageWidth/2, imageHeight/2 + 15);
    textSize(20);
    
    text(colorName_en, imageWidth/2, imageHeight/2 + 45);
    popMatrix();
  }
  
  //=============== cropImage() ===============
  void cropImage(float _cropPosX, float _cropPosY, float _zoomLevel){
    cropPos.set(_cropPosX, _cropPosY);
    zoomLevel = _zoomLevel;
    
    PImage croppedImage = img.get(int(cropPos.x/zoomLevel), int(cropPos.y/zoomLevel), int(imageWidth/zoomLevel), int(imageHeight/zoomLevel));
    img = croppedImage;
  }
}

