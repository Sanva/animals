
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

  public var scale:Float;

  // public final crossButton:CrossButton;
  public final joystick:Joystick;

	public function new(props:GamepadProps) {

    super(props);

    this.scale = props.scale;

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
      x: 0,
      y: 0,
      width: 0,
      height: 0,
      outerRadius: 0,
      innerRadius: 0,
      pressedColor: props.pressedColor,
      active: this.active,
      rotating: false,
      color: Color.Yellow,
      upOutsideBounds: true,
    });
    this.setupLayout();

  }

  function setupLayout() {

    final size = ((this.height - 25 * this.scale) * 0.5).round();

    this.joystick.x = (this.x - this.width / 4).round();
    this.joystick.y = this.y;
    this.joystick.width = size;
    this.joystick.height = size;
    this.joystick.outerRadius = size;
    this.joystick.innerRadius = ((this.height - 25 * this.scale) * 0.5 * 0.666).round();

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

  public function onWindowResize(width:Int, height:Int) {

    final heightQuarter = height / 4;

    this.x = (width * 0.5).round();
    this.y = (height - heightQuarter + heightQuarter * 0.5).round();
    this.width = width;
    this.height = heightQuarter.round();

    this.setupLayout();

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