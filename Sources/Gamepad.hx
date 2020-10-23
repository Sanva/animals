
import Block;
import CrossButton;
import Joystick;

import kha.graphics2.Graphics;
import kha.Color;

using Math;

typedef GamepadProps = {
  > BlockProps,
  ?pressedColor:Null<Color>,
  scale:Float,
}

class Gamepad extends Block {

  // public final crossButton:CrossButton;
  public final joystick:Joystick;

	public function new(props:GamepadProps) {

    super(props);

    final crossButtonSize = this.height - 25 * props.scale;

    // this.crossButton = new CrossButton({
    //   x: this.minX + (crossButtonSize * 0.5 + 20 * props.scale).round(),
    //   y: this.y,
    //   width: crossButtonSize.round(),
    //   height: crossButtonSize.round(),
    //   pressedColor: props.pressedColor,
    //   active: this.active,
    //   rotating: false,
    //   color: this.color,
    //   upOutsideBounds: true,
    // });

    this.joystick = new Joystick({
      // x: this.minX + (crossButtonSize * 0.5 + 20 * props.scale).round(),
      x: (this.x - this.width / 4).round(),
      y: this.y,
      width: (crossButtonSize * 0.5).round(),
      height: (crossButtonSize * 0.5).round(),
      pressedColor: props.pressedColor,
      active: this.active,
      rotating: false,
      color: Color.Yellow,
      upOutsideBounds: true,
      outerRadius: (crossButtonSize * 0.5).round(),
      innerRadius: (crossButtonSize * 0.5 * 0.666).round(),
    });

  }

  public function onMouseDown(button:Int, xPos:Int, yPos:Int) {

    // this.crossButton.onMouseDown(button, xPos, yPos);
    this.joystick.onMouseDown(button, xPos, yPos);

  }

  public function onMouseUp(button:Int, xPos:Int, yPos:Int) {

    // this.crossButton.onMouseUp(button, xPos, yPos);
    this.joystick.onMouseUp(button, xPos, yPos);

  }

  public function onMouseMove(xPos:Int, yPos:Int, moveX:Int, moveY:Int) {

    this.joystick.onMouseMove(xPos, yPos, moveX, moveY);

  }

	public override function render(graphics:Graphics):Void {

		if (!this.active) {

			return;

    }

    super.render(graphics);

    // this.crossButton.render(graphics);

    this.joystick.render(graphics);

  }

}