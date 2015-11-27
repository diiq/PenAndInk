import UIKit

/**
 TODO: Explain what this is for
*/
class ActiveDrawing {
  var strokesByTouch = [UITouch : Stroke]()

  func addOrUpdateStroke(indexTouch: UITouch, touches: [UITouch]) {
    let stroke = strokesByTouch[indexTouch] ?? newStrokeForTouch(indexTouch)
    for touch in touches {
      stroke.addPoint(touch.strokePoint())
    }
  }

  func updateStrokePredictions(indexTouch: UITouch, touches: [UITouch]) {
    guard let stroke = strokesByTouch[indexTouch] else { return }
    for touch in touches {
      stroke.addPredictedPoint(touch.strokePoint())
    }
  }

  func rectForUpdatedPoints() -> CGRect {
    let rects = strokesByTouch.values.map { CGRect($0.undrawnRect()) }
    return rects.reduce(CGRect(x: 0, y: 0, width: 0, height: 0), combine: {
      (r1: CGRect, r2: CGRect) -> CGRect in
      return r1.union(r2)
    })
  }

  func forgetPredictions(indexTouch: UITouch) {
    guard let stroke = strokesByTouch[indexTouch] else { return }
    stroke.predictedPoints = []
  }

  func newStrokeForTouch(touch: UITouch) -> Stroke {
    // TODO: How to choose the stroke type
    let line = SmoothFixedPenStroke(points: [])
    strokesByTouch[touch] = line
    return line
  }

  func endStrokeForTouch(touch: UITouch) -> Stroke? {
    guard let stroke = strokesByTouch[touch] else { return nil }
    strokesByTouch.removeValueForKey(touch)
    stroke.finalize()
    return stroke
  }

  func draw(renderer: Renderer) {
    for stroke in strokesByTouch.values {
      stroke.draw(renderer)
    }
  }
}