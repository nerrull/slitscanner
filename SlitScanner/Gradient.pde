static int UP = 1;
static int DOWN = 2;
static int LEFT = 3;
static int RIGHT = 4;

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

    setGradient();
  }

  PGraphics getGradient(){
    return _pg;
  }

  int getDelayValue( int x, int y, int max_delay){

      color c = _pg.pixels[y*_pg.width+x];
      //Use the red value 
      int val = c >> 16 &0xFF;
      int delay = (int) min(max_delay -1, (val/255.0 *max_delay)) ;
      
      if(x%100 ==0 && y% 100 ==0){
        //println("val: "+val);
      }

      return delay;
  }

  void setGradientDirection(int d){
    _direction = d;
    setGradient();
  }

  void setGradient() {
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




}