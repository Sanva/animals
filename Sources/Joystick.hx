
import Button;

import kha.graphics2.Graphics;
import kha.Color;

using kha.graphics2.GraphicsExtension;
using Math;

typedef JoystickProps = {
  > ButtonProps,
  outerRadius:Float,
  innerRadius:Float,
}

class Joystick extends Button {

  public var outerRadius:Float;
  public var innerRadius:Float;

  public var upPressed:Bool = false;
  public var downPressed:Bool = false;
  public var leftPressed:Bool = false;
  public var rightPressed:Bool = false;

  public var movementX:Float = 0.0;
  public var movementY:Float = 0.0;

  private var dragging:Bool = false;
  private var stickXOffset:Int = 0;
  private var stickYOffset:Int = 0;

	public function new(props:JoystickProps) {

    super(props);

    this.outerRadius = props.outerRadius;
    this.innerRadius = props.innerRadius;

  }

  public override function update(delta:Float) {

    super.update(delta);

  }

  public override function onMouseDown(button:Int, xPos:Int, yPos:Int):Bool {

    if (this.minX < xPos && this.maxX > xPos && this.minY < yPos && this.maxY > yPos) {

      this.dragging = true;

    }

    this.pressed = -1;

    return false;

  }

  public override function onMouseUp(button:Int, xPos:Int, yPos:Int) {

    this.dragging = false;
    this.stickXOffset = 0;
    this.stickYOffset = 0;
    this.movementX = 0;
    this.movementY = 0;

    this.pressed = -1;
    this.upPressed = false;
    this.downPressed = false;
    this.leftPressed = false;
    this.rightPressed = false;

    return false;

  }

  public function onMouseMove(xPos:Int, yPos:Int, moveX:Int, moveY:Int) {

    if (this.dragging) {

      final maxOffset = this.outerRadius - this.innerRadius;
      final maxOffsetSquared = maxOffset * maxOffset;
      this.stickXOffset = xPos - this.x;
      this.stickYOffset = yPos - this.y;

      final distanceSquared = this.stickXOffset * this.stickXOffset + this.stickYOffset * this.stickYOffset;
      if (distanceSquared > maxOffsetSquared) {

        final distance = distanceSquared.sqrt();

        this.stickXOffset = (maxOffset * (this.stickXOffset / distance)).round();
        this.stickYOffset = (maxOffset * (this.stickYOffset / distance)).round();

      }

      this.movementX = this.stickXOffset / maxOffset;
      this.leftPressed = this.movementX <= -0.1;
      this.rightPressed = this.movementX >= 0.1;

      this.movementY = this.stickYOffset / maxOffset;
      this.upPressed = this.movementY <= -0.1;
      this.downPressed = this.movementY >= 0.1;

    }

  }

  public override function drawShape(graphics:Graphics) {

    graphics.color = Color.fromBytes(100, 100, 100, 100);
    graphics.fillCircle(this.x, this.y, this.outerRadius);

    final stickX = this.x + this.stickXOffset;
    final stickY = this.y + this.stickYOffset;

    graphics.color = this.getFillColor();
    graphics.fillCircle(stickX, stickY, this.innerRadius);

    graphics.color = Color.Black;
    graphics.drawCircle(stickX, stickY, this.innerRadius, 2);

  }

}