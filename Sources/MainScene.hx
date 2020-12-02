
import Cube.CubeGui;
import Balls;
import Behaviour;
import Block;
import Camera02;
import Camera;
import ConcentricCircles;
import DebugGrid;
import Player;
import PlayerSprite;
import Scene;
import ShaderBlock02;
import Sprite;

import haxe.ds.ArraySort;
import iron.math.Vec4;
import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.System;
import kha.audio1.Audio;
import kha.audio1.AudioChannel;
import kha.math.FastMatrix3;
import kha.math.FastVector2;
import zui.Id;
import zui.Zui;

using Math;

typedef MainSceneProps = {
  > SceneProps,
}

class MainScene extends Scene {

  final camera:Camera;
  public final shaderCamera:Camera02;
  public var rightCameraMargin:Int = 0;

  final debugGrid:DebugGrid;
  final debugGridGui:DebugGridGui;

  final block:Block;
  final blockGui:BlockGui;

  public final shaderBlock:ShaderBlock02;
  final shaderBlockGui:ShaderBlock02Gui;

  final concentricCircles:ConcentricCircles;
  final concentricCirclesGui:ConcentricCirclesGui;

  final balls:Balls;
  final ballsGui:BallsGui;

  public var activeObject:Null<Sprite> = null;
  public var player:Null<Player>;
  final dog:Player;
  final dog02:Player;
  final cat:Player;
  final characters:Array<Player>;

  final sound:AudioChannel;
  final soundVolumeHandle:Handle;
  var soundPlaying:Bool = false;

  final dogBehaviour:Behaviour;

  public final sprite:Sprite;
  final spriteGui:SpriteGui;

  public final sprite02:Sprite;
  final spriteGui02:SpriteGui;

  public final sprite03:PlayerSprite;
  final spriteGui03:PlayerSpriteGui;

  public final debugRect:Rectangle;

  final cube:Cube;
  final cubeGui:CubeGui;

	public function new(props:SceneProps) {

    super(props);

    this.balls = new Balls({
      active: false,
      position: new FastVector2(400 * this.scale, 300 * this.scale),
      radius: 6 * this.scale,
      speed: 300 * this.scale,
      color: Color.fromString('#3E5EA4'),
      borderColor: Color.Cyan,
      direction: new FastVector2(1, 1),
      hitSound: Assets.sounds.fruit_impact,
    });
    this.balls.addDefault();
    this.ballsGui = new BallsGui(this.balls);

    this.dog = new Player({
      x: (System.windowWidth() / 2 + 30 * this.scale).round(),
      y: (System.windowHeight() / 2).round(),
      width: 34,
      height: 34,
      scale: this.scale,
      speed: 4.0 * this.scale,
      active: true,
      image: Assets.images.dog,
    });

    this.dog02 = new Player({
      x: (System.windowWidth() / 2 + 30 * this.scale).round(),
      y: (System.windowHeight() / 2 - 60 * this.scale).round(),
      width: 30,
      height: 36,
      scale: this.scale,
      speed: 4.1 * this.scale,
      active: true,
      image: Assets.images.dog02,
    });

    this.cat = new Player({
      x: Math.floor(System.windowWidth() / 2),
      y: Math.floor(System.windowHeight() / 2 - 30 * this.scale),
      width: 30,
      height: 34,
      scale: this.scale,
      speed: 5.0 * this.scale,
      active: true,
      image: Assets.images.cat,
    });

    this.characters = [
      this.dog,
      this.dog02,
      this.cat,
    ];

    this.player = this.cat;

    this.camera = new Camera({
      x: (System.windowWidth() / 2 - this.player.x).round(),
      y: (System.windowHeight() / 2 - this.player.y).round(),
    });

    this.block = new Block({
      x: (System.windowWidth() / this.scale / 2).round(),
      y: (System.windowHeight() / this.scale / 2).round(),
      width: (64 * this.scale).round(),
      height: (64 * this.scale).round(),
      active: false,
      rotating: true,
      color: Color.fromString('#ffdf85ff'),
      camera: this.camera,
    });
    this.blockGui = new BlockGui(this.block);

    this.shaderBlock = new ShaderBlock02({
      active: false,
    });
    this.shaderBlockGui = new ShaderBlock02Gui(this.shaderBlock);

    this.sprite = new Sprite({
      position: new FastVector2(System.windowWidth() / 2, System.windowHeight() / 2),
      scale: new Vec4(64, 64),
      active: false,
      rotating: true,
      color: Color.fromFloats(0.0, 0.0, 1.0, 0.6),
    });
    this.sprite.z = -2.0;

    this.spriteGui = new SpriteGui(this.sprite, () -> { this.activeObject = this.sprite; });

    this.sprite02 = new Sprite({
      position: new FastVector2(System.windowWidth() / 2 + 64, System.windowHeight() / 2 + 64),
      scale: new Vec4(108, 192),
      active: false,
      rotating: true,
      color: Color.fromFloats(1.0, 1.0, 1.0, 1.0),
      texture: Assets.images.pen,
      textureFilter: AnisotropicFilter,
    });
    this.sprite02.rotationSpeed = 0;
    this.sprite02.z = -2.0;
    this.sprite02.verticesUVs = [
      1,  0, // Bottom right 0
      0,  1, // Top left     1
      1,  1, // Top right    2
      0,  0, // Bottom left  3
    ];

    this.spriteGui02 = new SpriteGui(this.sprite02, () -> { this.activeObject = this.sprite02; });

    this.sprite03 = new PlayerSprite({
      position: new FastVector2(System.windowWidth() / 2 + 64, System.windowHeight() / 2 + 64),
      // scale: new Vec4(30, 34),
      scale: new Vec4(64, 64),
      speed: 400,
      active: false,
      rotating: true,
      color: Color.fromFloats(1.0, 1.0, 1.0, 1.0),
      texture: Assets.images.catPOT,
    });
    this.sprite03.rotationSpeed = 0;
    this.sprite03.z = -2.0;

    this.spriteGui03 = new PlayerSpriteGui(this.sprite03, () -> { this.activeObject = this.sprite03; });

    this.debugRect = new Rectangle({
      x: 0,
      y: 0,
      width: 0,
      height: 0
    });

    this.cube = new Cube({
      scale: new Vec4(100, 100, 100),
      active: false,
      rotating: true,
      texture: Assets.images.uvtemplate,
      color: Color.fromFloats(1.0, 1.0, 1.0, 1.0),
      textureFilter: AnisotropicFilter,
    });
    this.cubeGui = new CubeGui(this.cube);

    this.concentricCircles = new ConcentricCircles({
      x: this.block.x,
      y: this.block.y,
      radius: this.block.width,
      step: 10,
      color: Color.Blue,
      active: false,
    });

    this.concentricCirclesGui = new ConcentricCirclesGui(this.concentricCircles);

    this.debugGrid = new DebugGrid({
      x: 0,
      y: 0,
      width: 1000,
      height: 1000,
      color: Color.Black,
      active: true,
      labels: false,
      subgrid: false,
      scale: this.scale,
    });

    this.debugGridGui = new DebugGridGui(this.debugGrid);

    this.sound = Audio.play(Assets.sounds.Our_French_Cafe, true);
    this.sound.stop();
    this.soundVolumeHandle = Id.handle({value: 1.0});

    this.shaderCamera = new Camera02({
      position: new FastVector2(0, 0),
      tilePixels: this.scale.round(),
      widthTiles: (System.windowWidth() / this.scale).round(),
      heightTiles: (System.windowHeight() / this.scale).round(),
    });

    this.dogBehaviour = new Behaviour();
    this.dogBehaviour.stepSeconds = 0.2;
    this.dogBehaviour.actions = [
      () -> this.dog02.inRange(this.dog, 100 * this.scale) ? this.dog02.stop() : this.dog02.walk(this.dog02.getDirection(this.dog)),
    ];
    this.dogBehaviour.run();

  }

  public function toggleCharacter() {

    this.activeObject = null;
    this.player = this.player == this.cat ? this.dog : this.cat;

  }

  public function onMouseDown(button:Int, xPos:Int, yPos:Int) {

    this.shaderBlock.onMouseDown(button, xPos, yPos);

  }

  public function onMouseUp(button:Int, xPos:Int, yPos:Int) {

    this.shaderBlock.onMouseUp(button, xPos, yPos);

  }

  public function onMouseMove(xPos:Int, yPos:Int, moveX:Int, moveY:Int) {

    this.shaderBlock.onMouseMove(xPos, yPos);

  }

  public function onWindowResize(width:Int, height:Int) {

    this.shaderCamera.widthTiles = (width / this.scale).round();
    this.shaderCamera.heightTiles = (height / this.scale).round();
    this.shaderCamera.adjustProjection();

    this.debugGrid.resize((width / this.scale).round(), (height / this.scale).round());

  }

  public function getActiveObjects():Array<GameObject> {

    final sprites = new Array<GameObject>();

    if (this.cube.active) {

      sprites.push(this.cube);

    }

    if (this.sprite02.active) {

      sprites.push(this.sprite02);

    }

    if (this.sprite03.active) {

      sprites.push(this.sprite03);

    }

    if (this.sprite.active) {

      sprites.push(this.sprite);

    }

    return sprites;

  }

  public override function update(delta:Float) {

    super.update(delta);

    final windowWidth = System.windowWidth();
    final windowHeight = System.windowHeight();

    this.block.update(delta);
    this.debugGrid.update(delta);
    this.balls.update(delta);
    this.concentricCircles.update(delta);
    this.dogBehaviour.update(delta);

    for (character in this.characters) {

      character.update();

    }

    ArraySort.sort(this.characters, (a, b) -> {

      if (a.y < b.y) {

        return -1;

      }

      if (a.y > b.y) {

        return 1;

      }

      return 0;

    });

    if (this.activeObject != null) {

      this.camera.move(
        ((windowWidth - this.rightCameraMargin) / 2 - this.activeObject.position.x * this.scale).round(),
        (windowHeight / 2 - this.activeObject.position.y * this.scale).round(),
        0.2
      );

      final shaderCameraX = (this.activeObject.position.x + this.rightCameraMargin / this.scale * 0.5).round();
      final shaderCameraY = (this.activeObject.position.y).round();

      this.shaderCamera.move(shaderCameraX, shaderCameraY, 0.2);
      this.debugGrid.move(shaderCameraX, shaderCameraY);

    } else if (this.player != null) {

      this.camera.move(((windowWidth - this.rightCameraMargin) / 2 - this.player.x).round(), (windowHeight / 2 - this.player.y).round(), 0.2);

      final shaderCameraX = (this.player.x / this.scale + this.rightCameraMargin / this.scale * 0.5).round();
      final shaderCameraY = (this.player.y / this.scale).round();

      this.shaderCamera.move(shaderCameraX, shaderCameraY, 0.2);
      this.debugGrid.move(shaderCameraX, shaderCameraY);

    }

    this.camera.update();
    this.shaderCamera.update();

    for (object in this.getActiveObjects()) {

      object.update(delta);

    }

    this.spriteGui.update();
    this.spriteGui02.update();
    this.spriteGui03.update();

    this.debugRect.x = this.sprite03.minX.round();
    this.debugRect.y = this.sprite03.minY.round();
    this.debugRect.width = this.sprite03.scale.x.round();
    this.debugRect.height = this.sprite03.scale.y.round();

  }

  public override function render(framebuffer:Framebuffer):Void {

    super.render(framebuffer);

    final graphics = framebuffer.g2;

    graphics.transformation = FastMatrix3.identity();
    graphics.translate(this.camera.x, this.camera.y);

    this.debugGrid.render(graphics);
    this.block.render(graphics);
    this.concentricCircles.render(graphics);

    for (character in this.characters) {

      character.render(graphics);

    }

    final distanceX = this.dog.x - this.cat.x;
    final distanceY = this.dog.y - this.cat.y;
    final distanceSquared = distanceX * distanceX + distanceY * distanceY;

    graphics.font = Assets.fonts.RussoOne_Regular;
    graphics.fontSize = (16 * this.scale).round();
    graphics.drawString(
      'Distance: ${distanceSquared.sqrt().round()}\nx: ${distanceX}\ny: ${distanceY}',
      (this.dog.x + 32 * this.scale).round(),
      (this.dog.y + 32 * this.scale).round()
    );

    if (this.sprite03.active) {

      this.debugRect.render(graphics);

    }

    graphics.transformation = FastMatrix3.identity();

    this.balls.render(graphics);

    // this.camera.render(graphics);

  }

  public function renderUi(ui:Zui):Void {

    if (ui.panel(Id.handle(), 'Rotating Rectangle')) {

      this.blockGui.render(ui, this.scale);

    }

    if (ui.panel(Id.handle(), 'Concentric Circles')) {

      this.concentricCirclesGui.render(ui, this.scale);

    }

    if (ui.panel(Id.handle(), 'Balls')) {

      this.ballsGui.render(ui, this.scale);

    }

    if (ui.panel(Id.handle(), 'Grid')) {

      this.debugGridGui.render(ui, this.scale);

    }

    if (ui.panel(Id.handle(), 'Audio')) {

      ui.text('Our French Cafe');

      #if kha_html5
      if (ui.button('YouTube')) {

        System.loadUrl('https://www.youtube.com/watch?v=ccYpgiylfQI');

      }
      #end

      if (ui.button(this.soundPlaying ? 'Stop' : 'Play')) {

        if (this.soundPlaying) {

          this.sound.stop();
          this.soundPlaying = false;

        } else {

          this.sound.play();
          this.soundPlaying = true;

        }

      }

      this.sound.volume = ui.slider(this.soundVolumeHandle, 'Volume', 0.0, 1.0, true);

    }

    if (ui.panel(Id.handle(), 'Shader Block')) {

      this.shaderBlockGui.render(ui, this.scale);

    }

    if (ui.panel(Id.handle(), 'Sprite')) {

      this.spriteGui.render(ui, this.scale);

    }

    if (ui.panel(Id.handle(), 'Textured Sprite')) {

      this.spriteGui02.render(ui, this.scale);

    }

    if (ui.panel(Id.handle(), 'Tilesheet Sprite')) {

      this.spriteGui03.render(ui, this.scale);

    }

    if (ui.panel(Id.handle(), 'Cube')) {

      this.cubeGui.render(ui, this.scale);

    }

  }

}