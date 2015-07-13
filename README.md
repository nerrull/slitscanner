# slitscanner
Slitscan effect in Processing
Example video :

[![Right gradient with maximum delay](https://www.youtube.com/watch?v=cNnaRpf-W5U/5.jpg)](https://www.youtube.com/watch?v=cNnaRpf-W5U)

Author:

Etienne Richan

12/07/2015

This tool simulates the slitscan effect by delaying pixels in a video a certain amount of frames depending on the darknes of a reference gradient image.

#Usage:
1. Specify a video file path. 

  ***IMPORTANT*** : Videos must be located in the project's 'data' folder. 
  
  Video must be .mov type (only version tested, maybe other quicktime compatible types are supported)
  
2. Check video details and set the width and height.
3. (Optional) Set max delay. This can be changed while hte program is running.


##Modes (GRADIENT recommended):
  GRADIENT : Uses the pixels of a gradient to apply the effect
  SLITS : Only in the up direction, might run a bit faster than gradient mode. 


#Key controls:
#Gradient controls:
  w: up gradient
  
  a: left gradient
  
  s: right gradient
  
  d: down gradient

#Delay controls:
 Increased max delay means that the gradient is interpreted with a higher resolution, but also means more time delay between the top and the bottom of the video. 

  "=" : Increase max_delay by 1
  
  "-" : Decrease max_delay by 1
  
  "SHIFT" + "=" : Increase max_delay by 10

  "SHIFT" + "-" : Decrease max_delay by 10
  


