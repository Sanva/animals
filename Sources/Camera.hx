
import kha.graphics2.Graphics;
import kha.FastFloat;

using kha.graphics2.GraphicsExtension;
using kha.Color;

using Math;

typedef CameraProps = {
	x:FastFloat,
	y:FastFloat,
}

class Camera {

	public var x:FastFloat;
  public var y:FastFloat;

  var destinationX:FastFloat = 0;
  var destinationY:FastFloat = 0;
  var easing:FastFloat = 1.0;

	public function new(props:CameraProps) {

		this.x = props.x;
		this.y = props.y;

  }

  public function update() {

    this.x = this.lerp(this.x, this.destinationX, this.easing).round();
    this.y = this.lerp(this.y, this.destinationY, this.easing).round();

  }

  public function render(graphics:Graphics):Void {

    graphics.color = Color.Yellow;
    graphics.drawCircle(0, 0, 5, 2);

  }

  public function move(x:FastFloat, y:FastFloat, easing:FastFloat = 1.0) {

    this.destinationX = x;
    this.destinationY = y;
    this.easing = easing;

  }

  private inline function lerp(min:Float, max:Float, value:Float):Float {

    return min + (max - min) * value;

  }

}