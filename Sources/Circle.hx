
import kha.graphics2.Graphics;
import kha.Color;

using kha.graphics2.GraphicsExtension;

typedef CircleProps = {
	x:Int,
	y:Int,
  radius:Int,
  ?speed:Float,
	?color:Null<Color>,
}

class Circle {

	public var x:Int;
	public var y:Int;
  public var radius:Int;
  public var speed:Float;
  public var color:Null<Color> = null;

  public var xDirection:Int;
  public var yDirection:Int;

  public var minX(get, never):Int;
  public function get_minX() return this.x - this.radius;

  public var minY(get, never):Int;
  public function get_minY() return this.y - this.radius;

  public var maxX(get, never):Int;
  public function get_maxX() return this.x + this.radius;

  public var maxY(get, never):Int;
  public function get_maxY() return this.y + this.radius;

	public function new(props:CircleProps) {

		this.x = props.x;
		this.y = props.y;
    this.radius = props.radius;
    this.speed = props.speed != null ? props.speed : 0.1;
		this.color = props.color;

  }

  public function update(delta:Float) {

    this.x += Math.round(this.xDirection * this.speed * delta);
    this.y += Math.round(this.yDirection * this.speed * delta);

  }

	public function render(graphics:Graphics):Void {

    final fillColor = this.getFillColor();
		if (fillColor != null) {

			graphics.color = fillColor;

    }

    graphics.fillCircle(this.x, this.y, this.radius);

  }

  private function getFillColor() {

    return this.color;

  }

}