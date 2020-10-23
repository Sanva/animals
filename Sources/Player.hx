
import Block.BlockProps;
import Direction;

import kha2d.Animation;
import kha2d.Sprite;
import kha.Image;

using Math;

typedef PlayerProps = {
  > BlockProps,
  image:Image,
  ?scale:Float,
	?speed:Float,
}

class Player extends Sprite {

  public var speed:Float;

  final upWalk:Animation;
  final downWalk:Animation;
  final leftWalk:Animation;
  final rightWalk:Animation;

  final upIdle:Animation;
  final downIdle:Animation;
  final leftIdle:Animation;
  final rightIdle:Animation;

  public var movingUp:Bool = false;
  public var movingDown:Bool = false;
	public var movingLeft:Bool = false;
  public var movingRight:Bool = false;

  public var idle:Bool = true;
  public var direction:Direction = Down;

	public function new(props:PlayerProps) {

		super(props.image, props.width, props.height);
    this.x = props.x;
    this.y = props.y;
    this.scaleX = props.scale != null ? props.scale : 1.0;
    this.scaleY = props.scale != null ? props.scale : 1.0;

    this.speed = props.speed != null ? props.speed : 6.0 * props.scale;

    this.upWalk = Animation.createRange(9, 11, 10);
    this.downWalk = Animation.createRange(0, 2, 10);
    this.leftWalk = Animation.createRange(3, 5, 10);
    this.rightWalk = Animation.createRange(6, 8, 10);

    this.upIdle = Animation.create(10);
    this.downIdle = Animation.create(1);
    this.leftIdle = Animation.create(4);
    this.rightIdle = Animation.create(7);

    this.setAnimation(this.downIdle);

  }

  public function walk(direction:Direction) {

    switch (direction) {

      case Up:

        this.movingUp = true;
        this.movingDown = false;
        this.movingLeft = false;
        this.movingRight = false;

      case Down:

        this.movingUp = false;
        this.movingDown = true;
        this.movingLeft = false;
        this.movingRight = false;

      case Left:

        this.movingUp = false;
        this.movingDown = false;
        this.movingLeft = true;
        this.movingRight = false;

      case Right:

        this.movingUp = false;
        this.movingDown = false;
        this.movingLeft = false;
        this.movingRight = true;

    }

  }

  public function stop() {

    this.movingUp = false;
    this.movingDown = false;
    this.movingLeft = false;
    this.movingRight = false;

  }

  public function getDirection(other:Player):Direction {

    final distanceX = this.x - other.x;
    final distanceY = this.y - other.y;

    if (distanceY.abs() < distanceX.abs()) {

      return distanceX > 0 ? Left : Right;

    } else {

      return distanceY > 0 ? Up : Down;

    }

  }

  public function inRange(other:Player, range:Float) {

    final distanceX = this.x - other.x;
    final distanceY = this.y - other.y;

    return distanceX * distanceX + distanceY * distanceY <= range * range;

  }

	public override function update() {

    super.update();

    final lastX = this.x;
    final lastY = this.y;
    final lastDirection = this.direction;

    if (this.movingUp) {

      this.y -= Math.round(this.speed);
      this.direction = Up;

    }

    if (this.movingDown) {

      this.y += Math.round(this.speed);
      this.direction = Down;

    }

		if (this.movingLeft) {

      this.x -= Math.round(this.speed);
      this.direction = Left;

		}

		if (this.movingRight) {

      this.x += Math.round(this.speed);
      this.direction = Right;

    }

    if (this.movingUp && lastY != this.y) {

      this.setAnimation(this.upWalk);

    } else if (this.movingDown && lastY != this.y) {

      this.setAnimation(this.downWalk);

    } else if (this.movingLeft && lastX != this.x) {

      this.setAnimation(this.leftWalk);

    } else if (this.movingRight && lastX != this.x) {

      this.setAnimation(this.rightWalk);

    } else {

      this.setAnimation(switch (lastDirection) {
        case Up: this.upIdle;
        case Down: this.downIdle;
        case Left: this.leftIdle;
        case Right: this.rightIdle;
      });

    }

	}

}