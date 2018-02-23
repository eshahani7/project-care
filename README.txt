Instructions to build and execute:
1. Clone project from master.
2. Open project in XCode. Must have MacOS to use XCode.
3. Connect iPhone via USB to laptop. Must be paired with Apple Watch to use realtime features. 
4. Make sure the WatchKit App scheme is selected in the upper lefthand corner. This is the label next to the the stop button.
5. Ensure target device is your iPhone paired with your Apple Watch. 
5. Click the play button in the upper lefthand corner of XCode to build and execute project. App will automatically launch.

Notes:
A valid provisioning profile is necessary to to run app on hardware. This can be obtained through Apple Developer portal.
Select "Automatically manage signing" in build settings and select your team for each target. Make sure the Bundle identifier is YourLastName.projectCARE for all targets.
The project can be run on the simulator but realtime features will not work properly as heart rate will not be sampled. 
The simulator may not have all health data saved. Age, sex, and weight can be entered in the Health app on the simulator manually.
The simulator does not have Workout data. In our next iteration, we will add files to seed Health data if no health data is available.
All unit tests at the moment do seed the Health data - if they are run, the simulator will contain workout data, but will still not contain age, sex, and weight unless entered manually.

Guidance:
1. On the first watch screen, the user selects the amount of time they want the workout to last. 
When the "NEXT" button is pressed, the user enters the desired intensity level for the work out. 
Finally, the user is prompted to start the workout. 
The app then tracks the time elapsed and the user's heart rate in real time, and tells the user when their heart rate is either too high or too low for the given intensity, based on their weight and age. 
When the user presses "STOP" the workout ends and is saved to the HealthStore. The workout can then be seen in the iPhone app.

2. On the iPhone app, the user has the option to open "Previous Workouts" or "Sleep Analysis". 
"Previous Workouts" displays the user's latest 10 workouts. 
If the user presses any workout in the list, the information pertinent to that workout is displayed, and it tells the user if they met their calorie burn goal (calculated beforehand, when workout is started). 
"Sleep Analysis" displays information about the user's sleep.
