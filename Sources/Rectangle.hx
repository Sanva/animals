
import kha.graphics2.Graphics;
import kha.Color;

using Math;

typedef RectangleProps = {
	x:Int,
	y:Int,
	width:Int,
	height:Int,
}

class Rectangle {

  public var x:Int;
  public var y:Int;
  public var width:Int;
  public var height:Int;

  var destinationX:Int = 0;
  var destinationY:Int = 0;
  var easing:Float = 1.0;

	public function new(props:RectangleProps) {

    this.x = this.destinationX = props.x;
    this.y = this.destinationY = props.y;
    this.width = props.width;
    this.height = props.height;

  }

  public function update(delta:Float) {

    this.x = MathTools.lerp(this.x, this.destinationX, this.easing).round();
    this.y = MathTools.lerp(this.y, this.destinationY, this.easing).round();

  }

  public function setPosition(x:Int, y:Int) {

    this.x = this.destinationX = x;
    this.y = this.destinationY = y;

  }

  public function move(x:Int, y:Int, easing:Float = 1.0) {

    this.destinationX = x;
    this.destinationY = y;
    this.easing = easing;

  }

  public function collidesWithPoint(x:Int, y:Int) {

    final maxX = this.x + this.width;
    final maxY = this.y + this.height;

    return this.x <= x && maxX >= x && this.y <= y && maxY >= y;

  }

  public function render(graphics:Graphics):Void {

		graphics.color = Color.Red;
    graphics.drawRect(this.x, this.y, this.width, this.height, 2);

  }

}
