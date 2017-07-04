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
    var selectLine :Line? = nil
    
    var isMoving:Bool = false
    var linesInProgress:NSMutableDictionary = NSMutableDictionary()
    var finishedLines = Array<Line>()
    
    lazy var moveRecognizer:UIPanGestureRecognizer = {
        let mr = UIPanGestureRecognizer.init(target: self, action:#selector(self.moveLineEvent))
        mr.delegate = self
        mr.cancelsTouchesInView = false
        self.addGestureRecognizer(mr)
        return mr
    }()
    
    lazy var doubleTapRecognizer:UITapGestureRecognizer = {
        let dtr = UITapGestureRecognizer.init(target: self, action:#selector(self.doubleTapEvent))
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
    
    
    lazy var longRecognizer:UITapGestureRecognizer = {
        let utg = UITapGestureRecognizer.init(target: self, action:#selector(self.longPressEvent))
        utg.require(toFail: self.doubleTapRecognizer)
        utg.delaysTouchesBegan = true
        self.addGestureRecognizer(utg)
        return utg
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isMultipleTouchEnabled = true
        self.backgroundColor = UIColor.gray
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapEvent(gr:UIGestureRecognizer){
        let point = gr.location(in: self)
        self.selectLine = lineAtPoint(p: point)
        if let line = selectLine as? Line {
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
    
    func deleteLine(){
        
    }
    
    func doubleTapEvent(gr:UIGestureRecognizer){
        self.linesInProgress.removeAllObjects()
        self.finishedLines.removeAll()
        self.setNeedsDisplay()
    }
    
    func moveLineEvent(gr:UIGestureRecognizer){
        
    }
    
    func longPressEvent(gr:UIGestureRecognizer){
        
    }
    
    
    func lineAtPoint(p:CGPoint) -> Line? {
        for line in self.finishedLines{
                let start = line.begin
                let end = line.end
                for t in stride(from: 0.0, through: 1.0, by: +0.05) {
                    let x = start.x + CGFloat(t * Double(end.x - start.x))
                    let y = start.y + CGFloat(t * Double(end.y - start.y))
                    if(hypot(x - p.x, y - p.y) < 20.0){
                        return line
                    }
            }
        }
        return nil
    }
    
    
    class Line {
        var begin :CGPoint = CGPoint(x: 0, y: 0)
        var end :CGPoint = CGPoint(x: 0, y: 0)
    }
    
}
