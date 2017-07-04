//
//  ChatVC.swift
//  learing
//
//  Created by Niray on 2017/7/3.
//  Copyright © 2017年 Niray. All rights reserved.
//

import Foundation
import UIKit

class ChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    var chatArray = Array<ChatBean>()
    
    var selfId = 23
    
    var otherAvatar = ""

    lazy var chatTableV: UITableView = {
        let mTableV = UITableView()
        mTableV.delegate = self
        mTableV.dataSource = self
        mTableV.register(ChatCellLeft.self, forCellReuseIdentifier: ChatCellLeft.reuseId)
        mTableV.register(ChatCellRight.self, forCellReuseIdentifier: ChatCellRight.reuseId)
        return mTableV
    }()
    
    lazy var fitHeightCell:ChatCellLeft = {
        let cell = ChatCellLeft(style: .default, reuseIdentifier: "fitH")
        return cell
    }()
    
    lazy var tfInput : UITextField = {
        let mTf = UITextField()
        mTf.backgroundColor = UIColor.lightGray
        mTf.delegate = self
        return mTf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ka_startObservingKeyboardNotifications()
        
        let rightBtn = UIBarButtonItem(title:
            "资料", style: .plain, target: self, action: #selector(self.onInfoClick))
        navigationItem.rightBarButtonItem = rightBtn
        
        
        self.view.addSubview(self.chatTableV)
        self.chatTableV.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        
        self.view.addSubview(tfInput)
        
        tfInput.snp.makeConstraints { (m) in
            m.bottom.equalToSuperview()
            m.left.equalToSuperview()
            m.right.equalToSuperview()
            m.height.equalTo(50)
        }
        
        
        initData()
        self.chatTableV.reloadData()
    }
    
    func initData(){
        chatArray.append(createChatBean(uid: 56, date: "16:45", avatar: otherAvatar, nickName: "Justin Bieber", content: "For all the times that you rained on my parade"))
        
        chatArray.append(createChatBean(uid: 56, date: "16:45", avatar: otherAvatar, nickName: "Justin Bieber", content: "And all the clubs you get in using my name"))
        
        chatArray.append(createChatBean(uid: selfId, date: "16:47", avatar: "", nickName: "Love Yourself", content: "You think I'm crying oh my own well no I ain't "))
        
        chatArray.append(createChatBean(uid: 56, date: "16:46", avatar: otherAvatar, nickName: "Justin Bieber", content: "You think you broke my heart, oh girl for goodness sake"))
        
        chatArray.append(createChatBean(uid: selfId, date: "16:48", avatar: "", nickName: "Love Yourself", content: "And I didn't wanna write a song cause "))
        
        chatArray.append(createChatBean(uid: selfId, date: "16:49", avatar: "", nickName: "Love Yourself", content: "Oh baby you should go and love yourself "))
    }
    
    func createChatBean(
        uid :Int,
        date :String,
        avatar:String,
        nickName:String,
        content:String
        )->ChatBean{
        let cb = ChatBean()
        cb.uid = uid
        cb.date = date
        cb.avatar = avatar
        cb.nickName = nickName
        cb.content = content
        return cb
    }
    
    func onInfoClick(){
        let alertUI = UIAlertController(title: "提示", message: "您当前的VIP等级不能查看资料，请尽快充值为SVIP?", preferredStyle: .alert)
        let fineItem = UIAlertAction(title: "去充值", style: .default) { (act) in
            
        }
        let badItem = UIAlertAction(title: "算了", style: .cancel) { (act) in
            
        }
        alertUI.addAction(fineItem)
        alertUI.addAction(badItem)
        self.present(alertUI,animated:true){
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.ka_startObservingKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.ka_stopObservingKeyboardNotifications()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let inputContent = tfInput.text{
            let date = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss"
            let strNowTime = timeFormatter.string(from: date) as String
            let cb = createChatBean(uid: selfId, date: strNowTime, avatar: otherAvatar, nickName: "LoveYourself", content: inputContent)
            self.chatArray.append(cb)
        
            self.chatTableV.reloadData()
            let nsIndex = IndexPath(item: chatArray.count - 1, section: 0)
            self.chatTableV.scrollToRow( at: nsIndex , at: .bottom, animated: true)
        
            self.view.endEditing(true)
            self.tfInput.resignFirstResponder()
         
            tfInput.text = ""
        }

        return true
    }
    
    override func ka_keyboardWillShowOrHide(withHeight height: CGFloat, animationDuration: TimeInterval, animationCurve: UIViewAnimationCurve) {
        // 键盘动画
        tfInput.snp_updateConstraints{ m in
            m.left.equalTo(self.view)
            m.right.equalTo(self.view)
            m.bottom.equalTo(self.view).offset(-height)
            m.height.equalTo(49)
        }
        
        self.chatTableV.snp_updateConstraints { (make) in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(view).offset(-height - 50)
        }
        
        tfInput.setNeedsUpdateConstraints()
        tfInput.updateConstraintsIfNeeded()
        
        self.chatTableV.setNeedsUpdateConstraints()
        self.chatTableV.updateConstraintsIfNeeded()
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
            self.chatTableV.layoutIfNeeded()
            self.tfInput.layoutIfNeeded()
        }, completion:{b in
            if b {
                let nsIndex = IndexPath(item: self.chatArray.count - 1, section: 0)
                self.chatTableV.scrollToRow( at: nsIndex , at: .bottom, animated: true)
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content = self.chatArray[indexPath.row].content
        return fitHeightCell.getCellHeight(content: content)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chatData = self.chatArray[indexPath.row]
        if(chatData.uid == self.selfId){
            if let cell = tableView.dequeueReusableCell(withIdentifier:ChatCellRight.reuseId ) as? ChatCellRight{
                cell.updateChatContent(bean: chatData)
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: ChatCellLeft.reuseId) as? ChatCellLeft{
                cell.updateChatContent(bean: chatData)
                return cell
            }
        }        
        
        return UITableViewCell()
    }
    
    
}
