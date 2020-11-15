package;

import Button;
import Gamepad;
import MainScene;
import ParticleEmitter;
import Player;

import kha.arrays.Float32Array;
import kha.audio1.Audio;
import kha.audio1.AudioChannel;
import kha.graphics2.Graphics;
import kha.graphics4.CompareMode;
import kha.graphics4.CullMode;
import kha.graphics4.Graphics as Graphics4;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.input.KeyCode;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.Surface;
import kha.Assets;
import kha.Color;
import kha.Display;
import kha.Framebuffer;
import kha.Image;
import kha.Scheduler;
import kha.ScreenCanvas;
import kha.Shaders;
import kha.Sound;
import kha.System;
import kha.Window;
import zui.Id;
import zui.Themes;
import zui.Zui;

using Math;

class Main {

  static final ZUI_THEME:TTheme = {
		NAME: "Default Dark",
		WINDOW_BG_COL: 0xff333333,
		WINDOW_TINT_COL: 0xffffffff,
		ACCENT_COL: 0xff444444,
		ACCENT_HOVER_COL: 0xff494949,
		ACCENT_SELECT_COL: 0xff606060,
		BUTTON_COL: 0xff464646,
		BUTTON_TEXT_COL: 0xffe8e7e5,
		BUTTON_HOVER_COL: 0xff494949,
		BUTTON_PRESSED_COL: 0xff1b1b1b,
		TEXT_COL: 0xffe8e7e5,
		LABEL_COL: 0xffc8c8c8,
		SEPARATOR_COL: 0xff272727,
		HIGHLIGHT_COL: 0xff205d9c,
		CONTEXT_COL: 0xff222222,
		PANEL_BG_COL: 0xff3b3b3b,
		FONT_SIZE: 13,
		ELEMENT_W: 100,
		ELEMENT_H: 24,
		ELEMENT_OFFSET: 4,
		ARROW_SIZE: 5,
		BUTTON_H: 22,
		CHECK_SIZE: 15,
		CHECK_SELECT_SIZE: 8,
		SCROLL_W: 6,
		TEXT_OFFSET: 8,
		TAB_W: 6,
		FILL_WINDOW_BG: true,
		FILL_BUTTON_BG: true,
		FILL_ACCENT_BG: false,
		LINK_STYLE: Line,
	}

  final ui:Zui;
  final uiWindowHandle:Handle;
  final performancePanelHandle:Handle;
  final infoPanelHandle:Handle;

  final button:Button;

  var upKey = false;
  var downKey = false;
  var rightKey = false;
  var leftKey = false;
  var player:Player;

  var scale:Float;

  #if kha_android_native

  var windowWidth:Int;
  var windowHeight:Int;

  #end

  final gamepad:Gamepad;

  // final whiteNoiseChannel:AudioChannel;
  final whiteNoiseSampleRate:Int = 48000;

  // final sineWaveChannel:AudioChannel;
  final sineWaveFrequency:Int = 440;
  final sineWaveSampleRate:Int = 48000;

  final mainScene:MainScene;
  var sceneFadeInSeconds:Float = 0;
  var sceneFadeInRemainingSeconds:Float = 0;

  static inline final PARTICLE_EMITTERS_LENGTH = 10;
  final particleEmitters:Array<ParticleEmitter> = [];
  var lastParticleEmitter = -1;

  var current:Float = 0;
  var delta:Float = 0;
  var timeOneSecond:Float = 0;
  var framesOneSecond:Int = 0;
  var fps:Int = 0;

  final pipeline:PipelineState;
  final renderBatch:RenderBatch;

  final contextMenuRect:Rectangle;
  var contextMenuIsOpen:Bool = false;

  function new() {

    // final whiteNoise = new Sound();
    // whiteNoise.uncompressedData = new Float32Array(this.whiteNoiseSampleRate);
    // for (i in 0...whiteNoise.uncompressedData.length) {

    //   whiteNoise.uncompressedData[i] = Math.random() * 2 - 1;

    // }

    // this.whiteNoiseChannel = Audio.play(whiteNoise, true);
    // this.whiteNoiseChannel.stop();
    // this.whiteNoiseChannel.volume = 1;

    // final sineWave = new Sound();
    // sineWave.uncompressedData = new Float32Array(this.sineWaveSampleRate);
    // final sampleFrequency = this.sineWaveSampleRate / this.sineWaveFrequency;
    // for (i in 0...sineWave.uncompressedData.length) {

    //   sineWave.uncompressedData[i] = Math.sin(i / (sampleFrequency / (Math.PI * 2)));

    // }

    // this.sineWaveChannel = Audio.play(sineWave, true);
    // this.sineWaveChannel.stop();
    // this.sineWaveChannel.volume = 1;

    #if kha_android_native

    this.windowWidth = System.windowWidth();
    this.windowHeight = System.windowHeight();

    this.scale = kha.Display.primary.pixelsPerInch / 160;

    #elseif kha_html5
    this.scale = js.Syntax.code('window.devicePixelRatio') == 1 ? 1 : 2;
    #else
    this.scale = 1.0;
    #end

    // this.scale = 2.0;

    this.ui = new Zui({
      font: Assets.fonts.RussoOne_Regular,
      scaleFactor: this.scale,
      color_wheel: Assets.images.color_wheel,
      theme: ZUI_THEME,
    });
    this.uiWindowHandle = Id.handle();
    this.performancePanelHandle = Id.handle({
      selected: true,
    });
    this.infoPanelHandle = Id.handle({
      selected: false,
    });
    this.contextMenuRect = new Rectangle({
      x: System.windowWidth(),
      y: 0,
      width: (150 * this.scale).round(),
      height: System.windowHeight(),
    });

    final windowHeightQuarter = System.windowHeight() / 4;
    final buttonWidth = (64 * this.scale).round();
    final buttonHeight = (64 * this.scale).round();
    this.button = new Button({
      x: 0,
      y: 0,
      width: buttonWidth,
      height: buttonHeight,
      active: true,
      label: 'A',
      font: Assets.fonts.RussoOne_Regular,
      fontColor: Color.Black,
      fontSize: (32 * this.scale).round(),
      color: Color.Cyan,
      pressedColor: Color.Magenta,
      upOutsideBounds: true,
    });

    this.gamepad = new Gamepad({
      x: 0,
      y: 0,
      width: 0,
      height: 0,
      active: #if kha_android_native true #else true #end,
      color: Color.fromBytes(100, 100, 100, 100),
      pressedColor: Color.fromBytes(100, 100, 100, 50),
      scale: this.scale,
    });

    for (i in 0...PARTICLE_EMITTERS_LENGTH) {

      this.particleEmitters.push(new ParticleEmitter({
        amount: 40,
        power: 50,
        size: 4 * this.scale,
        active: false,
        color: Color.Blue,
        acceleration: -0.9,
      }));

    }

    Keyboard.get().notify(this.onKeyDown, this.onKeyUp);
    Mouse.get().notify(this.onMouseDown, this.onMouseUp, this.onMouseMove, null);
    Surface.get().notify(this.onSurfaceDown, null, null);
    Window.get(0).notifyOnResize(this.onWindowResize);

    this.mainScene = new MainScene({
      scale: this.scale,
    });

    this.onWindowResize(System.windowWidth(), System.windowHeight());

    this.fadeIn(0.66);

    final structure = new VertexStructure();
    structure.add("position", VertexData.Float3);
    structure.add("color", VertexData.Float4);
    structure.add("uv", VertexData.Float2);

    this.pipeline = new PipelineState();
    this.pipeline.inputLayout = [structure];
    this.pipeline.vertexShader = Shaders.shader_vert;
    this.pipeline.fragmentShader = Shaders.shader_frag;
    // pipeline.colorAttachmentCount = 1;
		// pipeline.colorAttachments[0] = kha.graphics4.TextureFormat.RGBA32;
		// pipeline.depthStencilAttachment = kha.graphics4.DepthStencilFormat.Depth16;
    this.pipeline.depthWrite = true;
		this.pipeline.depthMode = Always;
		// this.pipeline.depthMode = Less;
    this.pipeline.cullMode = Clockwise;
    // this.pipeline.cullMode = CounterClockwise;
    this.pipeline.blendSource = SourceAlpha;
		this.pipeline.blendDestination = InverseSourceAlpha;
    this.pipeline.blendOperation = Add;
    this.pipeline.alphaBlendSource = SourceAlpha;
    this.pipeline.alphaBlendDestination = InverseSourceAlpha;
    this.pipeline.alphaBlendOperation = Add;
    // this.pipeline.stencilMode = Always;
    // this.pipeline.stencilBothPass = Keep;
    // this.pipeline.stencilDepthFail = Keep;
    this.pipeline.compile();

    this.renderBatch = new RenderBatch({
      pipeline: this.pipeline,
      setUniforms: (graphics:Graphics4, object:GameObject, batch:RenderBatch) -> {

        graphics.setMatrix(batch.getConstantLocation('MVP'), this.mainScene.shaderCamera.getMVP());

        final textureUnit = batch.getTextureUnit('myTextureSampler');
        graphics.setTexture(textureUnit, object.texture);
        graphics.setTextureParameters(textureUnit, Clamp, Clamp, object.textureFilter, object.textureFilter, NoMipFilter);

      },
    });

    this.current = Scheduler.time();

  }

  function fadeIn(seconds:Float) {

    this.sceneFadeInSeconds = seconds;
    this.sceneFadeInRemainingSeconds = seconds;

  }

  function onKeyDown(key:KeyCode) {

		switch (key) {

      case Up: this.upKey = true;
      case Down: this.downKey = true;
      case Left: this.leftKey = true;
      case Right: this.rightKey = true;

			default: return;

		}

	}

  function onKeyUp(key:KeyCode) {

		switch (key) {

      case Up: this.upKey = false;
      case Down: this.downKey = false;
      case Left: this.leftKey = false;
      case Right: this.rightKey = false;

      case Space:

        this.upKey = false;
        this.downKey = false;
        this.leftKey = false;
        this.rightKey = false;

        this.mainScene.toggleCharacter();

			default: return;

    }

  }

  function onMouseDown(button:Int, xPos:Int, yPos:Int) {

    if (!this.contextMenuRect.collidesWithPoint(xPos, yPos)) {

      this.button.onMouseDown(button, xPos, yPos);

    }

    this.gamepad.onMouseDown(button, xPos, yPos);

    if (button == 2) {

      this.emitParticles(xPos, yPos);

    }

    this.mainScene.onMouseDown(button, xPos, yPos);

  }

  function onMouseUp(button:Int, xPos:Int, yPos:Int) {

    if (this.button.isPressed() && this.button.onMouseUp(button, xPos, yPos)
    ) {

      this.mainScene.toggleCharacter();

    }

    this.gamepad.onMouseUp(button, xPos, yPos);
    this.mainScene.onMouseUp(button, xPos, yPos);

  }

  function onMouseMove(xPos:Int, yPos:Int, moveX:Int, moveY:Int) {

    this.gamepad.onMouseMove(xPos, yPos, moveX, moveY);
    this.mainScene.onMouseMove(xPos, yPos, moveX, moveY);

  }

  function onSurfaceDown(id:Int, xPos:Int, yPos:Int) {

    if (id == 2) {

      this.emitParticles(xPos, yPos);

    }

  }

  function onWindowResize(width:Int, height:Int) {

    this.contextMenuRect.height = height;

    final x = this.contextMenuIsOpen ? width - this.contextMenuRect.width : width;
    this.contextMenuRect.setPosition(x, this.contextMenuRect.y);

    this.gamepad.onWindowResize(width, height);

    this.button.x = (width * 0.25 * 3).round();
    this.button.y = (height - height * 0.25 + height * 0.25 * 0.5).round();

    this.mainScene.onWindowResize(width, height);

  }

  function emitParticles(xPos:Int, yPos:Int) {

    this.lastParticleEmitter = (this.lastParticleEmitter + 1) % PARTICLE_EMITTERS_LENGTH;

    final particleEmitter = this.particleEmitters[this.lastParticleEmitter];
    particleEmitter.spawn(xPos, yPos, 20);
    particleEmitter.active = true;

  }

  function update():Void {

    final time = Scheduler.time();
    this.delta = time - this.current;
    this.current = time;

    this.timeOneSecond += this.delta;
    if (this.timeOneSecond >= 1.0) {

      this.fps = this.framesOneSecond;
      this.framesOneSecond = 0;
      this.timeOneSecond = 0;

    }

    #if kha_android_native

    /**
     * This is to catch screen rotation, see → https://github.com/Kode/Kha/issues/1265 .
     */
    if (System.windowWidth() != this.windowWidth || System.windowHeight() != this.windowHeight) {

      this.windowWidth = System.windowWidth();
      this.windowHeight = System.windowHeight();
      this.onWindowResize(this.windowWidth, this.windowHeight);

    }

    #end

    if (this.mainScene.activeObject != null) {

      if (this.gamepad.joystick.movementX.abs() >= 0.1) {

        this.mainScene.activeObject.velocity.x = this.gamepad.joystick.movementX;

      } else {

        this.mainScene.activeObject.velocity.x = 0;

      }

      if (this.gamepad.joystick.movementY.abs() >= 0.1) {

        this.mainScene.activeObject.velocity.y = this.gamepad.joystick.movementY;

      } else {

        this.mainScene.activeObject.velocity.y = 0;

      }

    } else if (this.mainScene.player != null) {

      this.mainScene.player.movingUp = this.upKey || this.gamepad.joystick.upPressed;
      this.mainScene.player.movingDown = this.downKey || this.gamepad.joystick.downPressed;
      this.mainScene.player.movingLeft = this.leftKey || this.gamepad.joystick.leftPressed;
      this.mainScene.player.movingRight = this.rightKey || this.gamepad.joystick.rightPressed;

    }

    this.mainScene.rightCameraMargin = System.windowWidth() - this.contextMenuRect.x;
    this.mainScene.update(this.delta);

    for (particleEmitter in this.particleEmitters) {

      particleEmitter.update(delta);

    }

    if (this.sceneFadeInRemainingSeconds > 0) {

      this.sceneFadeInRemainingSeconds -= this.delta;

    }

    this.renderBatch.setGameObjects(this.mainScene.getActiveObjects());
    this.contextMenuRect.update(delta);

  }

  function render(frames:Array<Framebuffer>):Void {

    final g = frames[0].g4;
    g.begin();
    g.clear(Color.Pink, 1.0);
    // g.clear(Color.Pink, Math.POSITIVE_INFINITY);

    if (this.mainScene.shaderBlock.active) {

      this.mainScene.shaderBlock.render(g);
      g.setMatrix(this.mainScene.shaderBlock.pipeline.getConstantLocation('MVP'), this.mainScene.shaderCamera.getMVP());

    }

    this.renderBatch.render(g);

    g.end();

    final g2 = frames[0].g2;

    // g2.begin(true, Color.Pink);
    g2.begin(false);

    this.mainScene.render(frames[0]);

    this.button.render(g2);
    this.gamepad.render(g2);

    if (this.sceneFadeInRemainingSeconds > 0) {

      g2.color = Color.fromFloats(0.0, 0.0, 0.0, this.sceneFadeInRemainingSeconds / this.sceneFadeInSeconds);
      g2.fillRect(0, 0, System.windowWidth(), System.windowHeight());

    }

    for (particleEmitter in this.particleEmitters) {

      particleEmitter.render(g2);

    }

    g2.end();


    this.gui(g2);

    ++this.framesOneSecond;

  }

  function gui(graphics:Graphics) {

    this.ui.begin(graphics);

    if (this.contextMenuIsOpen && this.performancePanelHandle.selected) {

      /**
       * This is needed to update FPS text.
       */
      this.uiWindowHandle.redraws = 1;

    }

    if (this.ui.window(
      this.uiWindowHandle,
      this.contextMenuRect.x,
      this.contextMenuRect.y,
      this.contextMenuRect.width,
      this.contextMenuRect.height,
      false
    )) {

      if (this.ui.panel(this.performancePanelHandle, 'Performance')) {

        this.ui.text('FPS: ${this.fps}');

      }

      if (this.ui.panel(this.infoPanelHandle, 'Info.')) {

        this.ui.text('PPI: ${kha.Display.primary.pixelsPerInch}');
        this.ui.text('Window: ${Window.get(0).width} × ${Window.get(0).height}');
        this.ui.text('Screen: ${ScreenCanvas.the.width} × ${ScreenCanvas.the.height}');
        this.ui.text('Display: ${Display.primary.width} × ${Display.primary.height}');
        this.ui.text('Scale: ${this.scale}');

      }

      this.mainScene.renderUi(this.ui);

    }

    if (this.ui.window(
      Id.handle(),
      (this.contextMenuRect.x - 50 * this.scale).round(),
      0,
      (50 * this.scale).round(),
      (28 * this.scale).round()
    )) {

      if (this.ui.button(this.contextMenuIsOpen ? '>>>' : '<<<')) {

        this.toggleContextMenu();

      }

    }

    this.ui.end();

    if (!this.contextMenuIsOpen) {

      graphics.begin(false);

      graphics.color = Color.Black;
      graphics.font = Assets.fonts.RussoOne_Regular;
      graphics.fontSize = (16 * this.scale).round();

      final fpsText = 'FPS: ${this.fps}';
      graphics.drawString(
        fpsText,
        (this.contextMenuRect.x - graphics.font.width(graphics.fontSize, fpsText) - 8 * this.scale).round(),
        (32 * this.scale).round()
      );

      graphics.end();

    }

  }

  private inline function toggleContextMenu() {

    if (this.contextMenuIsOpen) {

      this.contextMenuIsOpen = false;
      this.contextMenuRect.move(System.windowWidth() + 5, this.contextMenuRect.y, 0.2);

    } else {

      this.contextMenuIsOpen = true;
      this.contextMenuRect.move(System.windowWidth() - this.contextMenuRect.width, this.contextMenuRect.y, 0.2);

    }

  }

  public static function main() {

    System.start({title: "Animals", width: 768, height: 1024, framebuffer: { samplesPerPixel: 16 } }, function(_) {
      // Just loading everything is ok for small projects
      Assets.loadEverything(function() {

        final app = new Main();

        // Avoid passing update/render directly,
        // so replacing them via code injection works
        Scheduler.addTimeTask(function() { app.update(); }, 0, 1 / 60);
        System.notifyOnFrames(function(frames) { app.render(frames); });

      });
    });

  }

}
