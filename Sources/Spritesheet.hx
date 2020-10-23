
import kha.FastFloat;
import kha.Image;

using Math;

typedef SpritesheetProps = {
  image:Image,
  width: FastFloat,
  height: FastFloat,
}

class Spritesheet {

	public var image:Image;
	public var width:FastFloat;
	public var height:FastFloat;

	public function new(props:SpritesheetProps) {

    this.image = props.image;
    this.width = props.width;
    this.height = props.height;

  }

  public function getUVs(position:Int) {

    final w:FastFloat = this.image.width / this.width;
    final h:FastFloat = this.image.height / this.height;

    final row:FastFloat = (position / w).floor();
    final column:FastFloat = position % w;

    var left:FastFloat = column / w;
    var right:FastFloat = (column + 1) / w;
    var top:FastFloat = row / h;
    var bottom:FastFloat = (row + 1) / h;

    // left = 0.33;
    // right = 0.66;
    // top = 0;
    // bottom = 0.25;

    // trace('(${left}, ${right}, ${top}, ${bottom})');

    return [
      right, top,
      left, bottom,
      right, bottom,
      left, top,
    ];

  }

}
