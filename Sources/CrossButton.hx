
import Button;

import kha.graphics2.Graphics;
import kha.math.Vector2;
import kha.Color;

using kha.graphics2.GraphicsExtension;
using Math;

typedef CrossButtonProps = {
	> ButtonProps,
}

class CrossButton extends Button {

  final vertices:Array<Vector2>;

  final upButton:Button;
  final downButton:Button;
  final leftButton:Button;
  final rightButton:Button;

  public var upPressed:Bool = false;
  public var downPressed:Bool = false;
  public var leftPressed:Bool = false;
  public var rightPressed:Bool = false;

	public function new(props:CrossButtonProps) {

    super(props);

    final buttonWidth = (this.width / 3).round();
    final buttonHeight = (this.height / 3).round();

    this.vertices = [
      new Vector2(0 + buttonWidth, 0),
      new Vector2(0 + buttonWidth * 2, 0),
      new Vector2(0 + buttonWidth * 2, 0 + buttonHeight),
      new Vector2(0 + this.width, 0 + buttonHeight),
      new Vector2(0 + this.width, 0 + buttonHeight * 2),
      new Vector2(0 + buttonWidth * 2, 0 + buttonHeight * 2),
      new Vector2(0 + buttonWidth * 2, 0 + this.height),
      new Vector2(0 + buttonWidth, 0 + this.height),
      new Vector2(0 + buttonWidth, 0 + buttonHeight * 2),
      new Vector2(0, 0 + buttonHeight * 2),
      new Vector2(0, 0 + buttonHeight),
      new Vector2(0 + buttonWidth, 0 + buttonHeight),
    ];

    this.upButton = new Button({
      x: this.x,
      y: props.y - buttonHeight,
      width: buttonWidth,
      height: buttonHeight,
      pressedColor: props.pressedColor,
      active: props.active,
      color: Color.Red,
      upOutsideBounds: props.upOutsideBounds,
    });

    this.downButton = new Button({
      x: this.x,
      y: props.y + buttonHeight,
      width: buttonWidth,
      height: buttonHeight,
      pressedColor: props.pressedColor,
      active: props.active,
      color: Color.Red,
      upOutsideBounds: props.upOutsideBounds,
    });

    this.leftButton = new Button({
      x: props.x - buttonWidth,
      y: props.y,
      width: buttonWidth,
      height: buttonHeight,
      pressedColor: props.pressedColor,
      active: props.active,
      color: Color.Red,
      upOutsideBounds: props.upOutsideBounds,
    });

    this.rightButton = new Button({
      x: props.x + buttonWidth,
      y: props.y,
      width: buttonWidth,
      height: buttonHeight,
      pressedColor: props.pressedColor,
      active: props.active,
      color: Color.Red,
      upOutsideBounds: props.upOutsideBounds,
    });

  }

  public override function update(delta:Float) {

    super.update(delta);

  }

  public override function onMouseDown(button:Int, xPos:Int, yPos:Int):Bool {

    this.upPressed = this.upButton.onMouseDown(button, xPos, yPos);
    this.downPressed = this.downButton.onMouseDown(button, xPos, yPos);
    this.leftPressed = this.leftButton.onMouseDown(button, xPos, yPos);
    this.rightPressed = this.rightButton.onMouseDown(button, xPos, yPos);

    switch (button) {

      case 0 if (this.upPressed || this.downPressed || this.leftPressed || this.rightPressed):

        this.pressed = button;
        return true;

      default: return false;

    }

  }

  public override function onMouseUp(button:Int, xPos:Int, yPos:Int) {

    final upReleased = this.upButton.onMouseUp(button, xPos, yPos);
    final downReleased = this.downButton.onMouseUp(button, xPos, yPos);
    final leftReleased = this.leftButton.onMouseUp(button, xPos, yPos);
    final rightReleased = this.rightButton.onMouseUp(button, xPos, yPos);

    this.upPressed = this.upPressed && !upReleased;
    this.downPressed = this.downPressed && !downReleased;
    this.leftPressed = this.leftPressed && !leftReleased;
    this.rightPressed = this.rightPressed && !rightReleased;

    if (!this.upPressed && !this.downPressed && !this.leftPressed && !this.rightPressed) {

      this.pressed = -1;

    }

    switch (button) {

      case 0 if (upReleased || downReleased || leftReleased || rightReleased):

        return true;

      default: return false;

    }

  }

  public override function drawShape(graphics:Graphics) {

    final buttonWidth = this.width / 3;
    final buttonHeight = this.height / 3;

    graphics.fillRect(this.minX + buttonWidth, this.minY, buttonWidth, this.height);
    graphics.fillRect(this.minX, this.minY + buttonHeight, buttonWidth, buttonHeight);
    graphics.fillRect(this.minX + buttonWidth * 2, this.minY + buttonHeight, buttonWidth, buttonHeight);

    graphics.color = Color.Black;
    graphics.drawPolygon(this.minX, this.minY, this.vertices, 2);

    // this.upButton.render(graphics);
    // this.downButton.render(graphics);
    // this.leftButton.render(graphics);
    // this.rightButton.render(graphics);

    // graphics.drawRect(this.x - this.halfWidth, this.y - this.halfHeight, this.width, this.height);

  }

}