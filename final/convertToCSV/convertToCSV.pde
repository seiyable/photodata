//============= notes =============
/*
This is a code for converting a text file to csv file.
In this case, the source text consists of a sequence of
kanji, hiragana, and hex value, in this order.  
*/

//============= import libraries =============
import java.lang.Character.UnicodeBlock;

//============= global variables =============
Table table; 

//============= setup() =============
void setup() {
  //create new table
  table = new Table();
  table.addColumn("name_kanji");
  table.addColumn("name_hiragana");
  table.addColumn("hex");
  
  //load text file
  String lines[] = loadStrings("scraped.txt");
  String inputStr = lines[0];
  
  
  //variables to handle input string
  boolean kanji    = true; //flag
  boolean hiragana = false; //flag
  boolean hex      = false; //flag
  String nextStr   = "";
  TableRow newRow  = table.addRow();
  
  //iterate through all characters in the source text
  for(int i = 0; i < inputStr.length(); i++){
    char c = inputStr.charAt(i);
    
    //if the character is the first charcter of a word of hiragana,
    //write the current nextStr to CSV under the header named name_kanji.
    if(UnicodeBlock.of(c) == UnicodeBlock.HIRAGANA && !hiragana){
      newRow = table.addRow(); //add new row
      newRow.setString("name_kanji", nextStr);
      nextStr = ""; //reset string
      
      //update flags
      kanji    = false;
      hiragana = true;
      hex      = false;
    }
    
    //if the character is the first charcter of a hex value,
    //write the current nextStr to CSV under the header named name_hiragana.
    else if(UnicodeBlock.of(c) == UnicodeBlock.BASIC_LATIN && !hex){
      newRow.setString("name_hiragana", nextStr);
      nextStr = ""; //reset string
      
      //update flags
      kanji    = false;
      hiragana = false;
      hex      = true;
    }
    
    //if the character is the first charcter of a word of kanji,
    //write the current nextStr to CSV under the header named hex.
    else if(UnicodeBlock.of(c) == UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS && !kanji){
      newRow.setString("hex", nextStr);
      nextStr = ""; //reset string
      
      //update flags
      kanji    = true;
      hiragana = false;
      hex      = false;
    }
    
    //add the char
    nextStr += c;
  }
  
  //save the CSV
  saveTable(table, "data/JapaneseTraditionalColors.csv");
  println("Done");
}

//============= draw() =============
void draw() {
  //do nothing
}

