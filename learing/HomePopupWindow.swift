//
//  HomePopupWindow.swift
//  learing
//
//  Created by Niray on 2017/6/30.
//  Copyright © 2017年 Niray. All rights reserved.
//

import Foundation
import SnapKit

class HomePopupWindow: GGPushBaseView {
    
    lazy var SCREEN_W = UIScreen.main.bounds.size.width
    lazy var SCREEN_H = UIScreen.main.bounds.size.height
    
    var outerVC :UIViewController? = nil
    
    override func initSubview() {
        super.initSubview()
        
        let alertV  = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_W, height: SCREEN_H))
        alertV.backgroundColor = UIColor.white
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 250, height: 75))
        btn.setTitle("Alert", for: [])
        btn.backgroundColor  = UIColor.lightGray
        btn.addTarget(self, action: #selector(self.onAlertShow), for: .touchUpInside)
        alertV.addSubview(btn)
        
        self.addSubview(alertV)
        
        alertV.snp_makeConstraints { (m) in
            m.left.equalTo(self)
            m.right.equalTo(self)
            m.bottom.equalTo(self)
            m.top.equalTo(self)
        }
        
        btn.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(100)
            make.top.equalTo(self).offset(123)
            make.right.equalTo(self).offset(-220)
        }
        
    }
    
    func onAlertShow(){
        let alertUI = UIAlertController(title: "Warning", message: "Are you ok?", preferredStyle: .alert)
        let fineItem = UIAlertAction(title: "Fine", style: .default) { (act) in
            self.hideInView()
        }
        let badItem = UIAlertAction(title: "Bad", style: .cancel) { (act) in
            self.hideInView()
        }
        alertUI.addAction(fineItem)
        alertUI.addAction(badItem)
        outerVC?.present(alertUI,animated:true){
            
        }
    }
    
    func showInView(_ view: UIView,_ vc:UIViewController) {
        let vHeight = CGFloat(SCREEN_H / 2)
        let frame = CGRect(x: 0, y: view.frame.size.height - vHeight, width: SCREEN_W,height: SCREEN_H)
        self.outerVC = vc
        super.showInView(view, frame: frame)
    }
    
}
