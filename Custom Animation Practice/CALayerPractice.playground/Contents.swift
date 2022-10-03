import UIKit
import PlaygroundSupport

let view = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
view.backgroundColor = .lightGray

PlaygroundPage.current.liveView = view

// 단순히 그리기만 할 것이 아니면 CALayer를 사용해야 함
let shapeLayer = CAShapeLayer()
view.layer.addSublayer(shapeLayer)

let path = UIBezierPath(ovalIn: CGRect(x: 300, y: 300, width: 200, height: 200))
shapeLayer.path = path.cgPath
shapeLayer.fillColor = UIColor.yellow.cgColor
shapeLayer.strokeColor = UIColor.black.cgColor
shapeLayer.lineWidth = 5

let shapeLayer2 = CAShapeLayer()
view.layer.addSublayer(shapeLayer2)

let path2 = UIBezierPath()
path2.move(to: CGPoint(x: 5, y: 5))
path2.addLine(to: CGPoint(x: 5, y: 130))
path2.addLine(to: CGPoint(x: 130, y: 130))
path2.addLine(to: CGPoint(x: 130, y: 5))
path2.addLine(to: CGPoint(x: 80, y: 100))
path2.addLine(to: CGPoint(x: 40, y: 100))
path2.addQuadCurve(to: CGPoint(x: 5, y: 5), controlPoint: CGPoint(x: 100, y: 5))
path2.close()

shapeLayer2.path = path2.cgPath
shapeLayer2.fillColor = UIColor.yellow.cgColor
shapeLayer2.strokeColor = UIColor.black.cgColor
shapeLayer2.lineWidth = 5
shapeLayer2.lineJoin = .round // 꼭지점을 부드럽게

// 현재
shapeLayer2.position // {x 0 y 0}, 즉 왼쪽 상단
shapeLayer2.anchorPoint // {x 0.5 y 0.5} center가 현재 기준, 범위는 0 ~ 1

shapeLayer2.bounds = path2.bounds
shapeLayer2.position.x = view.bounds.midX
shapeLayer2.position.y = view.bounds.midY // 가운데로 이동

let blueLayer = CALayer()
blueLayer.bounds = CGRect(x: 0, y: 0, width: 150, height: 150)
view.layer.addSublayer(blueLayer) // 그냥 하면 blueLayer가 화면을 가려버림, zPostion 설정 필요
// view.layer.insertSublayer(blueLayer, below: shapeLayer2) blueLayer가 아래로 내려감
shapeLayer2.zPosition = 10 // 숫자가 크면 위로 감
blueLayer.zPosition = 5

blueLayer.backgroundColor = UIColor.blue.cgColor
blueLayer.position = shapeLayer2.position
