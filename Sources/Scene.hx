
import kha.Framebuffer;
import kha.graphics2.Graphics;
import kha.Color;

using kha.graphics2.GraphicsExtension;

typedef SceneProps = {
  ?scale:Float,
}

class Scene {

  public var scale:Float;

	public function new(props:SceneProps) {

    this.scale = props.scale != null ? props.scale : 1.0;

  }

  public function update(delta:Float) {



  }

	public function render(framebuffer:Framebuffer):Void {



  }

}