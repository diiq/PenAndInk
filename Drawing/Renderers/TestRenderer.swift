typealias TestImage = [String]

/// 'Renders' images into an array of strings that are easy to test
class TestRenderer: Renderer, ImageRenderer {
  typealias ImageType = TestImage
  var currentImage: ImageType = ImageType()

  func line(a: StrokePoint, _ b: StrokePoint) {
    currentImage.append("line: \(a), \(b)")
  }

  func bezier(a: StrokePoint, _ cp1: StrokePoint, _ cp2: StrokePoint, _ b: StrokePoint) {
    currentImage.append("bezier: \(a), [\(cp1), \(cp2)], \(b)")
  }

  func image(image: ImageType) {
    self.currentImage.appendContentsOf(image)
  }

  func clear() {
    self.currentImage = []
  }
}

