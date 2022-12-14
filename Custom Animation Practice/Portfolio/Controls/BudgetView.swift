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
class BudgetView: UIView {
  
  let label = UILabel()
  
  // stepper is 0 to 10
  let stepper = UIStepper()
  
  let step: Double = 100  // go up by $100 at a time
  let maxValue:Double = 4
  
  
  var currentValue: Double = 0 {
    didSet {
      label.text = "\(Int(currentValue * step))"
      
      //let fromValue = foregroundLayer.strokeEnd
      //let toValue = CGFloat(currentValue/maxValue)
      
      // let animation = CABasicAnimation(keyPath: "strokeEnd")
      // animation.fromValue = fromValue
      // animation.toValue = toValue
      // animation.duration = 1.0
      // foregroundLayer.strokeEnd = toValue // model Layer??? ??????????????? ??????, add ?????? ?????? - ?????????????????? Implicit animationd ??????
      // foregroundLayer.add(animation, forKey: "stroke")
      
      // ???????????? ???????????? ??????
      let animation = CABasicAnimation(keyPath: "strokeEnd")
      animation.duration = 1.0
      foregroundLayer.strokeEnd = CGFloat(currentValue/maxValue)
      foregroundLayer.add(animation, forKey: "stroke")
    }
  }
  
  var backgroundLayer = ArcLayer(color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
  var foregroundLayer = ArcLayer(color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setup()
  }
  
  func setup() {
    buildInterface()
    layer.addSublayer(backgroundLayer)
    layer.addSublayer(foregroundLayer)
    foregroundLayer.strokeEnd = 0
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    foregroundLayer.bounds = bounds
    backgroundLayer.bounds = bounds
  }
  
  func buildLayer(layer: CAShapeLayer) {
    
    // 0?????? 1????????? + ???, ????????? ????????????
    // 180?????? 2????????? - ???
    let startAngle = 0.75 * CGFloat.pi
    let endAngle = 0.25 * CGFloat.pi
    let center  = CGPoint(x: bounds.midX, y: bounds.midY)
    let radius = bounds.width * 0.35
    let path = UIBezierPath(arcCenter: center,
                            radius: radius,
                            startAngle: startAngle, endAngle: endAngle,
                            clockwise: true)

    layer.path = path.cgPath
    layer.lineWidth = 20
    layer.fillColor = nil
    layer.lineCap = .round
  }
  
  
  // MARK:- Subviews
  
  @objc func handleStepper(_ stepper: UIStepper) {
    currentValue = stepper.value
  }
  
  func buildInterface() {
    stepper.minimumValue = 0
    stepper.maximumValue = maxValue
    stepper.translatesAutoresizingMaskIntoConstraints = false
    stepper.addTarget(self, action: #selector(handleStepper(_:)), for: .valueChanged)
    stepper.isContinuous = true
    
    addSubview(stepper)
    let stepCenterX = stepper.centerXAnchor.constraint(equalTo: centerXAnchor)
    let stepBottom = stepper.bottomAnchor.constraint(equalTo: bottomAnchor)
    NSLayoutConstraint.activate([stepCenterX, stepBottom])
    
    label.text = "0"
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(label)
    let labelCenterX = label.centerXAnchor.constraint(equalTo: centerXAnchor)
    let labelCenterY = label.centerYAnchor.constraint(equalTo: centerYAnchor)
    NSLayoutConstraint.activate([labelCenterX, labelCenterY])
  }
  
}

class ArcLayer: CAShapeLayer {
  init(color: UIColor) {
    super.init()
    strokeColor = color.cgColor
    lineWidth = 20
    fillColor = nil
    lineCap = .round
  }
  
  /// ?????? presentation Layer??? init ???????????? ???
  override init(layer: Any) {
    super.init(layer: layer)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var bounds: CGRect {
    didSet {
      buildLayer()
    }
  }
  
  func buildLayer() {
    
    // 0?????? 1????????? + ???, ????????? ????????????
    // 180?????? 2????????? - ???
    let startAngle = 0.75 * CGFloat.pi
    let endAngle = 0.25 * CGFloat.pi
    let center  = CGPoint(x: bounds.midX, y: bounds.midY)
    let radius = bounds.width * 0.35
    let path = UIBezierPath(arcCenter: center,
                            radius: radius,
                            startAngle: startAngle, endAngle: endAngle,
                            clockwise: true)

    self.path = path.cgPath
    position = CGPoint(x: bounds.midX, y: bounds.midY)
  }
}

// presentaion Layer, model Layer
