

import kha.graphics4.FragmentShader;
import kha.graphics4.Graphics;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexStructure;
import kha.Shaders;

using Lambda;
using Math;
using Std;

typedef RenderBatchProps = {
  pipeline:PipelineState,
  ?setUniforms:Null<(graphics:Graphics, object:GameObject, batch:RenderBatch) -> Void>,
}

class RenderBatch {

  final pipeline:PipelineState;
  final setUniforms:Null<(g:Graphics, object:GameObject, batch:RenderBatch) -> Void>;

  var objects:Array<GameObject> = [];

	public function new(props:RenderBatchProps) {

    this.pipeline = props.pipeline;
    this.setUniforms = props.setUniforms;

  }

  public function getConstantLocation(name:String) {

    return this.pipeline.getConstantLocation(name);

  }

  public function getTextureUnit(name:String) {

    return this.pipeline.getTextureUnit(name);

  }

  public function addGameObject(object:GameObject) {

    this.objects.push(object);

  }

  public function setGameObjects(objects:Array<GameObject>) {

    this.objects = objects;

  }

  public function clearGameObjects() {

    this.objects = [];

  }

  public function countGameObjects() {

    return this.objects.length;

  }

  private inline function getVertexBuffer() {

    var verticesCount = 0;
    for (object in this.objects) {

      verticesCount += object.verticesCount;

    }

    final buffer = new VertexBuffer(verticesCount, this.pipeline.inputLayout[0], Usage.StaticUsage);
    final b = buffer.lock();
    var objectOffset = 0;
    for (i in 0...this.objects.length) {

      final object = this.objects[i];
      final positions = object.verticesPositions;
      final colors = object.verticesColors;
      final uvs = object.verticesUVs;

      for (j in 0...object.verticesCount) {

        final offset = objectOffset + j * object.structureLength;

        b.set(offset, positions[j * 3]);
        b.set(offset + 1, positions[j * 3 + 1]);
        b.set(offset + 2, positions[j * 3 + 2]);
        b.set(offset + 3, colors[j * 4]);
        b.set(offset + 4, colors[j * 4 + 1]);
        b.set(offset + 5, colors[j * 4 + 2]);
        b.set(offset + 6, colors[j * 4 + 3]);
        b.set(offset + 7, uvs[j * 2]);
        b.set(offset + 8, uvs[j * 2 + 1]);

      }

      objectOffset += object.structureLength * object.verticesCount;

    }

    buffer.unlock();

    return buffer;

  }

  private inline function getIndexBuffer() {

    var indicesCount = 0;
    for (object in this.objects) {

      indicesCount += object.indicesCount;

    }

    final buffer = new IndexBuffer(indicesCount, Usage.StaticUsage);
    final b = buffer.lock();
    var objectOffset = 0;
    var indexOffset = 0;
    for (i in 0...this.objects.length) {

      final object = this.objects[i];

      for (j in 0...object.indices.length) {

        b.set(objectOffset + j, object.indices[j] + indexOffset);

      }

      indexOffset += object.verticesCount;
      objectOffset += object.indices.length;

    }

    buffer.unlock();

    return buffer;

  }

  public function render(graphics:Graphics):Void {

    if (this.objects.length == 0) {

      return;

    }

    graphics.setPipeline(this.pipeline);
		graphics.setVertexBuffer(this.getVertexBuffer());
    graphics.setIndexBuffer(this.getIndexBuffer());

    var objectOffset = 0;
    for (object in this.objects) {

      if (this.setUniforms != null) {

        this.setUniforms(graphics, object, this);

      }

      /**
       * This call shouldn't be needed, it's a bug
       * in Kha → http://forum.kode.tech/topic/355/how-to-do-batch-rendering-with-g4
       */
      graphics.setVertexBuffer(this.getVertexBuffer());

      graphics.drawIndexedVertices(objectOffset, object.indicesCount);

      objectOffset += object.indicesCount;

    }

  }

}

