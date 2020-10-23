
class MathTools {

  public static inline function lerp(min:Float, max:Float, value:Float):Float {

    return min + (max - min) * value;

  }

}