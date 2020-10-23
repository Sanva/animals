
import kha.graphics2.Graphics;
import kha.Color;
import kha.Scheduler;
import zui.Id;
import zui.Ext;
import zui.Zui;

using kha.graphics2.GraphicsExtension;
using Math;

typedef ConcentricCirclesAnimationProps = {
  ?radiusOffset:Null<(radiusOffset:Float, delta:Float) -> Float>,
}

typedef ConcentricCirclesProps = {
	x:Int,
	y:Int,
  radius:Float,
  step:Float,
  active:Bool,
  ?color:Null<Color>,
  ?animation:Null<ConcentricCirclesAnimationProps>,
}

class ConcentricCircles {

	public var x:Int;
	public var y:Int;
  public var radius:Float;
  public var radiusOffset:Float = 0;
  public var step:Float;
  public var stepOffset:Float = 0;
  public var active:Bool = true;
  public var color:Null<Color> = null;
  public var animation:Null<ConcentricCirclesAnimationProps>;

  public var xDirection:Int;
  public var yDirection:Int;

  public var minX(get, never):Int;
  public function get_minX() return this.x - this.radius.round();

  public var minY(get, never):Int;
  public function get_minY() return this.y - this.radius.round();

  public var maxX(get, never):Int;
  public function get_maxX() return this.x + this.radius.round();

  public var maxY(get, never):Int;
  public function get_maxY() return this.y + this.radius.round();

	public function new(props:ConcentricCirclesProps) {

		this.x = props.x;
		this.y = props.y;
    this.radius = props.radius;
    this.step = props.step;
    this.active = props.active;
    this.color = props.color;
    this.animation = props.animation;

  }

  public function update(delta:Float) {

    if (!this.active) {

      return;

    }

    if (this.animation != null) {

      if (this.animation.radiusOffset != null) {

        this.radiusOffset = this.animation.radiusOffset(this.radiusOffset, delta);

      }

    }

  }

	public function render(graphics:Graphics):Void {

    if (!this.active || this.step <= 0) {

			return;

    }

		if (this.color != null) {

			graphics.color = this.color;

    }

    var r = 0.0;
    while (r <= this.radius) {

      graphics.drawCircle(this.x, this.y, r + this.radiusOffset);

      r += this.step;

    }

  }

  private function getFillColor() {

    return this.color;

  }

}

class ConcentricCirclesGui {

  final concentricCircles:ConcentricCircles;

  final xHandle:Handle;
  final yHandle:Handle;
  final radiusHandle:Handle;
  final stepHandle:Handle;
  final activeHandle:Handle;
  final animationHandle:Handle;
  final colorHandle:Handle;

  public function new(concentricCircles:ConcentricCircles) {

    this.concentricCircles = concentricCircles;

    this.xHandle = Id.handle({value: this.concentricCircles.x});
    this.yHandle = Id.handle({value: this.concentricCircles.y});
    this.radiusHandle = Id.handle({value: this.concentricCircles.radius});
    this.stepHandle = Id.handle({value: this.concentricCircles.step});
    this.activeHandle = Id.handle({selected: this.concentricCircles.active});
    this.animationHandle = Id.handle({selected: this.concentricCircles.animation != null});
    this.colorHandle = Id.handle({color: concentricCircles.color});

  }

  public function render(ui:Zui, scale:Float) {

    this.concentricCircles.active = ui.check(this.activeHandle, 'Visible');

    if (ui.check(this.animationHandle, 'Animate')) {

      this.concentricCircles.animation = {
        radiusOffset: (offset:Float, delta:Float) -> offset - Math.sin(Scheduler.time() * 2),
      };

    } else {

      this.concentricCircles.animation = null;
      this.concentricCircles.radiusOffset = 0;

    }

    this.concentricCircles.x = Math.round(ui.slider(this.xHandle, 'X', 0, 1000, true, 1) * scale);
    this.concentricCircles.y = Math.round(ui.slider(this.yHandle, 'Y', 0, 1000, true, 1) * scale);
    this.concentricCircles.radius = Math.round(ui.slider(this.radiusHandle, 'Radius', 0, 300, true) * scale);
    this.concentricCircles.step = Math.round(ui.slider(this.stepHandle, 'Step', 1, 30, true) * scale);

    if (ui.panel(Id.handle({selected: true}), 'Color')) {

      this.concentricCircles.color = Ext.colorWheel(ui, this.colorHandle);

    }

  }

}
