
import Block;

import kha.graphics2.Graphics;
import kha.Color;
import kha.Font;

typedef ButtonProps = {
  > BlockProps,
  ?label:String,
  ?font: Font,
  ?fontColor: Color,
  ?fontSize: Int,
  ?pressedColor:Null<Color>,
  ?upOutsideBounds:Bool,
}

class Button extends Block {

  var label(default, set):String;
  private function set_label(value:String):String {

    if (this.font == null) {

      this.labelWidth = 0;
      this.labelHeight = 0;

    } else {

      this.labelWidth = this.font.width(this.fontSize, value);
      this.labelHeight = this.font.height(this.fontSize);

    }

    return this.label = value;

  }

  var labelWidth:Float;
  var labelHeight:Float;

  var font:Null<Font> = null;
  var fontColor:Null<Color>;
  var fontSize:Int;

  var pressed:Int = -1;
  var upOutsideBounds:Bool;
  var pressedColor:Null<Color>;

	public function new(props:ButtonProps) {

    super(props);

    this.fontSize = props.fontSize != null ? props.fontSize : 12;
    this.fontColor = props.fontColor;

    if (props.font == null) {

      this.label = '';

    } else {

      this.font = props.font;
      this.label = props.label;

    }

    this.pressedColor = props.pressedColor;
    this.upOutsideBounds = props.upOutsideBounds != null ? props.upOutsideBounds : false;

  }

  public inline function isPressed():Bool {

    return this.pressed != -1;

  }

  public function onMouseDown(button:Int, xPos:Int, yPos:Int):Bool {

    switch (button) {

      case 0 if (this.minX < xPos && xPos < this.maxX && this.minY < yPos && yPos < this.maxY):

        this.pressed = button;
        return true;

      default: return false;

    }

  }

  public function onMouseUp(button:Int, xPos:Int, yPos:Int) {

    this.pressed = -1;

    switch (button) {

      case 0 if (this.upOutsideBounds || this.minX < xPos && xPos < this.maxX && this.minY < yPos && yPos < this.maxY):

        return true;

      default: return false;

    }

  }

  private override function drawShape(graphics:Graphics):Void {

    super.drawShape(graphics);

    if (this.font != null || this.label != '') {

      graphics.font = this.font;
      graphics.fontSize = this.fontSize;

      if (this.fontColor != null) {

        graphics.color = this.fontColor;

      }

      graphics.drawString(this.label, this.x - this.labelWidth / 2, this.y - this.labelHeight / 2);

    }

  }

  public override function getFillColor() {

    if (this.pressed != -1 && this.pressedColor != null) {

      return this.pressedColor;

    }

    return super.getFillColor();

  }

}