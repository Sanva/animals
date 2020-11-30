
import kha.math.FastVector2;
import kha.FastFloat;

using Math;

class FastVector2Tools {

  public static function rotate(vec:FastVector2, angle:FastFloat, origin:FastVector2):Void {

    final x = vec.x - origin.x;
    final y = vec.y - origin.y;

    final cos = angle.cos();
    final sin = angle.sin();

    vec.x = x * cos - y * sin + origin.x;
    vec.y = x * sin + y * cos + origin.y;

  }

  public inline static function rotateDegrees(vec:FastVector2, angleDegrees:FastFloat, origin:FastVector2):Void {

    return FastVector2Tools.rotate(vec, angleDegrees * Math.PI / 180, origin);

  }

}