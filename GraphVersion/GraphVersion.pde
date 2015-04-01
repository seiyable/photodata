//=============== global variables ===============
import java.text.SimpleDateFormat;
import java.util.Date;

ArrayList<Photo> photos = new ArrayList<Photo>(); //storing all the photo data
ArrayList<int[]> photoCounts = new ArrayList<int[]>(); //how many photos taken on each day
int[] graphOnOff = {1, 1, 1, 1, 1, 1, 1};

//=============== setup() ===============
void setup() {
  size(1400, 400);
  colorMode(HSB, 360, 100, 100);

  //add arrays of Sun ~ Sat photo count  
  for(int i = 0; i < 7; i++){
    int[] pCountOnTheDay = new int[24*6];
    photoCounts.add(pCountOnTheDay);
  }

  //import csv
  Table dateTable = loadTable("datetime.csv", "header");
  println(dateTable.getRowCount() + " total rows in table");

  //store all the rows in the csv into an arraylist ----------------------------
  for (TableRow row : dateTable.rows ()) {
    String filename     = row.getString("filename");
    String datetime     = row.getString("datetime");
    String latitude     = row.getString("latitude");
    String latitudeRef  = row.getString("latitudeRef");
    String longitude    = row.getString("longitude");
    String longitudeRef = row.getString("longitudeRef");

    //convert the datetime string to java date format
    //if it cannot make it, skip adding it to the arraylist
    try {
      //parse date time
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy:MM:dd HH:mm:ss");
      Date parsedDatetime = sdf.parse(datetime);

      countUpThePhoto(parsedDatetime);

      //add new Photo instance to the arraylist
      photos.add(new Photo(filename, parsedDatetime, latitude, latitudeRef, longitude, longitudeRef));
    } 
    catch (Exception e) { 
      println("Unable to parse date stamp of the " + filename);
      //do nothing
    }
  } //----------------------------------------------------------------------------
}

//=============== draw() ===============
void draw() {
  background(100);
  displayLabels();
  drawGraph();
}

//=============== countUpThePhoto() ===============
void countUpThePhoto(Date _parsedDatetime) {
  //check the day of the week
  int day = _parsedDatetime.getDay();

  //check the hour
  int   hour     = _parsedDatetime.getHours();
  float minute   = _parsedDatetime.getMinutes();
  int   minute10 = round(minute/6.0); //0 ~ 6

  //increment the photo count of the day
  photoCounts.get(day)[hour*6 + minute10]++;

}

//=============== displayLabels() ===============
void displayLabels() {

  //color code for each day
  textSize(18);
  
  int bri = 100;
  if(graphOnOff[0] < 0) bri = 20;
  fill(360*1/7, 100, bri);
  text("Sun", 20, 30);

  bri = 100;
  if(graphOnOff[1] < 0) bri = 20;
  fill(360*2/7, 100, bri);
  text("Mon", 20, 50);

  bri = 100;
  if(graphOnOff[2] < 0) bri = 20;
  fill(360*3/7, 100, bri);
  text("Tue", 20, 70);

  bri = 100;
  if(graphOnOff[3] < 0) bri = 20;
  fill(360*4/7, 100, bri);
  text("Wed", 20, 90);

  bri = 100;
  if(graphOnOff[4] < 0) bri = 20;
  fill(360*5/7, 100, bri);
  text("Thu", 20, 110);

  bri = 100;
  if(graphOnOff[5] < 0) bri = 20;
  fill(360*6/7, 100, bri);
  text("Fri", 20, 130);

  bri = 100;
  if(graphOnOff[6] < 0) bri = 20;
  fill(360*7/7, 100, bri);
  text("Sat", 20, 150);

  //axis
  stroke(0, 0, 100);
  line(80, 20, 80, height-50);
  line(80, height-50, width-80, height-50);

  //time
  textSize(10);
  fill(0, 0, 100);
  text("0", 77, height-30);
  text("24", width-83, height-30);
  text("12", (77 + width-83)/2, height-30);
}

//=============== drawGraph() ===============
void drawGraph() {
  //get the world record to determine the height of the graph
  int maxSun = getTheLargestValueOfTheArray(photoCounts.get(0));
  int maxMon = getTheLargestValueOfTheArray(photoCounts.get(1));
  int maxTue = getTheLargestValueOfTheArray(photoCounts.get(2));
  int maxWed = getTheLargestValueOfTheArray(photoCounts.get(3));
  int maxThu = getTheLargestValueOfTheArray(photoCounts.get(4));
  int maxFri = getTheLargestValueOfTheArray(photoCounts.get(5));
  int maxSat = getTheLargestValueOfTheArray(photoCounts.get(6));
  int[] maxArray = {
    maxSun, maxMon, maxTue, maxWed, maxThu, maxFri, maxSat
  };
  int worldRecord = getTheLargestValueOfTheArray(maxArray); 
  ///println("The world record is " + worldRecord);

  noStroke();
  float min10Width = (width-160)/(24*6.0);
  for (int d = 0; d < photoCounts.size(); d++) {
    int[] day = photoCounts.get(d);
    ArrayList<PVector> dots = new ArrayList<PVector>(); //storing dots to be connected to draw lines

    for (int i = 0; i < 24*6; i++) {  
      float xPos = 80 + min10Width*i;
      float yPos = day[i];
      yPos = map(yPos, 0, worldRecord, height-50, 20);
      PVector dot = new PVector(xPos, yPos);
      dots.add(dot);
    }

    //deterimine the color of the line
    switch(d) {
    case 0:
      stroke(360*1/7, 100, 100);
      break;
    case 1:
      stroke(360*2/7, 100, 100);
      break;
    case 2:
      stroke(360*3/7, 100, 100);
      break;
    case 3:
      stroke(360*4/7, 100, 100);
      break;
    case 4:  
      stroke(360*5/7, 100, 100);
      break;
    case 5:
      stroke(360*6/7, 100, 100);
      break;
    case 6:
      stroke(360*7/7, 100, 100);
      break;
    }
    
    
    if(graphOnOff[d] > 0){
      //draw lines
      connectDots(dots);
    }
  }
}

//=============== getTheLargestValueOfTheArray() ===============
int getTheLargestValueOfTheArray(int[] _array) {
  int largestValue = 0;
  for (int i = 0; i < _array.length; i++) {
    if (_array[i] > largestValue) {
      largestValue = _array[i];
    }
  }
  return largestValue;
}

//=============== connectDots() ===============
void connectDots(ArrayList<PVector> _dots){
  for (int i = 0; i < _dots.size() - 1; i++){
    PVector startDot = _dots.get(i);
    PVector endDot   = _dots.get(i+1);
    line(startDot.x, startDot.y, endDot.x, endDot.y);
  }
}

//=============== mousePressed() ===============
void mousePressed() {
  if(mouseX > 20 && mouseX < 60 && mouseY > 13 && mouseY < 33){
    //Sun
    graphOnOff[0] = graphOnOff[0] * (-1); //trigger on and off
    
  } else if (mouseX > 20 && mouseX < 60 && mouseY > 33 && mouseY < 53){
    //Mon
    graphOnOff[1] = graphOnOff[1] * (-1); //trigger on and off
    
  } else if (mouseX > 20 && mouseX < 60 && mouseY > 53 && mouseY < 73){
    //Tue
    graphOnOff[2] = graphOnOff[2] * (-1); //trigger on and off
    
  } else if (mouseX > 20 && mouseX < 60 && mouseY > 73 && mouseY < 93){
    //Wed
    graphOnOff[3] = graphOnOff[3] * (-1); //trigger on and off
    
  } else if (mouseX > 20 && mouseX < 60 && mouseY > 93 && mouseY < 113){
    //Thu
    graphOnOff[4] = graphOnOff[4] * (-1); //trigger on and off
    
  } else if (mouseX > 20 && mouseX < 60 && mouseY > 113 && mouseY < 133){
    //Fri
    graphOnOff[5] = graphOnOff[5] * (-1); //trigger on and off
    
  } else if (mouseX > 20 && mouseX < 60 && mouseY > 133 && mouseY < 153){
    //Sat
    graphOnOff[6] = graphOnOff[6] * (-1); //trigger on and off
  }
  
}

//=============== keyPressed() ===============
void keyPressed() {
  if(key == 'p'){
    save("GraphVersion.png");
    exit();
  }
}

//  fill(360*1/7, 100, 100);
//  text("Sun", 20, 30);
//
//  fill(360*2/7, 100, 100);
//  text("Mon", 20, 50);
//
//  fill(360*3/7, 100, 100);
//  text("Tue", 20, 70);
//
//  fill(360*4/7, 100, 100);
//  text("Wed", 20, 90);
//
//  fill(360*5/7, 100, 100);
//  text("Thu", 20, 110);
//
//  fill(360*6/7, 100, 100);
//  text("Fri", 20, 130);
//
//  fill(360*7/7, 100, 100);
//  text("Sat", 20, 150);
