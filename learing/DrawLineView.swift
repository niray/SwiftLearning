//
//  DrawLineView.swift
//  learing
//
//  Created by Niray on 2017/7/4.
//  Copyright © 2017年 Niray. All rights reserved.
//

import Foundation
import UIKit

class DrawLineView: UIView,UIGestureRecognizerDelegate {
    
    var currentLine:Line? = nil
    //weak
    var  selectLine :Line? = nil
    
    var isMoving:Bool = false
    var linesInProgress:NSMutableDictionary = NSMutableDictionary()
    var finishedLines  : Array<Line>  = Array<Line>()
    
    lazy var doubleTapRecognizer:UITapGestureRecognizer = {
        let dtr = UITapGestureRecognizer.init(target: self,action:#selector(self.doubleTapEvent))
        dtr.numberOfTapsRequired = 2
        dtr.delaysTouchesBegan = true
        self.addGestureRecognizer(dtr)
        return dtr
    }()
    
    lazy var tapRecognizer:UITapGestureRecognizer = {
        let utg = UITapGestureRecognizer.init(target: self, action:#selector(self.tapEvent))
        utg.delaysTouchesBegan = true
        utg.require(toFail: self.doubleTapRecognizer)
        self.addGestureRecognizer(utg)
        return utg
    }()
    
    lazy var longRecognizer:UILongPressGestureRecognizer = {
        let ulg = UILongPressGestureRecognizer.init(target: self, action:#selector(self.longPressEvent))
        self.addGestureRecognizer(ulg)
        return ulg
    }()
    
    lazy var moveRecognizer:UIPanGestureRecognizer = {
        let mr = UIPanGestureRecognizer.init(target: self, action:#selector(self.moveLineEvent))
        mr.delegate = self
        mr.cancelsTouchesInView = false
        return mr
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isMultipleTouchEnabled = true
        self.backgroundColor = UIColor.lightGray
        
        self.addGestureRecognizer(doubleTapRecognizer)
        self.addGestureRecognizer(tapRecognizer)
        self.addGestureRecognizer(longRecognizer)
        self.addGestureRecognizer(moveRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //单击
    func tapEvent(gr:UIGestureRecognizer){
        let point = gr.location(in: self)
        self.selectLine = lineAtPoint(p: point)
        if selectLine != nil {
            self.becomeFirstResponder()
            
            let menu = UIMenuController.shared
            let deleteMenu = UIMenuItem.init(title: "删除", action: #selector(self.deleteLine))
            
            menu.menuItems = [deleteMenu]
            menu.setTargetRect(CGRect(x: point.x, y: point.y, width: 2, height: 2), in: self)
            menu.setMenuVisible(true, animated: true)
        } else {
            UIMenuController.shared.setMenuVisible(false, animated: true)
        }
        
        self.setNeedsDisplay()
    }
    
    //双击
    func doubleTapEvent(gr:UIGestureRecognizer){
        self.linesInProgress.removeAllObjects()
        self.finishedLines.removeAll()
        self.setNeedsDisplay()
    }
    
    //移动线条
    func moveLineEvent(gr:UIPanGestureRecognizer){
        if(self.selectLine != nil){
            if gr.state == UIGestureRecognizerState.changed{
                let translation = gr.translation(in: self)
                var begin = selectLine?.begin
                var end = selectLine?.end
                
                begin?.x += translation.x
                begin?.y += translation.y
                
                end?.x += translation.x
                end?.y += translation.y
                
                self.selectLine?.begin = begin!
                self.selectLine?.end = end!
                
                self.setNeedsDisplay()
                
                gr.setTranslation(CGPoint.zero, in: self)
            }
        }
    }
    
    //长按事件
    func longPressEvent(gr:UIGestureRecognizer){
        if(gr.state == UIGestureRecognizerState.began){
            let point = gr.location(in: self)
            selectLine = self.lineAtPoint(p: point)
            if selectLine != nil{
                self.linesInProgress.removeAllObjects()
            }
        }else if(gr.state == UIGestureRecognizerState.ended){
            self.selectLine = nil
        }
        self.setNeedsDisplay()
    }
    
    //删除线条
    func deleteLine(){
        self.finishedLines = self.finishedLines.filter { (line) -> Bool in
            return (self.selectLine?.begin != line.begin && self.selectLine?.end != line.end)
        }
        self.selectLine = nil
        self.setNeedsDisplay()
    }
    
    func lineAtPoint(p:CGPoint) -> Line? {
        for line in self.finishedLines{
            if let l = line as? Line{
                let start = l.begin
                let end = l.end
                for t in stride(from: 0.0, through: 1.0, by: +0.05) {
                    let x = start.x + CGFloat(t * Double(end.x - start.x))
                    let y = start.y + CGFloat(t * Double(end.y - start.y))
                    if(hypot(x - p.x, y - p.y) < 20.0){
                        return l
                    }
                }
            }
        }
        return nil
    }
    
    func strokeLine(line:Line){
        let path = UIBezierPath()
        path.lineWidth = 10
        path.lineCapStyle = CGLineCap.round
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        self.isMoving = (self.moveRecognizer == gestureRecognizer)
        return self.isMoving
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.black.set()
        self.finishedLines.forEach { (line) in
            self.strokeLine(line: line)
        }
        
        UIColor.red.set()
        for line in self.linesInProgress.allValues{
            if let l = line as? Line {
                self.strokeLine(line: l)
                debugPrint("draw red\( self.linesInProgress.count )")
            }
        }
        
        if let sl = self.selectLine as? Line {
            UIColor.green.set()
            self.strokeLine(line: sl)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        debugPrint("touchesBegan")
        if(self.selectLine == nil){
            for t in touches {
                let location = t.location(in: self)
                let line = Line()
                line.begin = location
                line.end = location
                
                let key = NSValue.init(nonretainedObject: t)
                
                self.linesInProgress.setValue(line, forKey:"\(key)")
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let key = NSValue.init(nonretainedObject: t)
            if let line = self.linesInProgress.value(forKey:"\(key)") as? Line{
                line.end = t.location(in: self)
                debugPrint("touchesMoved")
            }
        }
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{
            let key = NSValue.init(nonretainedObject: t)
            if let line = self.linesInProgress.value(forKey:"\(key)") as? Line{
                self.finishedLines.append(line)
                debugPrint("appendFinishLine")
            }
            self.linesInProgress.removeObject(forKey:"\(key)")
            debugPrint("removeProgressLine")
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{
            let key = NSValue.init(nonretainedObject: t)
            self.linesInProgress.removeObject(forKey:  "\(key)")
        }
        self.setNeedsDisplay()
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    

    
    class Line  {
        var begin :CGPoint = CGPoint(x: 0, y: 0)
        var end   :CGPoint = CGPoint(x: 0, y: 0)
    }
    
}
