
import GameObject;

import iron.math.Quat;
import iron.math.Mat4;
import iron.math.Vec4;
import kha.Color;
import kha.FastFloat;
import zui.Zui;

using Math;
using Lambda;

typedef CubeProps = {
  > GameObjectProps,
  ?scale:Vec4,
  ?rotating:Bool,
  ?color:Null<Color>,
}

class Cube extends GameObject {

  public var color(default, set):Null<Color>;
  private function set_color(color:Null<Color>):Null<Color> {

    if (color == null) {

      this.verticesColors = [
        0.583, 0.771, 0.014, 1.0,   0.609, 0.115, 0.436, 1.0,   0.327, 0.483, 0.844, 1.0,
        0.822, 0.569, 0.201, 1.0,   0.435, 0.602, 0.223, 1.0,   0.310, 0.747, 0.185, 1.0,
        0.597, 0.770, 0.761, 1.0,   0.559, 0.436, 0.730, 1.0,   0.359, 0.583, 0.152, 1.0,
        0.483, 0.596, 0.789, 1.0,   0.559, 0.861, 0.639, 1.0,   0.195, 0.548, 0.859, 1.0,
        0.014, 0.184, 0.576, 1.0,   0.771, 0.328, 0.970, 1.0,   0.406, 0.615, 0.116, 1.0,
        0.676, 0.977, 0.133, 1.0,   0.971, 0.572, 0.833, 1.0,   0.140, 0.616, 0.489, 1.0,
        0.997, 0.513, 0.064, 1.0,   0.945, 0.719, 0.592, 1.0,   0.543, 0.021, 0.978, 1.0,
        0.279, 0.317, 0.505, 1.0,   0.167, 0.620, 0.077, 1.0,   0.347, 0.857, 0.137, 1.0,
        0.055, 0.953, 0.042, 1.0,   0.714, 0.505, 0.345, 1.0,   0.783, 0.290, 0.734, 1.0,
        0.722, 0.645, 0.174, 1.0,   0.302, 0.455, 0.848, 1.0,   0.225, 0.587, 0.040, 1.0,
        0.517, 0.713, 0.338, 1.0,   0.053, 0.959, 0.120, 1.0,   0.393, 0.621, 0.362, 1.0,
        0.673, 0.211, 0.457, 1.0,   0.820, 0.883, 0.371, 1.0,   0.982, 0.099, 0.879, 1.0,
      ];

    } else {

      this.verticesColors = [
        color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,
        color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,
        color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,
        color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,
        color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,
        color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,
        color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,
        color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,
        color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,
        color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,
        color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,
        color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,   color.R, color.G, color.B, color.A,
      ];

    }

    return this.color = color;

  }

  public var scale:Vec4;

  public var rotating:Bool;

  /**
   * Rotation in radians.
   **/
  private var rotation:Float = 0;

  public var rotationSpeed:Float = 1;

  public var transformations:Mat4;

	public function new(props:CubeProps) {

    super(props);

    this.color = props.color;
    this.rotating = props.rotating;

    this.scale = props.scale != null ? props.scale : new Vec4(1.0, 1.0, 1.0);

    this.verticesCount = 36;
    this.indicesCount = 36;
    this.structureLength = 9;

    this.verticesUVs = [
      0.000059, 0.000004,
      0.000103, 0.336048,
      0.335973, 0.335903,
      1.000023, 0.000013,
      0.667979, 0.335851,
      0.999958, 0.336064,
      0.667979, 0.335851,
      0.336024, 0.671877,
      0.667969, 0.671889,
      1.000023, 0.000013,
      0.668104, 0.000013,
      0.667979, 0.335851,
      0.000059, 0.000004,
      0.335973, 0.335903,
      0.336098, 0.000071,
      0.667979, 0.335851,
      0.335973, 0.335903,
      0.336024, 0.671877,
      1.000004, 0.671847,
      0.999958, 0.336064,
      0.667979, 0.335851,
      0.668104, 0.000013,
      0.335973, 0.335903,
      0.667979, 0.335851,
      0.335973, 0.335903,
      0.668104, 0.000013,
      0.336098, 0.000071,
      0.000103, 0.336048,
      0.000004, 0.671870,
      0.336024, 0.671877,
      0.000103, 0.336048,
      0.336024, 0.671877,
      0.335973, 0.335903,
      0.667969, 0.671889,
      1.000004, 0.671847,
      0.667979, 0.335851,
    ];

    this.indices = [ for (i in 0...this.indicesCount) i ];

    this.transformations = Mat4.identity();
    this.buildTransformations();

    this.verticesPositions = this.getVerticesPositions();

  }

  private function buildTransformations() {

    this.transformations = Mat4.identity();
    final quat = new Quat();

    this.transformations.compose(
      new Vec4(this.position.x, this.position.y, 0, 1.0),
      quat.fromEuler(0, this.rotation, 0),
      this.scale
    );

  }

  private function getVerticesPositions():Array<FastFloat> {

    /**
     * @fixme Too many allocations.
     */

    final positions = [
      -1.0,-1.0,-1.0,
      -1.0,-1.0, 1.0,
      -1.0, 1.0, 1.0,
      1.0, 1.0,-1.0,
      -1.0,-1.0,-1.0,
      -1.0, 1.0,-1.0,
      1.0,-1.0, 1.0,
      -1.0,-1.0,-1.0,
      1.0,-1.0,-1.0,
      1.0, 1.0,-1.0,
      1.0,-1.0,-1.0,
      -1.0,-1.0,-1.0,
      -1.0,-1.0,-1.0,
      -1.0, 1.0, 1.0,
      -1.0, 1.0,-1.0,
      1.0,-1.0, 1.0,
      -1.0,-1.0, 1.0,
      -1.0,-1.0,-1.0,
      -1.0, 1.0, 1.0,
      -1.0,-1.0, 1.0,
      1.0,-1.0, 1.0,
      1.0, 1.0, 1.0,
      1.0,-1.0,-1.0,
      1.0, 1.0,-1.0,
      1.0,-1.0,-1.0,
      1.0, 1.0, 1.0,
      1.0,-1.0, 1.0,
      1.0, 1.0, 1.0,
      1.0, 1.0,-1.0,
      -1.0, 1.0,-1.0,
      1.0, 1.0, 1.0,
      -1.0, 1.0,-1.0,
      -1.0, 1.0, 1.0,
      1.0, 1.0, 1.0,
      -1.0, 1.0, 1.0,
      1.0,-1.0, 1.0,
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

    if (this.rotating) {

      this.rotation += this.rotationSpeed * delta;

    }

    /**
     * @fixme This should not be always recalculated.
     */
    this.buildTransformations();
    this.verticesPositions = this.getVerticesPositions();

  }

}

class CubeGui {

  final cube:Cube;

  final xHandle:Handle;
  final yHandle:Handle;
  final widthHandle:Handle;
  final heightHandle:Handle;
  final rotationHandle:Handle;
  final activeHandle:Handle;

  public function new(cube:Cube) {

    this.cube = cube;

    this.xHandle = new Handle({value: this.cube.position.x});
    this.yHandle = new Handle({value: this.cube.position.y});
    this.widthHandle = new Handle({value: this.cube.scale.x});
    this.heightHandle = new Handle({value: this.cube.scale.y});
    this.rotationHandle = new Handle({value: this.cube.rotationSpeed});
    this.activeHandle = new Handle({selected: this.cube.active});

  }

  public function render(ui:Zui, scale:Float) {

    this.cube.active = ui.check(this.activeHandle, 'Visible');
    this.cube.position.x = ui.slider(this.xHandle, 'X', 0, 1000, true, 1);
    this.cube.position.y = ui.slider(this.yHandle, 'Y', 0, 1000, true, 1);
    this.cube.scale.x = ui.slider(this.widthHandle, 'Width', 0, 300, true, 1);
    this.cube.scale.y = ui.slider(this.heightHandle, 'Height', 0, 300, true, 1);
    this.cube.rotationSpeed = ui.slider(this.rotationHandle, 'Rotation speed', 0, 100, true);

  }

}
