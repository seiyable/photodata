Result Image:
JapaneseTraditionalColors.png

Explanation:
By displaying photos found on flickr with a search word "Japan" as a set in one image,
you can make a sense of what Japanese Traditional Colors are with actual photos.


How I generated the image:
1)
Downloaded some good photos found on flickr with a search word "Japan". 
Strored it under the folder "/photodata_final_photos", change the file names.

2)
Analyzed the colors contained in each photo using Imagga Color API 
with a processing sketch named "/colorExtraction/colorExtraction.pde"
The result was saved as CSV file named "/colorExtraction/data/photodata.csv".

3)
Scraped a web site "http://www.colordic.org/w/" that lists Japanese traditional colors
with a JS code in "/scraping.html", and got "/scraped.txt".

4)
Converted the scraped text into a CSV file 
with a processing sketch named "/convertToCSV/convertToCSV.pde",
and got the CSV file "/convertToCSV/data/JapaneseTraditionalColors.csv".

5)
Compared the list of colors extracted from Japanese photos and Japanese Traditional Colors
with a processing sketch named "/compareHexValues/compareHexValues.pde".

6)
Picked up some of the colors in the previous sketch and checked the relationship 
between the extracted color value and the color in the original photos
with a processing sketch named "/displayExtractedColor/displayExtractedColor.pde"
to decide which photo to use in the final program.

7)
Made a CSV file that has those selected photo data in it under "/japaneseColorPhotos/data/sourceList.csv",
and displayed them with the color names in the final processing sketch named "/japaneseColorPhotos/japaneseColorPhotos.pde",
and finally got the PNG file "/JapaneseTraditionalColors.png"