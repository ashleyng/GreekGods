Greek Gods
======================
##About
The two apps have the exact same functionality, one just uses Firebase and the other Parse. The app allows retrieves, alters, adds, and deletes objects from its respective database as well as upload an image with each object.

##Setup
-----------
####App
Run `pod install` inside the Firebase and Parse directory from the terminal. Open the .xcworkspace file to open the app in XCode. 
####Firebase
Create a Firebase account and create a new app. Import the *greek-gods-export.json* file in the *Data* section of the dashboard, and copy the URL to the constants.m file.
####Parse
Create a Parse account and create a new app. Import the *GreekGod.json* file in the data section of the dashboard, and name the object **GreekGod**. From the settings section, get the application and client id and copy and paste those in *AppDelegate.m* on lines 20 and 21.

##Tools
 - [Firebase](https://www.firebase.com/)
 - [Parse](https://www.parse.com/)
 - [CocoaPods](https://cocoapods.org/)
