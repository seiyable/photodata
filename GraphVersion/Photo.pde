class Photo{
  //=============== in-class variables ===============
  String filename;
  Date datetime;

  //=============== constructor ===============  
  Photo(String _filename, Date _datetime, String _latitude, String _latitudeRef, String _longitude, String _longitudeRef){
    filename = _filename;
    datetime = _datetime;    
 
  }
  
  //=============== getFilename() ===============
  String getFilename(){
    return filename;
  }
  
  //=============== getDatetime() ===============
  Date getDatetime(){
    return datetime;
  }  
  
}
