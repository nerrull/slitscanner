static final int UP = 1;
static final int DOWN = 2;
static final int LEFT = 3;
static final int RIGHT = 4;

static final int WORMHOLE_MODE = 0;
static final int GRADIENT_MODE = 1;
static final int PAINT_MODE = 2;

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
    drawGradient();
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
    image(_pg, 0,0);
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
      }
      isDirty = false;
    }
  }

  void drawGradientEllipse(){
      _pg.beginDraw();
      _pg.background(255);
      _pg.noStroke();
      for(int i =1 ; i<=255; i++){
        _pg.fill(255 -i);
        _pg.ellipse(_xPos, _yPos, 255 -i, 255-i);
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
      isDirty = true;
      _xPos = 0;
      _yPos = 0;
    }
  }

  void incrementBrushSize(int i){
    _brushSize += i;
    _brushSize = max (1, _brushSize);
    println("Brush size : " + _brushSize);
  }
}