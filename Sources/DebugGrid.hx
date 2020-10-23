
import Block;

import kha.graphics2.Graphics;
import zui.Id;
import zui.Ext;
import zui.Zui;

using Math;

typedef DebugGridProps = {
  > BlockProps,
  step:Float,
  scale:Float,
}

class DebugGrid extends Block {

  public var step:Float;
  public var scale:Float;

  public function new(props:DebugGridProps) {

    super(props);

    this.step = props.step;
    this.scale = props.scale;

  }

  /**
   * @todo Fix this shit.
   *
   * @param graphics
   */
  public override function drawShape(graphics:Graphics) {

    graphics.font = kha.Assets.fonts.RussoOne_Regular;
    graphics.fontSize = (12 * this.scale).ceil();

    final count = (this.width * this.scale / this.step * this.scale).round();
    for (i in 0...count) {

      final stepI = this.step * this.scale * i;
      final stepX = stepI + this.x * this.scale;
      final stepY = stepI + this.y * this.scale;

      graphics.drawLine(stepX, this.y * this.scale, stepX, this.height * this.scale);
      graphics.drawLine(this.x * this.scale, stepY, this.width * this.scale, stepY);

      for (j in 0...count) {

        final stepXText = stepI + this.x * this.scale;
        final stepYText = this.step * this.scale * j + this.y * this.scale;

        graphics.drawString('(${stepXText}, ${stepYText})', stepXText + 5 * this.scale, stepYText + 5 * this.scale);

      }

    }

  }

}

class DebugGridGui {

  final debugGrid:DebugGrid;

  final activeHandle:Handle;
  final sizeHandle:Handle;
  final colorHandle:Handle;
  final stepHandle:Handle;

  public function new(debugGrid:DebugGrid) {

    this.debugGrid = debugGrid;

    this.activeHandle = Id.handle({selected: this.debugGrid.active});
    this.colorHandle = Id.handle({color: debugGrid.color});
    this.sizeHandle = Id.handle({value: debugGrid.width});
    this.stepHandle = Id.handle({value: this.debugGrid.step});

  }

  public function render(ui:Zui, scale:Float) {

    this.debugGrid.active = ui.check(this.activeHandle, 'Visible');
    this.debugGrid.step = Math.round(ui.slider(this.stepHandle, 'Step', 100, 500, true) * scale);

    final size = Math.round(ui.slider(this.sizeHandle, 'Size', 100, 50000, true) * scale);
    this.debugGrid.width = size;
    this.debugGrid.height = size;

    final offset = (-size / 2).round();
    this.debugGrid.x = offset;
    this.debugGrid.y = offset;

    if (ui.panel(Id.handle({selected: false}), 'Color')) {

      this.debugGrid.color = Ext.colorWheel(ui, this.colorHandle);

    }

  }

}

