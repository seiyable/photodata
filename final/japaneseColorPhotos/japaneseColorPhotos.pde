//============= notes =============
/*
This is a code for displaying a set of Japanese Traditional Colors
with photos downloaded from flickr each of which has the color in it.
By clicking your mouse on a photo, you can check the larger image.
*/

//=============== global variables ===============
Panel[] panels = new Panel[8];

int windowWidth = 1000, windowHeight = 400;
float imageWidth = windowWidth/4.0, imageHeight = windowHeight/2.0;
PFont myFont;
boolean displayWhole = false;
int displayPanelNum = 0;

//=============== setup() ===============
void setup() {
  size(windowWidth, windowHeight);

  Table table = loadTable("sourceList.csv", "header");
  myFont = loadFont("Serif-48.vlw");

  //set each photo data to array
  int counter = 0;
  for (TableRow row : table.rows ()) {
    String filename        = row.getString("filename");
    PImage img             = loadImage("../../photodata_final_photos/" + filename + ".jpg");
    String colorName_kanji = row.getString("colorName_kanji");
    String colorName_hira  = row.getString("colorName_hira");
    String colorName_en    = row.getString("colorName_en");
    String hex_jpn         = row.getString("hex_jpn");
    String hex_ori         = row.getString("hex_ori");
    PVector panelPos;
    if (counter < 4) {
      panelPos     = new PVector(imageWidth*counter, imageHeight*0);
    } else {
      panelPos     = new PVector(imageWidth*(counter%4), imageHeight*1);
    }
    panels[counter] = new Panel(filename, img, colorName_kanji, colorName_hira, colorName_en, hex_jpn, hex_ori, panelPos);
    counter++;
  }

  //set zoom level and position of each photo
  panels[0].cropImage(600, 300, 1.0);
  panels[1].cropImage(250, 400, 1.0);
  panels[2].cropImage(280, 250, 1.0);
  panels[3].cropImage(250, 450, 1.0);
  panels[4].cropImage(65, 400, 1.0);
  panels[5].cropImage(410, 240, 1.0);
  panels[6].cropImage(370, 140, 1.0);
  panels[7].cropImage(700, 340, 1.0);
}

//=============== draw() ===============
void draw() {
  background(0);
  if (!displayWhole) {
    for (Panel p : panels) {
      p.display();
    }
  } else {


    pushMatrix();
    PImage img = loadImage("../../photodata_final_photos/" + panels[displayPanelNum].filename + ".jpg");
    float s = height/float(img.height);
    scale(s);

    imageMode(CENTER);
    image(img, (width/2)/s, (height/2)/s);
    imageMode(CORNER);
    popMatrix();
  }
}

//=============== mousePressed() ===============
void mousePressed() {
  boolean done = false;

  for (int i = 0; i < panels.length; i++) {
    if (!done) { 
      Panel p = panels[i];

      if (!displayWhole) {
        if (mouseX > p.panelPos.x && mouseX < p.panelPos.x + imageWidth 
          && mouseY > p.panelPos.y && mouseY < p.panelPos.y + imageHeight) {
          displayWhole = true;
          displayPanelNum = i;

          done = true;
        }
      } else {
        displayWhole = false;
        done = true;
      }
    }
  }
}

//=============== keyPressed() ===============
void keyPressed() {
  if (key == ' ') {
    saveFrame("JapaneseTraditionalColors.png");
    println("PNG generated");
  }
}

