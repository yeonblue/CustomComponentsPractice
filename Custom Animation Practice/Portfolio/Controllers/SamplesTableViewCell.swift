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

// layoutSubView는 view의 bounds가 autolayout에 의해 결정된 직후에 호출
// 즉 layout이 결정된 후므로, view.bounds를 쓸 수 있음

class SamplesTableViewCell: UITableViewCell {
  @IBOutlet weak var sampleImageView: UIImageView!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let layer = sampleImageView.layer
    layer.cornerRadius = 30
    // layer.masksToBounds = true // layer를 벗어난 view는 잘라냄, main layer에서는 masksToBounds를 취소
    
    // // Core Animation은 에전 API라 UIKit을 사용하지 않음
    // layer.borderColor = UIColor.gray.cgColor
    // layer.borderWidth = 3 // pixel을 직접 주지 않고, 알아서 retina option에 따른 값을 부여해 줌
    
    // 그냥 그림자를 layer에 주면 masksToBound로 이 경우 그림자는 보이지 않음
    // layer hierarchy를 통해 위의 문제를 해결 가능
    // main layer가 그림자를 제공, sublayer가 이미지를 제공, sublayer에서 cornerRadius를 추가
    layer.shadowOffset = CGSize(width: 4, height: 4)
    layer.shadowOpacity = 0.3 // opacity 속성이 따로 있으므로 주의
    layer.shadowRadius = 5.0
    
    // imageLayer
    imageLayer.frame = layer.bounds
    imageLayer.contents = sampleImage?.cgImage
    imageLayer.masksToBounds = true
    imageLayer.cornerRadius = layer.cornerRadius
    
    imageLayer.maskedCorners = [.layerMinXMinYCorner, . layerMaxXMaxYCorner]
  }
  
  let imageLayer = CALayer()
  var sampleImage: UIImage? = nil
  
  // 맨 처음 한번만 호출되길 원할 때 사용하면 적합, VC의 viewDidload와 비슷
  override func awakeFromNib() {
    super.awakeFromNib()
    sampleImageView.layer.addSublayer(imageLayer)
  }
}

/// 정리
/// cell은 calayer가 2개.
/// mainLayer는 shadow, subLayer는 이미지를 관리(masksToBounds를 여기에만 줌)
