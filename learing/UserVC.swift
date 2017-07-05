//
//  UserVC.swift
//  learing
//
//  Created by Niray on 2017/6/28.
//  Copyright © 2017年 Niray. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class UserVC: UIViewController,UITextFieldDelegate{
    
    
    lazy var tfInput:UITextField = {
        let mTf = UITextField()
        mTf.placeholder = "Hypnotize me"
        mTf.returnKeyType = .done
        mTf.delegate = self
        mTf.borderStyle = .roundedRect
        return mTf
    }()
    
    lazy var datePicker:UIDatePicker = UIDatePicker()
    
    lazy var hypnosisView:HypnosisView = HypnosisView(frame: CGRect.zero)
    
    
    let w = (UIScreen.main.bounds.width - 100)/2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "我的"
        initView()
    }
    
    func initView(){
        
        datePicker.datePickerMode = .time
//      datePicker.datePickerMode = .countDownTimer
        datePicker.locale = Locale.init(identifier: "zh_CN")
        datePicker.addTarget(self, action: #selector(self.dateChanged), for: .valueChanged)
        
        view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { (m) in
            m.right.equalToSuperview().offset(-50)
            m.bottom.equalToSuperview().offset(-50)
            m.width.equalTo(220)
        }
        
        view.addSubview(hypnosisView)
        
        hypnosisView.circleColor = UIColor.red
        hypnosisView.backgroundColor = UIColor.purple
        
        hypnosisView.snp.makeConstraints { (m) in
            m.width.equalTo(100)
            m.height.equalTo(100)
            
            m.left.equalToSuperview().offset(w)
            m.right.equalToSuperview().offset(-w)
            m.top.equalToSuperview().offset(100)
        }
        
        self.view.addSubview(tfInput)
        
        tfInput.snp.makeConstraints { (m) in
            m.width.equalTo(100)
            m.height.equalTo(30)
            
            m.left.equalToSuperview().offset(w)
            m.right.equalToSuperview().offset(-w)
            m.top.equalToSuperview().offset(220)
        }
        addAnimOnAvatar()
        
        self.view = DrawLineView.init(frame: CGRect.zero)
        
    }
    
    func addAnimOnAvatar(){
        self.hypnosisView.alpha = 0
        
        UIView.animate(withDuration: 2, animations: { () -> Void in
            self.hypnosisView.alpha = 1
            self.hypnosisView.frame.origin.x = 0
            self.hypnosisView.frame.origin.y = 0
        }, completion: { (isFinished) -> Void in
            debugPrint("Finished\(isFinished)2")
        })
    }
    
    //日期选择器响应方法
    func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        debugPrint(formatter.string(from: datePicker.date))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hypnosisView.drawHypnoticMessage(message: self.tfInput.text ?? "")
        self.tfInput.text = ""
        self.tfInput.resignFirstResponder()
        return true
    }
    
    
}
