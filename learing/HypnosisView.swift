//
//  HypnosisView.swift
//  learing
//
//  Created by Niray on 2017/7/4.
//  Copyright © 2017年 Niray. All rights reserved.
//

import Foundation
import UIKit

class HypnosisView: UIView {
    
    var circleColor:UIColor = UIColor.lightGray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let x = bounds.origin.x + bounds.size.width / 2
        let y = bounds.origin.y + bounds.size.height / 2
        //屏幕中心点
        let center = CGPoint(x: x, y: y)
        
        let path =  UIBezierPath.init()
        
        //最大的半径，就是最大的屏幕长的一半
        let maxRadius = hypot(bounds.size.width, bounds.size.height) / 2
        
        for currentRadius in stride(from: maxRadius, through: 0, by: -20) {
            path.move(to: CGPoint(x: center.x+currentRadius, y: center.y))
            path.addArc(withCenter: center, radius: currentRadius, startAngle: 0.0, endAngle: CGFloat(Double.pi  * 2), clockwise: true)
        }
        
        
        let endPoint = CGPoint(x: bounds.size.width, y: bounds.size.height)
        
        if let ctx = UIGraphicsGetCurrentContext(){
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let components:[CGFloat] = [1.0,0.0,0.0,1.0,1.0,1.0,0.0,1.0]
            let locations:[CGFloat]  = [0.0, 1.0]
            
            if let gradient = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: locations, count: 2){
                
                ctx.drawLinearGradient(gradient, start: CGPoint.zero, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
                
                //   CGGradientRelease(gradient)
                //   CGColorSpaceRelease(colorSpace)
            }
        }
        
        
        path.lineWidth = 10
        
        circleColor.setStroke()
        //绘制路径
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //获取三个0到1之间的数字
        let red   = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let green = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let blue  = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
        self.circleColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        
        self.setNeedsDisplay()
    }
    
    func drawHypnoticMessage(message:String){
        for _ in 0...5{
            let msgLbl = UILabel.init()
            
            msgLbl.backgroundColor = UIColor.clear
            msgLbl.textColor = UIColor.white
            msgLbl.text = message
            msgLbl.sizeToFit()
            
            let width =  (self.bounds.size.width - msgLbl.bounds.size.width);
            let height = (self.bounds.size.height - msgLbl.bounds.size.height);
            
            let x =  CGFloat(Float(arc4random()) / Float(UINT32_MAX))*width
            let y =  CGFloat(Float(arc4random()) / Float(UINT32_MAX))*height
            
            var frame = msgLbl.frame
            frame.origin = CGPoint.init(x: x, y: y)
            msgLbl.frame = frame
            msgLbl.textColor = UIColor.black
            
            addSubview(msgLbl)
            
            var motionEffect = UIInterpolatingMotionEffect.init(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
            motionEffect.minimumRelativeValue = -25
            motionEffect.maximumRelativeValue = 25
            msgLbl.addMotionEffect(motionEffect)
            
            motionEffect = UIInterpolatingMotionEffect.init(keyPath: "center.y", type: .tiltAlongHorizontalAxis)
            motionEffect.minimumRelativeValue = -25
            motionEffect.maximumRelativeValue = 25
            msgLbl.addMotionEffect(motionEffect)
         
            
        }
    }
    
}
