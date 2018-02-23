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
