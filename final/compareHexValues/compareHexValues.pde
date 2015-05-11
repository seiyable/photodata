//============= notes =============
/*
This is a code for comparing colors between two data assets saved in CSV files.
 */

//============= global variables =============
Table table1, table2;
ArrayList<SimilarColor> sColors = new ArrayList<SimilarColor>();
VScrollbar vs;

//============= setup() =============
void setup() {
  size(500, 800);
  vs = new VScrollbar(width-10, 0, 20, height, 3*5+1);

  //load a CSV file
  table1 = loadTable("../../colorExtraction/data/photodata.csv", "header");
  table2 = loadTable("JapaneseTraditionalColors.csv", "header");

  int counter = 0;

  //check first table
  for (TableRow row1 : table1.rows ()) {
    String hex1     = row1.getString("hex");
    String filename = row1.getString("filename");
    String kind     = row1.getString("kind");
    int    percent  = int(row1.getFloat("percent"));

    hex1 = hex1.substring(1); //remove "#"
    hex1 = "FF" + hex1; //add alpha value
    color rgb1 = unhex(hex1);

    //check second table
    for (TableRow row2 : table2.rows ()) {
      String hex2      = row2.getString("hex");
      String colorName = row2.getString("name_kanji");

      hex2 = hex2.substring(1); //remove "#"
      hex2 = "FF" + hex2; //add alpha value
      color rgb2 = unhex(hex2);

      //if the two colors are similar, add them to arraylist
      float approx_range = 7.0;
      if ((abs(red(rgb1)   - red(rgb2))     < approx_range) &&
        (abs(green(rgb1) - green(rgb2))   < approx_range) && 
        (abs(blue(rgb1)  - blue(rgb2))    < approx_range)) {

        //if percent is heigher than 20%
        if(percent > 20){
          sColors.add(new SimilarColor(filename, kind, hex1, hex2, rgb1, rgb2, colorName, percent));
          counter++;
        }
      }
    }
  }

  println(counter + " colors added.");
  println("Done.");
}

//============= draw() =============
void draw() {
  background(200);

  float scrollbarPos = vs.getPos();
  float maxHeight = 30 + 30*sColors.size();
  
  pushMatrix();
  translate(0, -maxHeight*scrollbarPos/height);

  //labels
  fill(0);
  text("ori", 10, 20);
  text("jpn", 50, 20);
  text("filename", 90, 20);
  text("kind", 150, 20);
  text("percent", 230, 20);
  text("percent", 230, 20);
  text("hex value", 300, 20);

  int counter = 0;
  int posX = 0, rectW = 40, rectH = 30; 
  for (SimilarColor sColor : sColors) {
    //draw rectangles
    fill(sColor.original_rgb);
    rect(posX, 30 + rectH*counter, rectW, rectH);
    fill(sColor.japanese_rgb);
    rect(posX + rectW, 30 + rectH*counter, rectW, rectH);

    //write texts
    fill(0);
    text(sColor.filename + " " + sColor.kind, posX + rectW*2 + 10, 50 + rectH*counter);
    text(str(sColor.percent), posX + rectW*2 + 150, 50 + rectH*counter);
    text(sColor.original_hex + " " + sColor.japanese_hex + " " + sColor.colorName, posX + rectW*2 + 220, 50 + rectH*counter);

    counter++;
  }
  
  popMatrix();

  vs.update();
  vs.display();
}

