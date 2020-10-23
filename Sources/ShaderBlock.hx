
import kha.graphics4.Graphics;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.Shaders;
import zui.Id;
import zui.Zui;

using Math;

typedef ShaderBlockProps = {
  active:Bool,
}

class ShaderBlock {

  public final pipeline:PipelineState;
  final vertices:VertexBuffer;
  final indices:IndexBuffer;

  public var active:Bool;

	public function new(props:ShaderBlockProps) {

    this.active = props.active;

    final structure = new VertexStructure();
    structure.add("position", VertexData.Float3);
    structure.add("color", VertexData.Float4);

    this.pipeline = new PipelineState();
    this.pipeline.inputLayout = [structure];
    this.pipeline.vertexShader = Shaders.shader_vert;
    this.pipeline.fragmentShader = Shaders.shader_frag;
    this.pipeline.compile();

    this.vertices = new VertexBuffer(4, structure, Usage.StaticUsage);
    // final vertexArray = [
    //   // positions      // colors
    //   0.1,  -0.1, 0,    1,  0,  0,  1, // Bottom right 0
    //   -0.1, 0.1,  0,    0,  1,  0,  1, // Top left     1
    //   0.1,  0.1,  0,    0,  0,  1,  1, // Top right    2
    //   -0.1, -0.1, 0,    1,  1,  0,  1, // Bottom left  3
    // ];
    final vertexArray = [
      // positions      // colors
      100,  -100, 0,    1,  0,  0,  1, // Bottom right 0
      -100, 100,  0,    0,  1,  0,  1, // Top left     1
      100,  100,  0,    0,  0,  1,  1, // Top right    2
      -100, -100, 0,    1,  1,  0,  1, // Bottom left  3
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

  }

	public function render(graphics:Graphics):Void {

		if (!this.active) {

			return;

    }

    graphics.setPipeline(this.pipeline);
		graphics.setVertexBuffer(this.vertices);
    graphics.setIndexBuffer(this.indices);
    graphics.drawIndexedVertices();

  }

}

class ShaderBlockGui {

  final shaderBlock:ShaderBlock;

  final activeHandle:Handle;

  public function new(shaderBlock:ShaderBlock) {

    this.shaderBlock = shaderBlock;

    this.activeHandle = Id.handle({selected: this.shaderBlock.active});

  }

  public function render(ui:Zui, scale:Float) {

    this.shaderBlock.active = ui.check(this.activeHandle, 'Visible');

  }

}
