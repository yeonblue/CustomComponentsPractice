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
class GraphView: UIView {
  
  var days: [CGFloat] = [4, 3, 0, 6, 5, 10, 8]
  
  // number of y axis labels
  let yDivisions: CGFloat = 5
  // margin between lines
  lazy var gap: CGFloat = {
    return bounds.height / (yDivisions + 1)
  }()
  // averaged value spread over y Divisions
  lazy var eachLabel: CGFloat = {
    let maxValue = CGFloat(days.max()!)
    let minValue = CGFloat(days.min()!)
    return (maxValue - minValue) / (yDivisions-1)
  }()
  // column width
  lazy var columnWidth: CGFloat = {
    return bounds.width / CGFloat(days.count)
  }()
  
  lazy var data: [CGPoint] = {
    var array = [CGPoint]()
    
    for (idx, day) in days.enumerated() {
      let point = CGPoint(x: columnWidth * CGFloat(idx), y: day / eachLabel * gap)
      array.append(point)
    }
    
    return array
  }()

  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    drawText(context: context)
    
    
    context.translateBy(x: columnWidth/2 + 10, y: 0)
    context.scaleBy(x: 1, y: -1)
    context.translateBy(x: 0, y: -bounds.height)
    context.translateBy(x: 0, y: gap)

    // clip
    context.saveGState()
    context.addLines(between: data)
    context.strokePath()
    context.closePath()
    context.clip()
    
    drawGradient(context: context)
    context.restoreGState()
    
    context.addLines(between: data)
    context.strokePath()
    context.restoreGState()
  }
  
  func drawGradient(context: CGContext) {
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let colors: NSArray = [UIColor.blue.withAlphaComponent(0.3).cgColor,
                           UIColor.systemBlue.withAlphaComponent(0.8).cgColor]
    
    let locations: [CGFloat] = [0.0, 1.0]
    let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
    
    context.drawLinearGradient(gradient!, start: .zero, end: CGPoint(x: 0, y: bounds.height), options: [])
    
    // context.drawRadialGradient도 존재
  }
  
  func drawText(context: CGContext) {
    let font = UIFont(name: "Avenir-Light", size: 12)!
    let attributes = [NSAttributedString.Key.font: font]
    let maxValue = CGFloat(days.max()!)
    context.saveGState()
    for i in 0..<5 {
      context.translateBy(x: 0, y: gap)
      
      context.setStrokeColor(UIColor.darkGray.cgColor)
      context.setLineWidth(1)
      context.addLines(between: [CGPoint(x: 35, y: 0), CGPoint(x: bounds.width, y: 0)])
      context.strokePath()
      
      let text = "\(maxValue - eachLabel * CGFloat(i))" as NSString
      let size = text.size(withAttributes: attributes)
      text.draw(at: CGPoint(x: 6, y: -size.height/2), withAttributes: attributes)
    }
    
    context.restoreGState()
  }
}


