# pill_reminder
-on going projetc
An app made in flutter which gives the user the ability to add alarms for medcine, the app can be connected with a node-mcu which is connected to pill box with ir sensor that can detect when and if the pill was taken, the info then is sent to the app which can save the infor and display them in a table.
## Parts of the project:
the project files are splitted into two:  

-1 The app files, that are located under App.  

-2 The esp8266 files, which contains the esp8266 code plus the autocad files for the pill box.  

 ## Notes
 the esp8266 code is still missing some functions, the app has a bug that doesn't allow for a stable connection with the esp8266.  
 the pill box was made using plexi which is very cheap and durable, but I would advice for lowering the  total height of the box.
 ## To Do:
 1-complete the esp8266 code.  
 
 2-design a curcuit in protous (to replace the bread board).  
 
 3-add a fucntion to aslo send the data about the pills using a telegram bot.
