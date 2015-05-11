//============= notes =============
/*
This is a code for extracting colors contained in photos using Imagga API.
You can analyze multiple photos that are uploaded in advance to web and named under a naming convention.
You should prepare csv file named "photodata.csv" under "data" folder to write the analysis result on it.  
You also need Immaga Premium Account for Color API to iterate through large number of photos.  
*/
//============= import libraries =============
import processing.net.*;
import javax.xml.bind.DatatypeConverter;

//============= imagga api =============
String API_Key = "acc_68f5430d07a85b7";
String API_Secret = "786e5a4add468845c504465cece4d7fa";
String API_KeyAndSecret = API_Key + ":" + API_Secret;
String encodedAuth = DatatypeConverter.printBase64Binary(API_KeyAndSecret.getBytes());

//============= query string =============
String photo_url = "http://s5884.com/w/photodata_final_photos/";
String prefix = "japan_";
int index = 1; //the beginning index
int maxNum = 102; //total number of photos
String jpg = ".jpg";

//============= client =============
Client client;
String data;
String[] myData;
String myDataTags;
JSONObject tagsObject;
JSONArray tags;

//============= csv =============
String filename = "photodata.csv";

//============= flags =============
int counter = 0; //framecount
boolean notDone = true;
boolean started = false;


//============= setup() =============
void setup() {
  //make an initial request
  client = new Client(this, "api.imagga.com", 80);
  client.write("GET /v1/colors?url=" + photo_url + prefix + index + jpg + " HTTP/1.0\r\n");
  client.write("Host: api.imagga.com\r\n");
  client.write("Authorization: Basic " + encodedAuth + "\r\n");
  client.write("Accept: application/xml\r\n");
  client.write("Accept-Charset: utf-8;q=0.7,*;q=0.7\r\n");
  client.write("\r\n");
}

//============= draw() =============
void draw() {
  checkDone(); //check if all the photo has been processed
  readResponse(); //read the response from server
  saveResultToCSV(); //save the result to csv
  incrementCounter(); //increment frame count
}


//============= checkDone() =============
//check if all the photo has been processed
void checkDone(){
  if (index > maxNum) {
    notDone = false;
    println("Done.");
  }
}

//============= readResponse() =============
//read the response from server
void readResponse(){
  if (client.available() > 0) {    // If there's incoming data from the client...
    data += client.readString();   // ...then grab it and print it 
    println(data);
    myData = data.split("\n");
    myDataTags = myData[myData.length-1];

    started = true; //toggle the flag
  }
}

//============= saveResultToCSV() =============
//save the result to csv
void saveResultToCSV(){
if (counter % 500 == 499 && notDone && started) {
    Table table = loadTable(filename, "header");

    JSONObject myDataTagsJSON = parseJSONObject(myDataTags);
    JSONArray resultsArray = myDataTagsJSON.getJSONArray("results");
    JSONObject resultsObject = resultsArray.getJSONObject(0);
    JSONObject infoObject = resultsObject.getJSONObject("info");

    JSONArray bg_Array = infoObject.getJSONArray("background_colors");
    JSONArray fg_Array = infoObject.getJSONArray("foreground_colors");
    JSONArray image_Array = infoObject.getJSONArray("image_colors");


    //background colors ---------------------------------------
    for (int i = 0; i < bg_Array.size (); i++) {
      JSONObject bg_Object = bg_Array.getJSONObject(i);

      TableRow row = table.addRow();
      row.setString("filename", prefix + index);
      row.setString("fileurl", resultsObject.getString("image"));
      row.setString("kind", "background");
      row.setString("hex", bg_Object.getString("html_code"));
      row.setInt("r", bg_Object.getInt("r"));
      row.setInt("g", bg_Object.getInt("g"));
      row.setInt("b", bg_Object.getInt("b"));
      row.setFloat("percent", bg_Object.getFloat("percentage"));

      println(prefix + index + " " + "bg " + i + " hex: " + bg_Object.getString("html_code") + " percent: " + bg_Object.getFloat("percentage"));
    }

    //foreground colors ---------------------------------------
    for (int i = 0; i < fg_Array.size (); i++) {
      JSONObject fg_Object = fg_Array.getJSONObject(i);

      TableRow row = table.addRow();
      row.setString("filename", prefix + index);
      row.setString("fileurl", resultsObject.getString("image"));
      row.setString("kind", "foreground");
      row.setString("hex", fg_Object.getString("html_code"));
      row.setInt("r", fg_Object.getInt("r"));
      row.setInt("g", fg_Object.getInt("g"));
      row.setInt("b", fg_Object.getInt("b"));
      row.setFloat("percent", fg_Object.getFloat("percentage"));

      println(prefix + index + " " + "fg " + i + " hex: " + fg_Object.getString("html_code") + " percent: " + fg_Object.getFloat("percentage"));
    }

    //image colors ---------------------------------------
    for (int i = 0; i < image_Array.size (); i++) {
      JSONObject image_Object = image_Array.getJSONObject(i);

      TableRow row = table.addRow();
      row.setString("filename", prefix + index);
      row.setString("fileurl", resultsObject.getString("image"));
      row.setString("kind", "image");
      row.setString("hex", image_Object.getString("html_code"));
      row.setInt("r", image_Object.getInt("r"));
      row.setInt("g", image_Object.getInt("g"));
      row.setInt("b", image_Object.getInt("b"));
      row.setFloat("percent", image_Object.getFloat("percent"));

      println(prefix + index + " " + "image " + i + " hex: " + image_Object.getString("html_code") + " percent: " + image_Object.getFloat("percent"));
    }


    //save those rows
    saveTable(table, "data/" + filename);
    //increment index of filename
    index++;

    //next request
    client = new Client(this, "api.imagga.com", 80);
    client.write("GET /v1/colors?url=" + photo_url + prefix + index + jpg + " HTTP/1.0\r\n");
    client.write("Host: api.imagga.com\r\n");
    client.write("Authorization: Basic " + encodedAuth + "\r\n");
    client.write("Accept: application/xml\r\n");
    client.write("Accept-Charset: utf-8;q=0.7,*;q=0.7\r\n");
    client.write("\r\n");
  }
}

//============= incrementCounter() =============
//increment frame count
void incrementCounter(){
  if (started) {
    counter++;
  }
}
