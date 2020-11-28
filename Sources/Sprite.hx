
import GameObject;

import iron.math.Quat;
import iron.math.Mat4;
import iron.math.Vec4;
import kha.math.FastVector2;
import kha.Color;
import kha.FastFloat;
import zui.Zui;

using Math;

typedef SpriteProps = {
  > GameObjectProps,
  ?velocity:FastVector2,
  ?scale:Vec4,
  ?speed:Float,
  ?acceleration:Float,
	?color:Null<Color>,
  ?rotating:Bool,
}

class Sprite extends GameObject {

	public var velocity:FastVector2;
  public var scale:Vec4;
  public var speed:Float;
  public var acceleration:Float;
  public var rotating:Bool;

  var direction:Direction = Down;

  public var transformations:Mat4;

  public var color(default, set):Null<Color>;
  private function set_color(color:Null<Color>):Null<Color> {

    if (color == null) {

      this.verticesColors = [
        1.0,  0.0,  0.0,  1.0, // Bottom right 0
        0.0,  1.0,  0.0,  1.0, // Top left     1
        0.0,  0.0,  1.0,  1.0, // Top right    2
        1.0,  1.0,  0.0,  1.0, // Bottom left  3
      ];

    } else {

      this.verticesColors = [
        color.R,  color.G,  color.B,  color.A, // Bottom right 0
        color.R,  color.G,  color.B,  color.A, // Top left     1
        color.R,  color.G,  color.B,  color.A, // Top right    2
        color.R,  color.G,  color.B,  color.A, // Bottom left  3
      ];

    }

    return this.color = color;

  }

  public var z(never, set):FastFloat;
  private var _z:FastFloat = 0.0;
  private function set_z(z:FastFloat):FastFloat {

    for (i in 0...this.verticesCount) {

      this.verticesPositions[i + 2] = z;

    }

    return this._z = z;

  }

  /**
   * Rotation in radians.
   **/
  private var rotation:Float = 0;

  public var rotationSpeed:Float = 1;

  public var minX(get, never):FastFloat;
  public inline function get_minX() return this.position.x - this.scale.x / 2;

  public var minY(get, never):FastFloat;
  public inline function get_minY() return this.position.y - this.scale.y / 2;

  public var maxX(get, never):FastFloat;
  public inline function get_maxX() return this.position.x + this.scale.x / 2;

  public var maxY(get, never):FastFloat;
  public inline function get_maxY() return this.position.y + this.scale.y / 2;

  public var maxVelocity(get, never):FastFloat;
  public inline function get_maxVelocity() {

    return this.velocity.x.abs() > this.velocity.y.abs() ?
      this.velocity.x :
      this.velocity.y
    ;

  }

  public inline function isMoving():Bool {

    return this.velocity.x != 0 || this.velocity.y != 0;

  }

	public function new(props:SpriteProps) {

    super(props);

    this.velocity = props.velocity != null ? new FastVector2(props.velocity.x, props.velocity.y) : new FastVector2(0, 0);
    this.scale = props.scale != null ? props.scale : new Vec4(1.0, 1.0, 1.0);
    this.speed = props.speed != null ? props.speed : 100;
    this.acceleration = props.acceleration != null ? props.acceleration : 0;
    this.color = props.color;
    this.rotating = props.rotating;

    this.verticesCount = 4;
    this.indicesCount = 6;
    this.structureLength = 9;

    this.verticesUVs = [
      0.9,  0.9, // Bottom right 0
      0.9,  0.9, // Top left     1
      0.9,  0.9, // Top right    2
      0.9,  0.9, // Bottom left  3
    ];

    this.transformations = Mat4.identity();
    this.buildTransformations();

    this.verticesPositions = this.getVerticesPositions();

    // this.indices = [
    //   2, 1, 0,
    //   0, 1, 3,
    // ];
    this.indices = [
      0, 1, 2,
      3, 1, 0,
    ];

  }

  private function buildTransformations() {

    this.transformations = Mat4.identity();
    final quat = new Quat();

    this.transformations.compose(
      new Vec4(this.position.x, this.position.y, 0, 1.0),
      quat.fromEuler(0, 0, this.rotation),
      this.scale
    );

  }

  private function getVerticesPositions():Array<FastFloat> {

    /**
     * @fixme Too many allocations.
     */

    final positions = [
      0.5,  -0.5, _z, // Bottom right 0
      -0.5, 0.5,  _z, // Top left     1
      0.5,  0.5,  _z, // Top right    2
      -0.5, -0.5, _z, // Bottom left  3
    ];

    final vertices = new Array<FastFloat>();
    final vertex = new Vec4();

    var i = 0;
    while (i < positions.length) {

      vertex.x = positions[i];
      vertex.y = positions[i + 1];
      vertex.z = positions[i + 2];

      vertex.applymat(this.transformations);

      vertices.push(vertex.x);
      vertices.push(vertex.y);
      vertices.push(vertex.z);

      i += 3;

    }

    return vertices;

  }

  public override function update(delta:Float) {

    super.update(delta);

    this.position.x = (this.position.x + this.velocity.x * this.speed * delta).round();
    this.position.y = (this.position.y + this.velocity.y * this.speed * delta).round();
    // this.velocity.y -= this.acceleration;

    if (this.velocity.x != 0 || this.velocity.y != 0) {

      if (this.velocity.x.abs() > this.velocity.y.abs()) {

        this.direction = this.velocity.x < 0 ? Left : Right;

      } else {

        this.direction = this.velocity.y < 0 ? Up : Down;

      }

    }

    if (this.rotating) {

      this.rotation += this.rotationSpeed * delta;

    }

    this.verticesPositions = this.getVerticesPositions();

    /**
     * @fixme This should not be always recalculated.
     */
     this.buildTransformations();
     this.verticesPositions = this.getVerticesPositions();

  }

}

class SpriteGui {

  final sprite:Sprite;

  final xHandle:Handle;
  final yHandle:Handle;
  final widthHandle:Handle;
  final heightHandle:Handle;
  final rotationHandle:Handle;
  final activeHandle:Handle;
  final speedHandle:Handle;

  final setAsActive:Null<() -> Void>;

  public function new(sprite:Sprite, ?setAsActive:() -> Void) {

    this.sprite = sprite;
    this.setAsActive = setAsActive;

    this.xHandle = new Handle({value: this.sprite.position.x});
    this.yHandle = new Handle({value: this.sprite.position.y});
    this.widthHandle = new Handle({value: this.sprite.scale.x * 2});
    this.heightHandle = new Handle({value: this.sprite.scale.y * 2});
    this.rotationHandle = new Handle({value: this.sprite.rotationSpeed});
    this.activeHandle = new Handle({selected: this.sprite.active});
    this.speedHandle = new Handle({value: this.sprite.speed});

  }

  public function update() {

    this.xHandle.value = this.sprite.position.x;
    this.yHandle.value = this.sprite.position.y;

  }

  public function render(ui:Zui, scale:Float) {

    this.sprite.active = ui.check(this.activeHandle, 'Visible');
    this.sprite.position.x = ui.slider(this.xHandle, 'X', 0, 1000, true, 1);
    this.sprite.position.y = ui.slider(this.yHandle, 'Y', 0, 1000, true, 1);
    this.sprite.scale.x = ui.slider(this.widthHandle, 'Width', 0, 300, true, 1) / 2;
    this.sprite.scale.y = ui.slider(this.heightHandle, 'Height', 0, 300, true, 1) / 2;
    this.sprite.rotationSpeed = ui.slider(this.rotationHandle, 'Rotation speed', 0, 10, true);
    this.sprite.speed = ui.slider(this.speedHandle, 'Movement speed', 0, 1000, true);

    if (this.setAsActive != null && ui.button('Enable Gamepad')) {

      this.setAsActive();

    }

  }

}
