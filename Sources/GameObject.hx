
import kha.graphics4.TextureFilter;
import kha.Assets;
import kha.Image;
import kha.math.FastVector2;
import kha.FastFloat;
import zui.Zui;

using Math;

typedef GameObjectProps = {
  ?active:Bool,
  ?position:FastVector2,
  ?texture:Image,
  ?textureFilter:TextureFilter,
}

class GameObject {

  public var active:Bool;
  public var position:FastVector2;
  public var texture:Image;
  public var textureFilter:TextureFilter;

  public var indicesCount:Int = 0;
  public var verticesCount:Int = 0;
  public var structureLength:Int = 0;

  public var verticesPositions:Array<FastFloat> = [];
  public var verticesColors:Array<FastFloat> = [];
  public var verticesUVs:Array<FastFloat> = [];

  public var indices:Array<Int> = [];

	public function new(props:GameObjectProps) {

    this.active = props.active != null ? props.active : false;
    this.position = props.position != null ? new FastVector2(props.position.x, props.position.y) : new FastVector2(0, 0);
    this.texture = props.texture != null ? props.texture : Assets.images.white;
    this.textureFilter = props.textureFilter != null ? props.textureFilter : PointFilter;

  }

  public function update(delta:Float) {}

}

class GameObjectGui {

  final gameobject:GameObject;

  final activeHandle:Handle;
  final xHandle:Handle;
  final yHandle:Handle;

  public function new(gameobject:GameObject) {

    this.gameobject = gameobject;

    this.activeHandle = new Handle({selected: this.gameobject.active});
    this.xHandle = new Handle({value: this.gameobject.position.x});
    this.yHandle = new Handle({value: this.gameobject.position.y});

  }

  public function render(ui:Zui, scale:Float) {

    this.gameobject.active = ui.check(this.activeHandle, 'Visible');
    this.gameobject.position.x = Math.round(ui.slider(this.xHandle, 'X', 0, 1000, true, 1) * scale);
    this.gameobject.position.y = Math.round(ui.slider(this.yHandle, 'Y', 0, 1000, true, 1) * scale);

  }

}
