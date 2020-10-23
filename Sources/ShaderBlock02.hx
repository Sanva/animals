
import kha.math.FastVector2;
import kha.graphics4.Graphics;
import kha.graphics4.ConstantLocation;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.Usage;
import kha.graphics4.VertexData;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;
import kha.Shaders;
import kha.System;
import zui.Id;
import zui.Zui;

using Math;

typedef ShaderBlock02Props = {
  active:Bool,
}

class ShaderBlock02 {

  public final pipeline:PipelineState;

  final vertices:VertexBuffer;
  final indices:IndexBuffer;

  final resolution:FastVector2;
  // final resolutionId:ConstantLocation;

  final mouse:FastVector2;
  final mouseId:ConstantLocation;

  // final timeId:ConstantLocation;

  // final backbuffer:Image;

  public var active:Bool;

	public function new(props:ShaderBlock02Props) {

    this.active = props.active;

    final structure = new VertexStructure();
    structure.add("position", VertexData.Float3);
    structure.add("color", VertexData.Float4);

    this.pipeline = new PipelineState();
    this.pipeline.inputLayout = [structure];
    this.pipeline.vertexShader = Shaders.shader_vert;
    this.pipeline.fragmentShader = Shaders.shaderTest_frag;
    this.pipeline.compile();

    this.vertices = new VertexBuffer(4, structure, Usage.StaticUsage);
    final vertexArray = [
      // positions      // colors
      300,  100, 0,    1,  0,  0,  1, // Bottom right 0
      100, 300,  0,    0,  1,  0,  1, // Top left     1
      300,  300,  0,    0,  0,  1,  1, // Top right    2
      100, 100, 0,    1,  1,  0,  1, // Bottom left  3
    ];
    final v = this.vertices.lock();
    for (i in 0...vertexArray.length) {

      v.set(i, vertexArray[i]);

    }
    this.vertices.unlock();

    final indicesArray = [
      2, 1, 0,
      0, 1, 3,
    ];
    this.indices = new IndexBuffer(indicesArray.length, Usage.StaticUsage);
    final i = this.indices.lock();
    for (j in 0...indicesArray.length) {

      i.set(j, indicesArray[j]);

    }
    this.indices.unlock();

    this.mouseId = pipeline.getConstantLocation('u_mouse');

    this.resolution = new FastVector2(System.windowWidth(), System.windowHeight());
    this.mouse = new FastVector2(0, 0);

  }

  public function onMouseDown(button:Int, xPos:Int, yPos:Int) {

    this.mouse.x = xPos / System.windowWidth();
    this.mouse.y = yPos / System.windowHeight();

  }
  public function onMouseUp(button:Int, xPos:Int, yPos:Int) {

    this.mouse.x = xPos / System.windowWidth();
    this.mouse.y = yPos / System.windowHeight();

  }
  public function onMouseMove(xPos:Int, yPos:Int) {

    this.mouse.x = xPos / System.windowWidth();
    this.mouse.y = yPos / System.windowHeight();

  }

  public function render(graphics:Graphics):Void {

		if (!this.active) {

			return;

    }

    graphics.setPipeline(this.pipeline);
    // graphics.setVector2(this.pipeline.getConstantLocation('u_resolution'), this.resolution);
    graphics.setVector2(this.mouseId, this.mouse);
    // graphics.setFloat(this.pipeline.getConstantLocation('u_time'), Scheduler.time());
		graphics.setVertexBuffer(this.vertices);
    graphics.setIndexBuffer(this.indices);
    graphics.drawIndexedVertices();

    // final matrixLocation = this.pipeline.getConstantLocation('projection');
    // g.setMatrix(matrixLocation, this.mainScene.shaderCamera.getProjectionMatrix());

    // g.setMatrix(this.pipeline.getConstantLocation('view'), this.mainScene.shaderCamera.getViewMatrix());



  }

}

class ShaderBlock02Gui {

  final ShaderBlock02:ShaderBlock02;

  final activeHandle:Handle;

  public function new(ShaderBlock02:ShaderBlock02) {

    this.ShaderBlock02 = ShaderBlock02;

    this.activeHandle = Id.handle({selected: this.ShaderBlock02.active});

  }

  public function render(ui:Zui, scale:Float) {

    this.ShaderBlock02.active = ui.check(this.activeHandle, 'Visible');

  }

}
