//
//  LoginVC.swift
//  learing
//
//  Created by Niray on 2017/6/29.
//  Copyright © 2017年 Niray. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SVProgressHUD

class LoginVC:UIViewController{
    
    lazy var tfAcc:UITextField = {
        let mTf   = UITextField()
        mTf.placeholder = "请输入账号"
        mTf.backgroundColor = UIColor.lightGray
        
        return mTf
    }()
    
    lazy var tfPwd :UITextField = {
        let mTf = UITextField()
        mTf.isSecureTextEntry = true
        mTf.placeholder = "请输入密码"
        mTf.backgroundColor = UIColor.lightGray
        return mTf
    }()
    
    lazy var btnLogin :UIButton = {
        let mBtn = UIButton(type:.custom)
        mBtn.setTitle("登录", for: [])
        mBtn.setTitleColor(UIColor.black, for: .normal)
        mBtn.setTitleColor(UIColor.red, for: .highlighted)
        mBtn.backgroundColor = UIColor.lightGray
        mBtn.addTarget(self, action: #selector(self.onLoginClick), for: .touchUpInside)
        return mBtn
    }()
    
    lazy var btnReg :UIButton = {
        let mBtn = UIButton(type:.custom)
        mBtn.setTitle("注册", for: [])
        mBtn.setTitleColor(UIColor.black, for: .normal)
        mBtn.setTitleColor(UIColor.red, for: .highlighted)
        mBtn.backgroundColor = UIColor.lightGray
        mBtn.addTarget(self, action: #selector(self.getAccount), for: .touchUpInside)
        return mBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let btnBack = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backEvent))
        let btnSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAccPwd))
        
        self.navigationItem.rightBarButtonItem = btnSave
        self.navigationItem.leftBarButtonItem = btnBack
        
        self.view.addSubview(tfAcc)
        self.view.addSubview(tfPwd)
        self.view.addSubview(btnLogin)
        self.view.addSubview(btnReg)
        
        self.tfAcc.snp.makeConstraints { m in
            m.left.equalToSuperview().offset(50)
            m.right.equalToSuperview().offset(-50)
            m.top.equalToSuperview().offset(300)
            m.height.equalTo(30)
        }
        
        self.tfPwd.snp.makeConstraints { m in
            m.left.equalTo(self.tfAcc)
            m.right.equalTo(self.tfAcc)
            m.top.equalTo(self.tfAcc).offset(80)
            m.height.equalTo(30)
        }
        
        self.btnLogin.snp.makeConstraints{ m in
            m.left.equalTo(self.tfPwd.snp.left).offset(30)
            m.top.equalTo(self.tfPwd.snp.bottom).offset(50)
            m.width.equalTo(100)
            m.height.equalTo(35)
        }
        
        self.btnReg.snp.makeConstraints{ m in
            m.right.equalTo(self.tfPwd.snp.right).offset(-30)
            m.top.equalTo(self.btnLogin)
            m.width.equalTo(100)
            m.height.equalTo(35)
        }
        
          self.tfAcc.text = "huway"
          self.tfPwd.text = "password"
        
    }
    
    func onLoginClick(){
        if(self.tfAcc.text ==  "huway" && self.tfPwd.text == "password"){
            
            let date = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss"
            let strNowTime = timeFormatter.string(from: date) as String
            UserDefaults.standard.set(strNowTime, forKey: "token")
            backEvent()
        }else{
            SVProgressHUD.showError(withStatus: "账号密码错误")
        }
    }
    
    func backEvent(){
        self.navigationController?.dismiss(animated: true, completion: { 
            
        })
    }
    
    func saveAccPwd(){
        if let str = self.tfAcc.text {
            if str.isEmpty == false {
                saveAccount(id:str)
            }
        }
    }
    
    //存值
    func saveAccount(id:String){
       UserDefaults.standard.set(id, forKey: "acc")
    }
    
    //取值
    func getAccount(){
        UserDefaults.standard.synchronize()
        if let acc = UserDefaults.standard.value(forKey: "acc") as? String{
            self.tfAcc.text = acc
            debugPrint(acc)
        }
    }
    
}
