//=============== global variables ===============
import java.text.SimpleDateFormat;
import java.util.Date;

ArrayList<Photo> photos = new ArrayList<Photo>();

int[] phCountsInEvery10MinsOnSunday    = new int[24*6];
int[] phCountsInEvery10MinsOnMonday    = new int[24*6];
int[] phCountsInEvery10MinsOnTuesday   = new int[24*6];
int[] phCountsInEvery10MinsOnWednesday = new int[24*6];
int[] phCountsInEvery10MinsOnThursday  = new int[24*6];
int[] phCountsInEvery10MinsOnFriday    = new int[24*6];
int[] phCountsInEvery10MinsOnSaturday  = new int[24*6];

//=============== setup() ===============
void setup() {
  size(1400, 400);
  colorMode(HSB, 360, 100, 100);

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

      registerThePhotoToArray(parsedDatetime);

      //add new Photo instance to the arraylist
      photos.add(new Photo(filename, parsedDatetime, latitude, latitudeRef, longitude, longitudeRef));
    } 
    catch (Exception e) { 
      println("Unable to parse date stamp of the " + filename);
      //do nothing
    }
  } //----------------------------------------------------------------------------

  //execute these once for visualization
  background(100);
  displayLabels();
  drawGraph();

  //time slot
  for (int i = 0; i < 24*6; i++) {
    println("There are " + phCountsInEvery10MinsOnSunday[i] + " photos between " + i + " and " + (i+1) + " slot.");
  }
}

//=============== draw() ===============
void draw() {
  //do nothing
}

//=============== registerThePhotoToArray() ===============
void registerThePhotoToArray(Date _parsedDatetime) {
  //check the day of the week
  int day = _parsedDatetime.getDay();

  //check the hour
  int   hour     = _parsedDatetime.getHours();
  float minute   = _parsedDatetime.getMinutes();
  int   minute10 = round(minute/6.0); //0 ~ 6

  switch(day) {
  case 0:
    phCountsInEvery10MinsOnSunday[hour*6 + minute10]++;
    break;
  case 1:
    phCountsInEvery10MinsOnMonday[hour*6 + minute10]++;
    break;
  case 2:
    phCountsInEvery10MinsOnTuesday[hour*6 + minute10]++;
    break;
  case 3:
    phCountsInEvery10MinsOnWednesday[hour*6 + minute10]++;
    break;
  case 4:
    phCountsInEvery10MinsOnThursday[hour*6 + minute10]++;
    break;
  case 5:
    phCountsInEvery10MinsOnFriday[hour*6 + minute10]++;
    break;
  case 6:
    phCountsInEvery10MinsOnSaturday[hour*6 + minute10]++;
    break;
  }
}

//=============== displayLabels() ===============
void displayLabels() {

  //color code for each day
  textSize(18);

  fill(360*1/7, 100, 100);
  text("Sun", 20, 30);

  fill(360*2/7, 100, 100);
  text("Mon", 20, 50);

  fill(360*3/7, 100, 100);
  text("Tue", 20, 70);

  fill(360*4/7, 100, 100);
  text("Wed", 20, 90);

  fill(360*5/7, 100, 100);
  text("Thu", 20, 110);

  fill(360*6/7, 100, 100);
  text("Fri", 20, 130);

  fill(360*7/7, 100, 100);
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
  int maxSun = getTheLargestValueOfTheArray(phCountsInEvery10MinsOnSunday);
  int maxMon = getTheLargestValueOfTheArray(phCountsInEvery10MinsOnMonday);
  int maxTue = getTheLargestValueOfTheArray(phCountsInEvery10MinsOnTuesday);
  int maxWed = getTheLargestValueOfTheArray(phCountsInEvery10MinsOnWednesday);
  int maxThu = getTheLargestValueOfTheArray(phCountsInEvery10MinsOnThursday);
  int maxFri = getTheLargestValueOfTheArray(phCountsInEvery10MinsOnFriday);
  int maxSat = getTheLargestValueOfTheArray(phCountsInEvery10MinsOnSaturday);
  int[] maxArray = {
    maxSun, maxMon, maxTue, maxWed, maxThu, maxFri, maxSat
  };
  int worldRecord = getTheLargestValueOfTheArray(maxArray); 
  println("The world record is " + worldRecord);

  //store all the photo count arrays int one array
  ArrayList<int[]> week = new ArrayList<int[]>();
  week.add(phCountsInEvery10MinsOnSunday);
  week.add(phCountsInEvery10MinsOnMonday);
  week.add(phCountsInEvery10MinsOnTuesday);
  week.add(phCountsInEvery10MinsOnWednesday);
  week.add(phCountsInEvery10MinsOnThursday);
  week.add(phCountsInEvery10MinsOnFriday);
  week.add(phCountsInEvery10MinsOnSaturday);

  noStroke();
  float min10Width = (width-160)/(24*6.0);
  for (int d = 0; d < week.size(); d++) {
    int[] day = week.get(d);
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
    
    //draw lines
    connectDots(dots);
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
  save("GraphVersion.png");
  exit();
}

