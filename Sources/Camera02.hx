
import kha.graphics2.Graphics;
import kha.math.FastMatrix4;
import kha.math.FastVector2;
import kha.math.FastVector3;
import kha.Color;
import kha.FastFloat;

using kha.graphics2.GraphicsExtension;
using Math;

typedef Camera02Props = {
  position:FastVector2,
  widthTiles:Int,
  heightTiles:Int,
  tilePixels:Int,
}

class Camera02 {

  public var position:FastVector2;
  public var widthTiles:Int;
  public var heightTiles:Int;
  public var tilePixels:Int;

	private var projection:FastMatrix4;
	private var view:FastMatrix4;

  var destinationX:FastFloat = 0;
  var destinationY:FastFloat = 0;
  var easing:FastFloat = 1.0;

	public function new(props:Camera02Props) {

    this.position = props.position;
    this.tilePixels = props.tilePixels;
    this.widthTiles = props.widthTiles;
    this.heightTiles = props.heightTiles;

    this.projection = FastMatrix4.identity();
    this.view = FastMatrix4.identity();

    this.adjustProjection();

  }

  public function adjustProjection() {

    this.projection = FastMatrix4.orthogonalProjection(
      -(this.widthTiles / 2).fround(),
      (this.widthTiles / 2).fround(),
      (this.heightTiles / 2).fround(),
      -(this.heightTiles / 2).fround(),
      -1000,
      1000
    );

  }

  public function getProjectionMatrix() {

    return this.projection;

  }

  public function getViewMatrix() {

    final cameraFront = new FastVector3(0, 0, -1);
    final cameraUp = new FastVector3(0, 1, 0);
    this.view = FastMatrix4.lookAt(
      new FastVector3(this.position.x, this.position.y, 20),
      cameraFront.add(new FastVector3(this.position.x, this.position.y, 0)),
      cameraUp
    );

    return this.view;

  }

  public function getMVP() {

    return this.projection.multmat(this.getViewMatrix());

  }

  public function update() {

    this.position.x = MathTools.lerp(this.position.x, this.destinationX, this.easing).fround();
    this.position.y = MathTools.lerp(this.position.y, this.destinationY, this.easing).fround();

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

}