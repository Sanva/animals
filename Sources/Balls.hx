
import Ball;

import kha.graphics2.Graphics;
import kha.math.FastVector2;
import kha.Color;
import kha.Sound;
import zui.Id;
import zui.Zui;

using kha.graphics2.GraphicsExtension;
using Math;

typedef BallsProps = {
	active:Bool,
	position:FastVector2,
  radius:Float,
	?direction:FastVector2,
  ?speed:Float,
	?color:Null<Color>,
	?borderColor:Null<Color>,
	?hitSound:Null<Sound>,
}

class Balls {

	public var position:FastVector2;
	public var direction:FastVector2;
  public var radius:Float;
  public var speed:Float;
  public var color:Null<Color>;
  public var borderColor:Null<Color>;
  public var hitSound:Null<Sound>;
  public var active:Bool;

  final balls:Array<Ball> = [];

  public var length(get, never):Int;
  private function get_length():Int {

    return this.balls.length;

  }

	public function new(props:BallsProps) {

    this.active = props.active;
		this.position = new FastVector2(props.position.x, props.position.y);
    this.radius = props.radius;
    this.speed = props.speed != null ? props.speed : 0.1;
    this.direction = props.direction != null ? new FastVector2(props.direction.x, props.direction.y) : new FastVector2(0, 0);
		this.color = props.color;
    this.borderColor = props.borderColor;

    this.hitSound = props.hitSound;

  }

  public function addDefault() {

    this.balls.push(new Ball({
      position: position,
      radius: radius,
      direction: direction,
      speed: speed,
      color: color,
      borderColor: borderColor,
      hitSound: hitSound
    }));

  }

  public function deleteLast() {

    this.balls.pop();

  }

  public function clear() {

    this.balls.splice(0, this.balls.length);

  }

  public function update(delta:Float) {

    if (!this.active) {

      return;

    }

    for (ball in this.balls) {

      ball.update(delta);

    }

  }

	public function render(graphics:Graphics):Void {

    if (!this.active) {

      return;

    }

    for (ball in this.balls) {

      ball.render(graphics);

    }

  }

}

class BallsGui {

  final balls:Balls;

  final activeHandle:Handle;

  public function new(balls:Balls) {

    this.balls = balls;

    this.activeHandle = Id.handle({selected: this.balls.active});

  }

  public function render(ui:Zui, scale:Float) {

    balls.active = ui.check(this.activeHandle, 'Visible');

    ui.text('Count: ${this.balls.length}');

    if (ui.button('Add')) {

      this.balls.addDefault();

    }

    if (ui.button('Remove')) {

      this.balls.deleteLast();

    }

    if (ui.button('Clear')) {

      this.balls.clear();

    }

  }

}
