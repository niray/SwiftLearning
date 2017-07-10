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

class UserVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    lazy var tfInput:UITextField = {
        let mTf = UITextField()
        mTf.placeholder = "Hypnotize me"
        mTf.returnKeyType = .done
        mTf.delegate = self
        mTf.borderStyle = .roundedRect
        return mTf
    }()
    
    lazy var btnAvatar:UIButton = {
        let btn = UIButton()
        btn.setTitle("更换头像", for: [])
        btn.setTitleColor(UIColor.gray, for: [])
        btn.addTarget(self, action: #selector(self.pickAvatar), for: .touchUpInside)
        return btn
    }()
    
    lazy var ivAvatar :UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.lightGray
        return iv
    }()
    
    lazy var datePicker:UIDatePicker = UIDatePicker()
    
    lazy var hypnosisView:HypnosisView = HypnosisView(frame: CGRect.zero)
    
    
    
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
        
        hypnosisView.snp.makeConstraints { (m) in
            m.width.equalTo(100)
            m.height.equalTo(100)
            
            m.centerX.equalToSuperview()
            m.top.equalToSuperview().offset(100)
        }
        
        self.view.addSubview(tfInput)
        
        tfInput.snp.makeConstraints { (m) in
            m.width.equalTo(100)
            m.height.equalTo(30)
            
            m.centerX.equalToSuperview()
           
            m.top.equalToSuperview().offset(220)
        }
        
        self.view.addSubview(btnAvatar)
        
        btnAvatar.snp.makeConstraints { (m) in
            m.top.equalTo(self.tfInput.snp.bottom).offset(10)
            m.centerX.equalToSuperview()
        }
        
        self.view.addSubview(ivAvatar)
        ivAvatar.snp.makeConstraints { (m) in
            m.width .equalTo(100)
            m.height.equalTo(100)
            m.top.equalTo(self.btnAvatar.snp.bottom).offset(10)
            m.centerX.equalToSuperview()
        }
        
        addAnimOnAvatar()
        
    }
    
    func pickAvatar(){
        let imagePicker = UIImagePickerController.init()
        
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        }else{
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true) {
            
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        //等UIImagePickerController消失后再去调用image
        
        self.dismiss(animated: true) {
            
            if let image  = info[UIImagePickerControllerEditedImage] as? UIImage{
                self.ivAvatar.image = image
                self.hypnosisView.setUIImage(iv: image)
            }else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
                self.ivAvatar.image = img
                self.hypnosisView.setUIImage(iv: img)
            }
        }        
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
