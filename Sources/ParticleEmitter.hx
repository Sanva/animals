
import Particle;

import kha.graphics2.Graphics;
import kha.Color;
import kha.System;

using kha.graphics2.GraphicsExtension;
using Math;

typedef ParticleEmitterProps = {
  amount:Int,
  power:Float,
  ?size:Float,
  ?active:Bool,
  ?color:Color,
  ?acceleration:Float,
}

class ParticleEmitter {

  public var active:Bool;
  public var power:Float;

  var particles:Array<Particle> = [];

	public function new(props:ParticleEmitterProps) {

    this.power = props.power;
    this.active = props.active != null ? props.active : false;

		for (i in 0...props.amount) {

      this.particles.push(new Particle({
        color: props.color != null ? props.color : Color.Black,
        size: props.size != null ? props.size : 2.0,
        acceleration: props.acceleration,
      }));

    }

  }

  public function spawn(x:Float, y:Float, lifetime:Float) {

    for (particle in this.particles) {

      particle.position.x = x;
      particle.position.y = y;
      particle.velocity.x = randomRangeFloat(-this.power, this.power);
      particle.velocity.y = randomRangeFloat(-this.power, this.power);
      particle.active = true;
      particle.lifetime = lifetime;

    }

  }

  private function randomRangeFloat(min:Float, max:Float) {

    return (Math.random() * (1 + max - min)).floor() + min;

  }

  public function update(delta:Float) {

    if (!this.active) {

      return;

    }

    for (particle in this.particles) {

      particle.update(delta);

      if (particle.maxX <= 0 || particle.minX >= System.windowWidth()) {

        particle.velocity.x *= -1;

      }

      if (particle.maxY <= 0) {

        particle.velocity.y *= -1;

      }

      if (particle.minY >= System.windowHeight()) {

        particle.active = false;

      }

    }

  }

	public function render(graphics:Graphics):Void {

    if (!this.active) {

      return;

    }

    for (particle in this.particles) {

      particle.render(graphics);

    }

  }

}