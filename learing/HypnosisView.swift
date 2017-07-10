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
    
    var ivAvatar : UIImage? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        self.clipsToBounds = true
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
        
      
        //渐变
        if let ctx = UIGraphicsGetCurrentContext(){
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let components:[CGFloat] = [1.0,1.0,1.0,1.0,1.0,1.0,0.0,1.0]
            let locations:[CGFloat]  = [0.0, 1.0]
            
            if let gradient = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: locations, count: 2){
                
                ctx.drawLinearGradient(gradient, start: CGPoint.zero, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
                
                //   CGGradientRelease(gradient)
                //   CGColorSpaceRelease(colorSpace)
            }
        
        }
        
        if let ia = ivAvatar  {
            ia.draw(in: rect, blendMode: .normal, alpha: 0.45)
        
        }
        
        //圆
        path.lineWidth = 10
        
        circleColor.setStroke()
        //绘制路径
        path.stroke()
        
        drawAspiral()
    
    }
    
    
    func drawAspiral() {
        if let ctx = UIGraphicsGetCurrentContext(){
            let centerW = Double(self.bounds.width / 2)
            let centerH = Double(self.bounds.height / 2)
            
            ctx.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            ctx.setLineWidth(5.0)
            ctx.move(to: CGPoint(x: centerW, y:centerH))
            
            let a = 2.0
            for t in stride(from: 0.0, through: 25 * 3.1415926, by: +0.1){
                let r = a * t
                let x = centerW + r * cos(t)
                let y = centerH + r * sin(t)
                
                ctx.addLine(to: CGPoint(x: x, y: y))
                ctx.strokePath()
                ctx.move(to: CGPoint(x: x, y: y))
            }
        }
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //获取三个0到1之间的数字
        let red   = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let green = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let blue  = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
        self.circleColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        
        self.setNeedsDisplay()
    }
    
    func setUIImage(iv:UIImage){
        self.ivAvatar = iv
        self.setNeedsDisplay()
    }
    
    func drawHypnoticMessage(message:String){
        //Clear old sub views
        subviews.forEach { (v) in
            v.removeFromSuperview()
        }
        for _ in 0...2{
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
