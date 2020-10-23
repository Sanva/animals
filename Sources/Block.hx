
import Camera;

import kha.graphics2.Graphics;
import kha.Color;
import zui.Id;
import zui.Ext;
import zui.Zui;

using Math;

typedef BlockProps = {
	x:Int,
	y:Int,
	width:Int,
	height:Int,
	active:Bool,
	?rotating:Bool,
	?color:Null<Color>,
	?camera:Null<Camera>,
}

class Block {

  public var x:Int;
  public var y:Int;

	public var width(default, set):Int;
  private function set_width(value:Int):Int {

    this.width = value;
    this.halfWidth = (value / 2).round();

    return value;

  }

  public var height(default, set):Int;
  private function set_height(value:Int):Int {

    this.height = value;
    this.halfHeight = (value / 2).round();

    return value;

  }

  public var active:Bool = true;
	public var rotating:Bool = false;
	public var color:Null<Color> = null;
	public var camera:Null<Camera> = null;

  public var minX(get, never):Int;
  public function get_minX() return this.x - this.halfWidth;

  public var minY(get, never):Int;
  public function get_minY() return this.y - this.halfHeight;

  public var maxX(get, never):Int;
  public function get_maxX() return this.x + this.halfWidth;

  public var maxY(get, never):Int;
  public function get_maxY() return this.y + this.halfHeight;

  private var rotation:Float = 0;
  public var rotationSpeed:Float = 1;

  private var halfWidth:Int;
  private var halfHeight:Int;

	public function new(props:BlockProps) {

    this.x = props.x;
    this.y = props.y;

    this.width = props.width;
    this.halfWidth = (this.width / 2).round();
    this.height = props.height;
    this.halfHeight = (this.height / 2).round();

    this.active = props.active;
    this.rotating = props.rotating;
		this.color = props.color;
		this.camera = props.camera;

  }

  public function update(delta:Float) {

    if (this.rotating) {

      this.rotation += this.rotationSpeed * delta;

    }

  }

	public function render(graphics:Graphics):Void {

		if (!this.active) {

			return;

    }

    final fillColor = this.getFillColor();
		if (fillColor != null) {

			graphics.color = fillColor;

    }

    if (this.rotating) {

      final cameraXOffset = this.camera != null ? this.camera.x : 0;
      final cameraYOffset = this.camera != null ? this.camera.y : 0;
      graphics.pushRotation(this.rotation, this.x + cameraXOffset, this.y + cameraYOffset);

    }

    this.drawShape(graphics);

    if (this.rotating) {

      graphics.popTransformation();

    }

    // graphics.color = Color.Red;
    // graphics.drawRect(this.x - this.halfWidth, this.y - this.halfHeight, this.width, this.height, 2);

  }

  private function drawShape(graphics:Graphics):Void {

    graphics.fillRect(this.x - this.halfWidth, this.y - this.halfHeight, this.width, this.height);

  }

  private function getFillColor() {

    return this.color;

  }

}

class BlockGui {

  final block:Block;

  final xHandle:Handle;
  final yHandle:Handle;
  final widthHandle:Handle;
  final heightHandle:Handle;
  final rotationHandle:Handle;
  final activeHandle:Handle;
  final colorHandle:Handle;

  public function new(block:Block) {

    this.block = block;

    this.xHandle = Id.handle({value: this.block.x});
    this.yHandle = Id.handle({value: this.block.y});
    this.widthHandle = Id.handle({value: this.block.width});
    this.heightHandle = Id.handle({value: this.block.height});
    this.rotationHandle = Id.handle({value: this.block.rotationSpeed});
    this.activeHandle = Id.handle({selected: this.block.active});
    this.colorHandle = Id.handle({color: block.color});

  }

  public function render(ui:Zui, scale:Float) {

    block.active = ui.check(this.activeHandle, 'Visible');
    block.x = Math.round(ui.slider(this.xHandle, 'X', 0, 1000, true, 1) * scale);
    block.y = Math.round(ui.slider(this.yHandle, 'Y', 0, 1000, true, 1) * scale);
    block.width = Math.round(ui.slider(this.widthHandle, 'Width', 0, 300, true, 1) * scale);
    block.height = Math.round(ui.slider(this.heightHandle, 'Height', 0, 300, true, 1) * scale);
    block.rotationSpeed = ui.slider(this.rotationHandle, 'Rotation speed', 0, 100, true);

    if (ui.panel(Id.handle({selected: true}), 'Color')) {

      this.block.color = Ext.colorWheel(ui, this.colorHandle);

    }

  }

}
