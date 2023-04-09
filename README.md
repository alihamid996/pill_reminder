# pill_reminder
-Ongoing projetc  

An app made in Flutter that gives the user the ability to add alarms for medicine, the app can be connected with a node-MCU which is connected to a pill box with ir sensor that can detect when and if the pill was taken, the info then is sent to the app which can save the info and display them in a table.
## Parts of the project:
the project files are split into two:  

-1 The app files, are located under Smartpharm.  

-2 The esp8266 files, which contain the esp8266 code plus the AutoCAD files for the pill box.  

 ## Notes
 the esp8266 code is still missing some functions, the app has a bug that doesn't allow for a stable connection with the esp8266.  
 the pillbox was made using plexi which is very cheap and durable, but I would advise lowering the total height of the box.
 ## To Do:
 1-complete the esp8266 code.  
 
 2-design a circuit in Proteus(to replace the bread board).  
 
 3-add a function to also send the data about the pills using a telegram bot.
