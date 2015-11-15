
/*******************
Author:
Etienne Richan
12/07/2015

This tool simulates the slitscan effect by delaying pixels in a video a certain amount of frames depending on the darknes of a reference gradient image.

Usage:
1. Specify a video file path. 
  ***IMPORTANT*** : Videos must be located in the project's 'data' folder. 
  Video must be .mov type (only version tested, maybe other quicktime compatible types are supported)
2. Set the output path.
3. Check video details and set the width and height.
4. (Optional) Set max delay. This can be changed while hte program is running.


Modes (GRADIENT recommended):
  GRADIENT : Uses the pixels of a gradient to apply the effect
  SLITS : Only in the up direction, might run a bit faster than gradient mode. 

Webcam mode:
  1. Set WEBCAM_MODE to true.
  2. Run the script, it will output a list of the available resolutions for your webcam
  3. Set WEBCAM_NUMBER to the desired camera resolution
  4. Set VIDEO_WIDTH and VIDEO_HEIGHT


Key controls:

Gradient controls:
g : toggle gradient visibility (controls still work while gradient is not displayed)
1 : GRADIENT mode
  w: up gradient
  a: left gradient
  s: right gradient
  d: down gradient

2 : WORMHOLE mode
  Click and drag to place the wormhole 

3 : PAINT mode
  Click and drag to paint the gradient layer
  [ : Decrease brush size by 10
  ] : Increase brush size by 10


Delay controls:
  Increased max delay means that the gradient is interpreted with a higher resolution, 
  but also means more time delay between the top and the bottom of the video. 

  = : Increase max_delay by 1
  - : Decrease max_delay by 1
  SHIFT & = : Increase max_delay by 10
  SHIFT & - : Decrease max_delay by 10



*******************/

import processing.video.*;
import java.util.concurrent.*;

static final int GRADIENT = 0;
static final int SLITS = 1;

static final int GIF = 0;
static final int PNG = 1;

int DELAY_MODE = GRADIENT;
int EXPORT_MODE = PNG;

String OUT_PATH = "out/cheetah/";
String VIDEO_PATH = "cheetah.mov";
int VIDEO_WIDTH = 640;
int VIDEO_HEIGHT = 480;
int MAX_DELAY = 30;
boolean WEBCAM_MODE = true;
int WEBCAM_NUMBER = 0;

boolean EXPORT_FRAMES = false;
boolean SHOW_GRADIENT = false;
Movie src_video;
PImage src_image;
PImage result_image;
ArrayList<PImage> source_array;

Semaphore lock;
boolean first_image = true;
Gradient g;

Capture cam;

void setup() {

  size(VIDEO_WIDTH,VIDEO_HEIGHT);
  g = new Gradient(0, 0, width, height, color(0),color(255), UP, MAX_DELAY);
  g.setMode(PAINT_MODE);
  image(g.getGradient(), color(0,0,0), color(1,1,1) );
  result_image = createImage(width, height, RGB);
  source_array = new ArrayList();
  lock = new Semaphore(1);

  frameRate(30);

  if(WEBCAM_MODE)
  {
     String[] cameras = Capture.list();

     if (cameras.length == 0) {
      println("There are no cameras available for capture.");
      exit();
      } else {
        println("Available cameras:");
        for (int i = 0; i < cameras.length; i++) {
          println(i + ". " + cameras[i]);
        }
      
      // The camera can be initialized directly using an 
      // element from the array returned by list():
      cam = new Capture(this, cameras[WEBCAM_NUMBER]);
      cam.start();     
    }      
  }

  else {
   
    src_video = new Movie (this, VIDEO_PATH);
    src_video.loop(); 
    src_video.volume(0);
  }
}


void draw() {
   if(WEBCAM_MODE)
  {
    if(cam.available())
    {
      cam.read();
      src_image = cam.get();
      src_image.loadPixels();
      processVideo();
    }
  }
  frame.setTitle(int(frameRate) + "fps");
  if (SHOW_GRADIENT){
    image(g.getGradient(),0,0);
  }

  g.updateGradient();
}


void initSourceArray(PImage source){
  for( int i = 0; i<MAX_DELAY; i++ ) {
    source_array.add(source);
  }
  first_image = false;

}

void updateArray(boolean plus, int num){
  if (MAX_DELAY != source_array.size()){
    if (plus){
      for(int i = 0; i<num ; i++)
      {
        source_array.add(source_array.get(source_array.size() -1));
      }
    }
    else{
      for(int i = 0; i<num ; i++)
      {
        source_array.remove(source_array.size() -1);
      }
    }
  }
}

void acquireImages(PImage source, ArrayList<PImage> sourceArray){
  try {
    lock.acquire();  
  }
  catch (InterruptedException e) {
    println(e);
  }  
  for( int i = MAX_DELAY -1; i>0; i-- ) {
    PImage temp =sourceArray.get(i -1); 
    if ( temp != null){
      sourceArray.set(i, temp);
    }
  }
  lock.release();
  sourceArray.set(0, source);

}

void copyVideoSlits(ArrayList<PImage> sourceArray, PImage result){
  int length =  result.pixels.length/MAX_DELAY;

  try {
    lock.acquire();
  }
    catch (InterruptedException e) {
      println(e);
    }  
  for (int i = 0; i < MAX_DELAY ; i++)
  {
    PImage temp =sourceArray.get(i); 
    if(temp != null)
    {
      int pos = i * length;

      //println("pos :" + pos);
      System.arraycopy(temp.pixels, pos, result.pixels, pos,  length);
    }    
  }
  lock.release();
  result.updatePixels();
}


void copyVideoGradient(ArrayList<PImage> sourceArray, PImage result){
  try {
    lock.acquire();
  }
    catch (InterruptedException e) {
      println(e);
    }  

  for ( int x =0; x< width; x++ )
  {
    for ( int y =0; y<height; y++)
    {
      int delay =  g.getDelayValue(x,y, MAX_DELAY);
      int pos =y*width + x;
      result.pixels[pos] = sourceArray.get(delay).pixels[pos];
    }
  }
  lock.release(); result.updatePixels();

}

void movieEvent(Movie m) {
  m.read();
  src_image = src_video.get();
  src_image.loadPixels();
  processVideo();
 
}

void processVideo(){
  if (first_image){
    initSourceArray(src_image);
  }

  acquireImages(src_image, source_array);
  if (DELAY_MODE == GRADIENT)
  {
    copyVideoGradient(source_array, result_image);
  }
  else if (DELAY_MODE == SLITS)
  {
    copyVideoSlits(source_array, result_image);
  }
  if (!SHOW_GRADIENT){
    image(result_image, 0,0);
  }
  if (EXPORT_FRAMES){
    export();
  }  

}


int export_count = 0;
public void export(){
  String nameString = String.format("foo-%06d",  export_count);
  switch (EXPORT_MODE){
    case PNG : 
      saveFrame(OUT_PATH + "/PNG/" +nameString + ".png");
    break;
    case GIF : 
      saveFrame(OUT_PATH + "/GIF/"+nameString+".gif");
    break;
  }
  export_count ++;
  
}

public void incrementDelay(int num){
  try {
    lock.acquire();
  }
  catch (InterruptedException e) {
    println(e);
  }
  MAX_DELAY +=num;
  if(g._direction == UP ||g._direction ==DOWN ){
    MAX_DELAY = min(MAX_DELAY, height -1);
  }
  else if(g._direction == LEFT ||g._direction ==RIGHT ){
    MAX_DELAY = min(MAX_DELAY, width -1);
  }
  MAX_DELAY = max(MAX_DELAY, 1);
  println("MAX_DELAY : "  + MAX_DELAY);
  updateArray(num >=0, num);
  lock.release();
}

void mouseClicked(){
  g.setGradientPosition(mouseX, mouseY);

}

void mouseDragged(){
  g.setGradientPosition(mouseX, mouseY);
}


void  keyPressed() {
  switch (key) {
    case '1':
      g.setMode(GRADIENT_MODE);
    break;
    case '2':
      g.setMode(SPLIT_GRADIENT_MODE);
    break;
    case '3':
      g.setMode(WORMHOLE_MODE);
    break;
    case '4':
      g.setMode(PAINT_MODE);
    break;
    case '9':
      g.incrementWormhole(10);
    break;
    case '0':
      g.incrementWormhole(10);
    break;
    case '=':
      incrementDelay(1);
    break;
    case '-':
      incrementDelay(-1);
    break;
    case '+':
      incrementDelay(10);
    break;
    case '_':
      incrementDelay(-10);
    break;
     case ']':
      g.incrementBrushSize(10);
    break;
    case '[':
      g.incrementBrushSize(-10);
    break;
    case 'w':
      setGradientDirection(UP);
    break;
    case 's':
      setGradientDirection(DOWN);
    break;
    case 'a':
      setGradientDirection(LEFT);
    break;
    case 'd':
      setGradientDirection(RIGHT);
    break;
    case 'q':
      setGradientDirection(NORTH_WEST);
    break;
    case 'e':
      setGradientDirection(NORTH_EAST);
    break;
    case 'z':
      setGradientDirection(SOUTH_WEST);
    break;
    case 'c':
      setGradientDirection(SOUTH_EAST);
    break;
    case 'p':
      EXPORT_FRAMES = !EXPORT_FRAMES;
      println("EXPORT: "+EXPORT_FRAMES);
    break;
    case 'g' :
      println("SHOW_GRADIENT: "+SHOW_GRADIENT);
      SHOW_GRADIENT = !SHOW_GRADIENT;
    break;
  } 
}

void setGradientDirection(int d){
  if(DELAY_MODE == GRADIENT){
    g.setGradientDirection(d);
  }
}

