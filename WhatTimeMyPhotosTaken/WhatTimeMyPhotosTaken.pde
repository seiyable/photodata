//=============== global variables ===============
import java.text.SimpleDateFormat;
import java.util.Date;

float backRectWidth, backRectHeight;
ArrayList<Photo> photos = new ArrayList<Photo>();
int[] photoCountsInEvery10Minutes = new int[24*6];

//=============== setup() ===============
void setup(){
  size(1400, 800);
  colorMode(HSB, 360, 100, 100);
  
  //import csv
  Table dateTable = loadTable("datetime.csv", "header");
  println(dateTable.getRowCount() + " total rows in table");
  
  //store all the rows in the csv into an arraylist ----------------------------
  for (TableRow row : dateTable.rows()){
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
      
      registerWhichTimeSlotThePhotoWasTaken(parsedDatetime);
            
      //add new Photo instance to the arraylist
      photos.add(new Photo(filename, parsedDatetime, latitude, latitudeRef, longitude, longitudeRef));
      
    } catch (Exception e) { 
      println("Unable to parse date stamp of the " + filename);
      //do nothing
    }
  } //----------------------------------------------------------------------------
  
  //execute these once for visualization
  background(100);
  drawTimeRects();
  displayLabels();
  drawTimeSlotRectsWithColor();
  //drawAllExifTimeLines();
  //drawSomeExifTimeLines();
 
  for(int i = 0; i < 24*6; i++){
    println("There are " + photoCountsInEvery10Minutes[i] + " photos between " + i + " and " + (i+1) + " slot.");
  }
}

//=============== draw() ===============
void draw(){
  //do nothing
}

//=============== registerWhichTimeSlotThePhotoWasTaken() ===============
void registerWhichTimeSlotThePhotoWasTaken(Date _parsedDatetime){
  //check the hour
  int   hour     = _parsedDatetime.getHours();
  float minute   = _parsedDatetime.getMinutes();
  int   minute10 = round(minute/6.0); //0 ~ 6
  
  photoCountsInEvery10Minutes[hour*6 + minute10]++;
  
}

//=============== drawTimeRects() ===============
void drawTimeRects(){
  noStroke();
  backRectWidth  = width*18/20;
  backRectHeight = height*8/19;
  
  //draw upper white rectangle 
  rect(width/20, height/19, backRectWidth, backRectHeight);
  
  //draw lower white rectangle
  rect(width/20, height*10/19, backRectWidth, backRectHeight);

  stroke(0);
}

//=============== displayLabels() ===============
void displayLabels(){
  //"AM" & "PM"
  textSize(18);
  text("AM", width/50, height/19 - 10);
  text("PM", width/50, height*10/19 - 10);
  
  //AM time labels
  textSize(10);
  for(int i = 0; i < 13; i++){
    String t = str(i);
    text(t, width/20 + (backRectWidth/12)*i, height/19 - 10);
  }

  //PM time labels
  for(int i = 0; i < 13; i++){
    String t = str(i);
    text(t, width/20 + (backRectWidth/12)*i, height*10/19 - 10);
  }
}

//=============== drawTimeSlotRectsWithColor() ===============
void drawTimeSlotRectsWithColor() {
  float slotRectWidth = backRectWidth/(12*6);
  
  //check the largest value in the array -------------------------
  int largestValue = 0;
  for(int i = 0; i < 24*6; i++){
    if(photoCountsInEvery10Minutes[i] > largestValue){
      largestValue = photoCountsInEvery10Minutes[i];
    } 
  }
  println("The largest value is " + largestValue);
  
  
  //draw rectangles with color for each 10-minute slot ------------
  for(int i = 0; i < 24*6; i++){  
    //AM
    if(i < 12*6){
      float xPos = width/20 + slotRectWidth*i;
      float hue = photoCountsInEvery10Minutes[i];
      hue = map(hue, 0, largestValue, 250, 0);
      println("the " + i + "th slot is: " + hue);
      fill(hue, 100, 100);
      noStroke();
      rect(xPos, height/19, slotRectWidth, backRectHeight);      
    } 
    //PM
    else {
      float xPos = width/20 + slotRectWidth*(i-12*6);
      float hue  = photoCountsInEvery10Minutes[i];
      hue = map(hue, 0, largestValue, 250, 0);
      fill(hue, 100, 100);
      noStroke();
      rect(xPos, height*10/19, slotRectWidth, backRectHeight);
    }
  }
}

//=============== mousePressed() ===============
void mousePressed() {
  save("WhatTimeMyPhotosTaken.png");
  exit();
}
