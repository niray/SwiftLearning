//
//  GGPushView.swift
//  Huway
//
//  Created by Gorey on 16/8/15.
//  Copyright © 2016年 中华户外网. All rights reserved.
//

import Foundation
import UIKit

// 自下而上弹出的BaseView
class GGPushBaseView: UIView{
    
    // INPUT
    var onClick:((Void)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var bgView : UIControl = {
        let a = UIControl(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height))
        a.addTarget(self, action: #selector(hideInView), for: .touchUpInside)
        a.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        a.alpha = 0
        return a
    }()
    
    
    func initSubview(){
        self.isHidden = true
        
        self.backgroundColor = UIColor.white
    }
    
    func showInView(_ view:UIView, frame:CGRect) -> Void {
        if self.isHidden {
            self.isHidden = false
            
            if bgView.superview == nil {
                view.addSubview(bgView)
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.bgView.alpha = 1
            })
        }
        
        let ani = CATransition()
        ani.duration = 0.2
        ani.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        ani.type = kCATransitionPush
        ani.subtype = kCATransitionFromTop
        
        self.layer.add(ani, forKey: "ani")
        
        self.frame = frame
        view.addSubview(self)
    }
    
    
    func hideInView() -> Void {
        if !self.isHidden {
            self.isHidden = true
            
            let ani = CATransition()
            ani.duration = 0.2
            ani.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            ani.type = kCATransitionPush
            ani.subtype = kCATransitionFromBottom
            
            self.layer.add(ani, forKey: "an")
            
            UIView.animate(withDuration: 0.2,
                                       animations: {
                                        self.bgView.alpha = 0
                                        },
                                       completion: { (isFinished) in
                                        if isFinished {
                                            self.removeFromSuperview()
                                        }
            })
        }
    }
    
}
