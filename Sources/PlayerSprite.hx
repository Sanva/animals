
import Sprite;
import Spritesheet;

import kha.FastFloat;
import zui.Zui;

using Math;

typedef PlayerSpriteProps = {
  > SpriteProps,
}

class PlayerSprite extends Sprite {

  public var animationPosition:FastFloat = 0;
  public var spritesheet:Spritesheet;
  public var spritesheetIndex:Int = 0;

	public function new(props:PlayerSpriteProps) {

    super(props);

    this.spritesheet = new Spritesheet({
      image: this.texture,
      width: 64,
      height: 64,
    });

    // this.verticesUVs = [
    //   0.648,  1 - 0.439, // Bottom right 0
    //   0.599,  1 - 0.373, // Top left     1
    //   0.648,  1 - 0.373, // Top right    2
    //   0.599,  1 - 0.439, // Bottom left  3
    // ];

  }

  public override function update(delta:Float) {

    super.update(delta);

    final maxVelocity = this.maxVelocity.abs();

    if (maxVelocity > 0) {

      this.animationPosition += maxVelocity * delta * this.speed / 60;
      if (this.animationPosition > 1) {

        this.animationPosition -= 2;

      }

    }

    this.spritesheetIndex = this.animationPosition.floor();
    this.spritesheetIndex += switch (this.direction) {

      case Up: 13;
      case Down: 1;
      case Left: 5;
      case Right: 9;

    }

    this.verticesUVs = spritesheet.getUVs(this.spritesheetIndex);

  }

}

class PlayerSpriteGui extends SpriteGui {

  final playerSprite:PlayerSprite;

  // final spritesheetIndexHandle:Handle;

  public function new(sprite:PlayerSprite, ?setAsActive:() -> Void) {

    super(sprite, setAsActive);

    this.playerSprite = sprite;

    // this.spritesheetIndexHandle = new Handle({value: this.playerSprite.spritesheetIndex});

  }

  public override function render(ui:Zui, scale:Float) {

    super.render(ui, scale);

    // this.playerSprite.spritesheetIndex = ui.slider(this.spritesheetIndexHandle, 'Sprite Index', 0, 11, true, 1).round();

  }

}
