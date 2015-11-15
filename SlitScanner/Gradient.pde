static final int UP = 1;
static final int DOWN = 2;
static final int LEFT = 3;
static final int RIGHT = 4;
static final int NORTH_EAST = 5;
static final int NORTH_WEST = 6;
static final int SOUTH_EAST = 7;
static final int SOUTH_WEST = 8;

static final int WORMHOLE_MODE = 0;
static final int GRADIENT_MODE = 1;
static final int SPLIT_GRADIENT_MODE = 2;
static final int PAINT_MODE = 3;

public class Gradient {
  int _height;
  int _width;
  int _resolution;
  PImage _image;
  color _c1;
  color _c2;
  PGraphics _pg;
  int _xPos;
  int _yPos;
  int _direction;
  int _mode;
  int _brushSize;
  int _wormholeSize = 255;
  boolean isDirty =false;

  public Gradient (int xPos, int yPos, int w, int h, color c1, color c2, int direction, int resolution) {
    _resolution = resolution;
    _width = w;
    _height = h;
    _c1 = c1;
    _c2 = c2;
    _pg =  createGraphics(_width, _height);
    _xPos = xPos;
    _yPos = yPos;
    _direction = direction;
    _mode = GRADIENT_MODE;
    _brushSize = 30;

    drawGradient();
  }

  PGraphics getGradient(){
    return _pg;
  }

  int getDelayValue( int x, int y, int max_delay){

      color c = _pg.pixels[y*_pg.width+x];
      //Use the red value 
      int val = 255 -(c >> 16 &0xFF);
      int delay = (int) min(max_delay -1, (val/255.0 *max_delay)) ;
      return delay;
  }

  void setGradientDirection(int d){
    _direction = d;
    isDirty = true;
    updateGradient();
  }


  void drawGradient() {
    _pg.noFill();
    _pg.beginDraw();
    if (_direction == UP) {  // Top to bottom gradient
      println("Gradient UP"); 
      for (int i = _yPos; i <= _yPos+_height; i++) {
        float inter = map(i, _yPos, _yPos+_height, 0, 1);
        color c = lerpColor(_c1, _c2, inter);
        _pg.stroke(c);
        _pg.line(_xPos, i, _xPos+_width, i);
       
      }
    }  

     else if (_direction == DOWN) {  // Top to bottom gradient
      println("Gradient Down"); 
      for (int i = _yPos; i <= _yPos+_height; i++) {
        float inter = map(i, _yPos, _yPos+_height, 0, 1);
        color c = lerpColor(_c2, _c1, inter);
        _pg.stroke(c);
        _pg.line(_xPos, i, _xPos+_width, i);
       
      }
    }  

    else if (_direction == LEFT) {  // Left to right gradient
      println("Gradient LEFT"); 
      for (int i = _xPos; i <= _xPos+_width; i++) {
        float inter = map(i, _xPos, _xPos+_width, 0, 1);
        color c = lerpColor(_c1, _c2, inter);
        _pg.stroke(c);
        _pg.line(i, _yPos, i, _yPos+_height);
      }
    }
    else if (_direction == RIGHT) {  // Left to right gradient
      println("Gradient RIGHT"); 
      for (int i = _xPos; i <= _xPos+_width; i++) {
        float inter = map(i, _xPos, _xPos+_width, 0, 1);
        color c = lerpColor(_c2, _c1, inter);
        _pg.stroke(c);
        _pg.line(i, _yPos, i, _yPos+_height);
      }
    }
    _pg.endDraw();
    //image(_pg, 0,0);
  }



  void drawSplitGradient() {
    _pg.noFill();
    _pg.beginDraw();
    _pg.background(255, 255, 255, 255);
    if (_direction == UP) {  // Top to bottom gradient
      println("Gradient UP"); 
      drawDoubleVerticalGradient(_pg, _c1, _c2, _yPos, 1);
    }  

    if (_direction == DOWN) {  // Top to bottom gradient
      println("Gradient DOWN"); 
      drawDoubleVerticalGradient(_pg, _c2, _c1, _yPos, 1);
    }

    else if (_direction == LEFT) {  // Left to right gradient
      println("Gradient LEFT"); 
      drawDoubleHorizontalGradient(_pg, _c1, _c2, _xPos, 1);
    }
    else if (_direction == RIGHT) {  // Left to right gradient
      println("Gradient RIGHT"); 
      drawDoubleHorizontalGradient(_pg, _c2, _c1, _xPos, 1);
    }

    else if(_direction == NORTH_EAST){
      println("Gradient UP +RIGHT"); 
      drawDoubleVerticalGradient(_pg, _c1, _c2, _yPos, 0.5);
      drawDoubleHorizontalGradient(_pg, _c2, _c1, _xPos, 0.5);
    }

    else if(_direction == NORTH_WEST){
      println("Gradient UP + LEFT"); 
      drawDoubleVerticalGradient(_pg, _c1, _c2, _yPos, 0.5);
      drawDoubleHorizontalGradient(_pg, _c1, _c2, _xPos, 0.5);
    }

    else if(_direction == SOUTH_WEST){
      println("Gradient DOWN + LEFT"); 
      drawDoubleVerticalGradient(_pg, _c2, _c1, _yPos, 0.5);
      drawDoubleHorizontalGradient(_pg, _c1, _c2, _xPos, 0.5);
    }

    else if(_direction == SOUTH_EAST){
      println("Gradient DOWN +RIGHT"); 
      drawDoubleVerticalGradient(_pg, _c2, _c1, _yPos, 0.5);
      drawDoubleHorizontalGradient(_pg, _c2, _c1, _xPos, 0.5);
    }

    _pg.endDraw();
    //image(_pg, 0,0);
  }

  void drawDoubleVerticalGradient(PGraphics pg, int c1, int c2, int yPos, float opacity) {
    for (int i = 0; i <= yPos; i++) {
        float inter = map(i, -1, yPos +1, 0, 1);
        color c =   (lerpColor(c1, c2, inter) & 0xffffff) | ( (int)(opacity*255) << 24) ;
        pg.stroke(c);
        pg.line(0, i, _width, i);
       
      }
      for (int i = yPos ; i <= _height; i++) {
        float inter = map(i,  yPos -1, _height +1, 0, 1);
        color c =   (lerpColor(c2, c1, inter) & 0xffffff) | ( (int)(opacity*255) << 24) ;
        pg.stroke(c);
        pg.line(0, i, _width, i);
       
      }
  }

  void drawDoubleHorizontalGradient(PGraphics pg, color c1, color c2, int xPos,  float opacity) {
   for (int i = 0; i <= xPos; i++) {
        float inter = map(i, -1, xPos +1, 0, 1);
        color c =   (lerpColor(c1, c2, inter) & 0xffffff) | ( (int)(opacity*255) << 24) ;
        pg.stroke(c);
        pg.line(i, 0, i, _height);
      }
    for (int i = xPos; i <= _width; i++) {
        float inter = map(i, xPos -1, width +1, 0, 1);
        color c =   (lerpColor(c2, c1, inter) & 0xffffff) | ( (int)(opacity*255) << 24) ;
        pg.stroke(c);
        pg.line(i, 0, i, _height);
      }
    }

  void updateGradient(){
    if(isDirty){
      switch (_mode){
        case PAINT_MODE:
          drawGradientAlphaEllipse();
        break;
        case WORMHOLE_MODE:
          drawGradientEllipse();
        break;
        case GRADIENT_MODE :
          drawGradient();
        break;  
        case SPLIT_GRADIENT_MODE :
          drawSplitGradient();
        break;  
      }
      isDirty = false;
    }
  }

  void drawGradientEllipse(){
      _pg.beginDraw();
      _pg.background(255);
      _pg.noStroke();
      for(int i =1 ; i<=_wormholeSize; i++){
        float inter = 1- map(i, 1, _wormholeSize, 0, 1);
        color c = lerpColor(_c1, _c2, inter);
        _pg.fill(c);
        _pg.ellipse(_xPos, _yPos, _wormholeSize -i, _wormholeSize-i);
      }
      _pg.endDraw();
  }

  void drawGradientAlphaEllipse(){
      _pg.beginDraw();
      _pg.noStroke();
      for(int i =1 ; i<=_brushSize; i++){
        float inter = 1- map(i, 1, _brushSize, 0, 1);
        color c = lerpColor(_c1, _c2, inter);
        _pg.fill(0,0,0, sqrt(sqrt(c>>16 &0xFF)));
        _pg.ellipse(_xPos, _yPos, _brushSize -i, _brushSize-i);
      }
      _pg.endDraw();
  }

  void setGradientPosition(int x, int y){
    _xPos = x;
    _yPos = y;
    isDirty = true;
  }

  void setMode(int mode){
    _pg.beginDraw();
    _pg.background(255);
    _pg.endDraw();
    _mode = mode;
    if (mode == GRADIENT_MODE){
      _xPos = 0;
      _yPos = 0;
    }
    else if (mode == SPLIT_GRADIENT_MODE)
    {
      _xPos = width/2;
      _yPos = height/2;
    }
     isDirty = true;
  }

  void incrementBrushSize(int i){
    _brushSize += i;
    _brushSize = max(1, _brushSize);
    println("Brush size : " + _brushSize);
  }

  void incrementWormhole(int i){
    _wormholeSize += i;
    _wormholeSize = max(1, _wormholeSize);
    isDirty = true; 
  }


}