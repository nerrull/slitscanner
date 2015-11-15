# slitscanner
Slitscan video effect in Processing

[![Example video ](https://www.youtube.com/watch?v=cNnaRpf-W5U/0.jpg)](https://www.youtube.com/watch?v=cNnaRpf-W5U)


This tool simulates the slitscan effect by delaying pixels in a video by a certain amount of frames depending on the darkness of a reference gradient image.

##Important:
This script uses a semaphore object from java.util.concurrent so if you are getting wierd errors executing it you'll probably need to install JDK 7 or later.
[JDK 8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

##Usage:
1. Specify a video file path. 

  ***IMPORTANT*** : Videos must be located in the project's 'data' folder. 
  
  Video must be .mov type (only version tested, maybe other quicktime compatible types are supported)

2. Set the output path.

3. Check video details and set the width and height.

4. (Optional) Set max delay. This can be changed while hte program is running.


##Webcam mode:
  1. Set WEBCAM_MODE to true.
  2. Run the script, it will output a list of the available resolutions for your webcam and then probably crash
  3. Set WEBCAM_NUMBER to the desired camera number in the list
  4. Set VIDEO_WIDTH and VIDEO_HEIGHT to that camera's resolution


##Modes (GRADIENT recommended):
  GRADIENT : Uses the pixels of a gradient to apply the effect
  
  SLITS : Only in the up direction, might run a bit faster than gradient mode. 


##Key controls:
###Gradient controls:
g : toggle gradient visibility (controls still work while gradient is not displayed)
####Press 1 : GRADIENT mode
  w: up gradient

  a: left gradient

  s: right gradient

  d: down gradient

###Press 2 : WORMHOLE mode
  Click and drag to place the wormhole 

###Press 3 : PAINT mode
  Click and drag to paint the gradient layer

  [ : Decrease brush size by 10
  
  ] : Increase brush size by 10

###Delay controls:
 Increased max delay means that the gradient is interpreted with a higher resolution, but also means more time delay between the top and the bottom of the video. 

  "=" : Increase max_delay by 1
  
  "-" : Decrease max_delay by 1
  
  "SHIFT" + "=" : Increase max_delay by 10

  "SHIFT" + "-" : Decrease max_delay by 10
  

Author:

Etienne Richan

12/07/2015