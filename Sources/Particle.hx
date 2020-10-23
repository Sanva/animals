
import kha.audio1.AudioChannel;
import kha.graphics2.Graphics;
import kha.math.FastVector2;
import kha.Color;

using kha.graphics2.GraphicsExtension;
using Math;

typedef ParticleProps = {
	?position:FastVector2,
	?velocity:FastVector2,
  ?size:Float,
  ?speed:Float,
  ?acceleration:Float,
	?color:Null<Color>,
  ?active:Bool,
  ?lifetime:Null<Float>,
}

class Particle {

	public var position:FastVector2;
	public var velocity:FastVector2;
  public var size:Float;
  public var speed:Float;
  public var acceleration:Float;
  public var active:Bool;
  public var color:Null<Color>;
  public var lifetime:Null<Float>;

  public var minX(get, never):Int;
  public function get_minX() return (this.position.x - this.size).floor();

  public var minY(get, never):Int;
  public function get_minY() return (this.position.y - this.size).floor();

  public var maxX(get, never):Int;
  public function get_maxX() return (this.position.x + this.size).ceil();

  public var maxY(get, never):Int;
  public function get_maxY() return (this.position.y + this.size).ceil();

  final hitSoundChannel1:Null<AudioChannel> = null;
  final hitSoundChannel2:Null<AudioChannel> = null;

	public function new(props:ParticleProps) {

		this.position = props.position != null ? new FastVector2(props.position.x, props.position.y) : new FastVector2(0, 0);
    this.velocity = props.velocity != null ? new FastVector2(props.velocity.x, props.velocity.y) : new FastVector2(0, 0);
    this.size = props.size != null ? props.size : 2;
    this.speed = props.speed != null ? props.speed : 5;
    this.acceleration = props.acceleration != null ? props.acceleration : 0;
    this.active = props.active != null ? props.active : false;
    this.color = props.color;
    this.lifetime = props.lifetime;

  }

  public function update(delta:Float) {

    if (!this.active) {

      return;

    }

    if (this.lifetime != null) {

      if (this.lifetime > 0) {

        this.lifetime -= delta;

      } else {

        this.active = false;
        return;

      }

    }

    this.position.x += this.velocity.x * this.speed * delta;
    this.position.y += this.velocity.y * this.speed * delta;
    this.velocity.y -= this.acceleration;

  }

	public function render(graphics:Graphics):Void {

    if (!this.active) {

      return;

    }

    final fillColor = this.getFillColor();
		if (fillColor != null) {

			graphics.color = fillColor;

    }

    final halfSize = this.size / 2;
    graphics.fillRect(this.position.x - halfSize, this.position.y - halfSize, this.size, this.size);

  }

  private function getFillColor() {

    return this.color;

  }

}