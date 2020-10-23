
import kha.math.FastVector2;
import kha.FastFloat;

class FastVector2Tools {

  public static function rotate(vec:FastVector2, angleDeg:FastFloat, origin:FastVector2):Void {

    final x = vec.x - origin.x;
    final y = vec.y - origin.y;

    final cos = Math.cos(angleDeg * Math.PI / 180);
    final sin = Math.sin(angleDeg * Math.PI / 180);

    vec.x = x * cos - y * sin + origin.x;
    vec.y = x * sin + y * cos + origin.y;

  }

}