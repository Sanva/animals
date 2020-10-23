
import ParticleEmitter;

import kha.audio1.Audio;
import kha.audio1.AudioChannel;
import kha.graphics2.Graphics;
import kha.math.FastVector2;
import kha.Color;
import kha.Sound;
import kha.System;

using kha.graphics2.GraphicsExtension;
using Math;

typedef BallProps = {
	position:FastVector2,
  radius:Float,
	?direction:FastVector2,
  ?speed:Float,
	?color:Null<Color>,
	?borderColor:Null<Color>,
	?hitSound:Null<Sound>,
}

class Ball {

  static inline final PARTICLE_LIFETIME = 0.33;

	public var position:FastVector2;
	public var direction:FastVector2;
  public var radius:Float;
  public var speed:Float;
  public var color:Null<Color>;
  public var borderColor:Null<Color>;

  public var minX(get, never):Int;
  public function get_minX() return (this.position.x - this.radius).floor();

  public var minY(get, never):Int;
  public function get_minY() return (this.position.y - this.radius).floor();

  public var maxX(get, never):Int;
  public function get_maxX() return (this.position.x + this.radius).ceil();

  public var maxY(get, never):Int;
  public function get_maxY() return (this.position.y + this.radius).ceil();

  final hitSoundChannel1:Null<AudioChannel> = null;
  final hitSoundChannel2:Null<AudioChannel> = null;

  final particleEmitter:ParticleEmitter;

	public function new(props:BallProps) {

		this.position = new FastVector2(props.position.x, props.position.y);
    this.radius = props.radius;
    this.speed = props.speed != null ? props.speed : 0.1;
    this.direction = props.direction != null ? new FastVector2(props.direction.x, props.direction.y) : new FastVector2(0, 0);
		this.color = props.color;
    this.borderColor = props.borderColor;

    if (props.hitSound != null) {

      this.hitSoundChannel1 = Audio.play(props.hitSound);
      this.hitSoundChannel1.stop();
      this.hitSoundChannel2 = Audio.play(props.hitSound);
      this.hitSoundChannel2.stop();

    }

    this.particleEmitter = new ParticleEmitter({
      amount: 20,
      power: 50,
      size: this.radius / 3,
      active: false,
      color: Color.Yellow,
    });

  }

  public function update(delta:Float) {

    this.position.x += this.direction.x * this.speed * delta;
    this.position.y += this.direction.y * this.speed * delta;

    final windowWidth = System.windowWidth();
    final windowHeight = System.windowHeight();

    if (this.minX < 0) {

      this.direction.x *= -1;
      this.position.x = this.radius.round();
      this.particleEmitter.spawn(0, this.position.y, PARTICLE_LIFETIME);
      this.particleEmitter.active = true;
      this.hitSoundChannel1.play();

    } else if (this.maxX > windowWidth) {

      this.direction.x *= -1;
      this.position.x = windowWidth - this.radius.round();
      this.particleEmitter.spawn(windowWidth, this.position.y, PARTICLE_LIFETIME);
      this.particleEmitter.active = true;
      this.hitSoundChannel1.play();

    }

    if (this.minY < 0) {

      this.direction.y *= -1;
      this.position.y = this.radius.round();
      this.particleEmitter.spawn(this.position.x, 0, PARTICLE_LIFETIME);
      this.particleEmitter.active = true;
      this.hitSoundChannel2.play();

    } else if (this.maxY > windowHeight) {

      this.direction.y *= -1;
      this.position.y = windowHeight - this.radius.round();
      this.particleEmitter.spawn(this.position.x, windowHeight, PARTICLE_LIFETIME);
      this.particleEmitter.active = true;
      this.hitSoundChannel2.play();

    }

    this.particleEmitter.update(delta);

  }

	public function render(graphics:Graphics):Void {

    final fillColor = this.getFillColor();
		if (fillColor != null) {

			graphics.color = fillColor;

    }

    graphics.fillCircle(this.position.x, this.position.y, this.radius);

    if (this.borderColor != null) {

      graphics.color = this.borderColor;

    }

    graphics.drawCircle(this.position.x, this.position.y, this.radius, 2);

    this.particleEmitter.render(graphics);

  }

  private function getFillColor() {

    return this.color;

  }

}