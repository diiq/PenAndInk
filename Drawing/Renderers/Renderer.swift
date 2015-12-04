import Darwin

/**
 A Renderer is something that gets handed to a drawable and produces an image.

 That image can be any type at all; for tests our 'images' are arrays of strings.
 This protocol is a complete listing of all drawing methods necessary to render
 an image. These should remain backwards-compatible, so that existing images can
 still be opened and re-rendered.

 Be sure to check out [the WWDC talk](https://developer.apple.com/videos/play/wwdc2015-408/)
 that inspired this rendering architecture.
 */
protocol Renderer {
  /// Draws a straight, unweighted, black line from <ax, ay> to <bx, by>
  func moveTo(point: StrokePoint)
  func line(a: StrokePoint, _ b: StrokePoint)
  func arc(a: StrokePoint, _ b: StrokePoint)
  func circle(center: StrokePoint, radius: Double)
  func bezier(a: StrokePoint, _ cp1: StrokePoint, _ cp2: StrokePoint, _ b: StrokePoint)
  func color(r: Double, _ g: Double, _ b: Double, _ a: Double)
  func stroke()
  func fill()
}

/**
 An ImageRenderer is a Renderer that can inser previously rendered images of its
 ImageType into the image its currently rendering. This is used for recording
 and displaying snapshots of the drawing, purely for performance reasons.
 */
protocol ImageRenderer: Renderer {
  typealias ImageType

  /// The rendered image
  var currentImage: ImageType { get }

  /// Places an existing image into the image being rendered.
  func image(image: ImageType)
}

extension Renderer {
  func linear(points: [StrokePoint]) {
    var lastPoint = points[0]
    moveTo(lastPoint)
    points[1..<points.count].forEach {
      line(lastPoint, $0)
      lastPoint = $0
    }
  }

  func weightedLine(a: StrokePoint, _ b: StrokePoint) {
    let perpendicular = (b - a).perpendicular()
    let aPlus = a + perpendicular * a.weight
    let aMinus = a - perpendicular * a.weight
    let bPlus = b + perpendicular * b.weight
    let bMinus = b - perpendicular * b.weight

    moveTo(aPlus)
    line(aPlus, bPlus)
    arc(bPlus, bMinus)
    line(bMinus, aMinus)
    arc(aMinus, aPlus)
    fill()
  }

  func weightedLinear(points: [StrokePoint]) {
    var lastPoint = points[0]
    moveTo(lastPoint)
    points[1..<points.count].forEach {
      weightedLine(lastPoint, $0)
      lastPoint = $0
    }
  }
}