
import Block;

import kha.graphics2.Graphics;
import kha.Color;
import zui.Id;
import zui.Zui;

using Math;

typedef DebugGridProps = {
  > BlockProps,
  scale:Float,
  ?labels:Bool,
  ?subgrid:Bool,
}

class DebugGrid extends Block {

  public var labels:Bool;
  public var subgrid:Bool;
  public var scale:Float;

  public function new(props:DebugGridProps) {

    super(props);

    this.labels = props.labels == null ? false : props.labels;
    this.subgrid = props.subgrid == null ? false : props.subgrid;
    this.scale = props.scale;

  }

  public function move(x:Int, y:Int) {

    this.x = this.roundOneHundred((x * this.scale).round());
    this.y = this.roundOneHundred((y * this.scale).round());

  }

  private inline function roundOneHundred(value:Int):Int {

    return ((value / this.scale * 0.01).fround() * 100 * this.scale).round();

  }

  public function resize(width:Int, height:Int) {

    this.width = this.roundTwoHundreds((width * this.scale).round());
    this.height = this.roundTwoHundreds((height * this.scale).round());

  }

  private inline function roundTwoHundreds(value:Int):Int {

    return (((value / this.scale * 0.01).fround() * 0.5 * this.scale).round() * 200 * this.scale).round();

  }

  public override function drawShape(graphics:Graphics) {

    final minX = this.minX - 100 * this.scale;
    final minY = this.minY - 100 * this.scale;
    final maxX = this.maxX + 100 * this.scale;
    final maxY = this.maxY + 100 * this.scale;
    var i;

    if (this.subgrid) {

      graphics.color = Color.fromBytes(14, 14, 14);

      final step = 20 * this.scale;

      i = minX;
      while (i <= maxX) {

        graphics.drawLine(i, minY, i, maxY, this.scale);
        i += step;

      }

      i = minY;
      while (i <= maxY) {

        graphics.drawLine(minX, i, maxX, i, this.scale);
        i += step;

      }

    }

    graphics.color = Color.fromBytes(7, 7, 7);

    final step = 100 * this.scale;

    i = minX;
    while (i <= maxX) {

      graphics.drawLine(i, minY, i, maxY, 1.5 * this.scale);
      i += step;

    }

    i = minY;
    while (i <= maxY) {

      graphics.drawLine(minX, i, maxX, i, 1.5 * this.scale);
      i += step;

    }

    if (this.labels) {

      graphics.font = kha.Assets.fonts.RussoOne_Regular;
      graphics.fontSize = (12 * this.scale).round();

      final textOffset = (5 * this.scale).round();

      i = minX;
      while (i < maxX) {

        var j = minY;
        while (j < maxY) {

          graphics.drawString('(${i}, ${j})', i + textOffset, j + textOffset);
          j += step;

        }

        i += step;

      }

    }

  }

}

class DebugGridGui {

  final debugGrid:DebugGrid;

  final activeHandle:Handle;
  final labelsHandle:Handle;
  final subgridHandle:Handle;
  final scaleHandle:Handle;

  public function new(debugGrid:DebugGrid) {

    this.debugGrid = debugGrid;

    this.activeHandle = Id.handle({selected: this.debugGrid.active});
    this.labelsHandle = Id.handle({selected: this.debugGrid.labels});
    this.subgridHandle = Id.handle({selected: this.debugGrid.subgrid});
    this.scaleHandle = Id.handle({value: this.debugGrid.scale});

  }

  public function render(ui:Zui, scale:Float) {

    this.debugGrid.active = ui.check(this.activeHandle, 'Visible');
    this.debugGrid.labels = ui.check(this.labelsHandle, 'Draw labels');
    this.debugGrid.subgrid = ui.check(this.subgridHandle, 'Draw subgrid');
    this.debugGrid.scale = ui.slider(this.scaleHandle, 'Scale', 0.1, 10, true, 10);

  }

}
