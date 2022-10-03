///// Copyright (c) 2018 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

@IBDesignable
class RatingView: UIView {
  
  var image: UIImage?
  
  var cross: UIImage {
    let size = 40
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
    return renderer.image { context in
      let cgContext = context.cgContext
      cgContext.addLines(between: [.zero, CGPoint(x: size, y: size)])
      cgContext.addLines(between: [CGPoint(x: size, y: 0), CGPoint(x: 0, y: size)])
      cgContext.setStrokeColor(UIColor.white.cgColor)
      cgContext.strokePath()
    }
  }
  
  // view의 context에 직접 그리기 방식, UIImageView에서는 불리지 않음
  override func draw(_ rect: CGRect) {
    super.draw(rect)

    let context = UIGraphicsGetCurrentContext()
    context?.scaleBy(x: 0.25, y: 0.25)

    for _ in 0..<4 {
      image?.draw(at: .zero)
      context?.saveGState()
      context?.translateBy(x: rect.width, y: 0)
    }
    
    context?.restoreGState()
    
//    context?.saveGState() // context 상태 저장 필수
//    context?.scaleBy(x: 1, y: -1) // uiImage는 orgin이 왼쪽 위, cgimage는 오래된 api로 origin이 왼쪽 아래
//    context?.translateBy(x: 0, y: -rect.height)
//    context?.clip(to: rect, mask: image!.cgImage!)
//    UIColor.red.setFill()
//    UIRectFill(rect)
//    cross.drawAsPattern(in: rect)
//    context?.restoreGState()
  }
  
  func drawCupCake(rect: CGRect) -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: rect.size)
    let image = renderer.image { canvas in
      let path = UIBezierPath()
      
      path.move(to: CGPoint(x: 10, y: rect.midY))
      path.addLine(to: CGPoint(x: rect.width/5, y: rect.height - 10))
      path.addLine(to: CGPoint(x: rect.width / 5 * 4, y: rect.height - 10))
      path.addLine(to: CGPoint(x: rect.width - 10, y: rect.midY))
      path.close()
      
      // 라인 색 설정
      UIColor.black.setStroke()
      path.lineWidth = 3
      
      // 색 채우기
      UIColor.brown.withAlphaComponent(0.7).setFill()
      path.fill()
      
      // stroke 전에 채워야 선이 제대로 다 그려짐
      path.stroke()
      
      
      // 빵 부분
      let top = UIBezierPath()
      top.move(to: CGPoint(x: rect.width - 10, y: rect.midY))
      
      var controlPoint1 = CGPoint(x: rect.width, y: rect.height / 5)
      var controlPoint2 = CGPoint(x: rect.width/3 * 2, y: rect.height / 8)
      
      top.addCurve(to: CGPoint(x: rect.midX, y: 0),
                   controlPoint1: controlPoint1,
                   controlPoint2: controlPoint2)
      
      controlPoint1 = CGPoint(x: rect.width/3, y: rect.height / 8)
      controlPoint2 = CGPoint(x: 0, y: rect.height / 5)
      
      top.addCurve(to: CGPoint(x: 10, y: rect.midY),
                   controlPoint1: controlPoint1,
                   controlPoint2: controlPoint2)
      
      top.close()
      top.lineWidth = 3
      UIColor.systemPink.withAlphaComponent(0.4).setFill()
      top.fill()
      top.stroke()
    }
    
    return image
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    image = Drawing.cupcake(frame: bounds)
  }
}
