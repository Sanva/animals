
class Behaviour {

  public var stepSeconds:Float = .33;
  var elapsed:Float = 0;

  public var actions(default, set):Array<() -> Void> = [];
  private function set_actions(value) {

    this.currentAction = 0;

    return this.actions = value;

  }

  var currentAction:Int = 0;
  var running:Bool = false;

  public function new() {};

  public function run() {

    if (this.running || this.actions.length == 0) {

      return;

    }

    this.actions[this.currentAction]();
    this.running = true;

  }

  public function update(delta:Float) {

    if (!this.running || this.actions.length == 0) {

      return;

    }

    this.elapsed += delta;
    if (this.elapsed >= this.stepSeconds) {

      this.elapsed = this.stepSeconds - this.elapsed;

      ++this.currentAction;
      if (this.currentAction == this.actions.length) {

        this.currentAction = 0;

      }

      this.actions[this.currentAction]();

    }

  }

}
