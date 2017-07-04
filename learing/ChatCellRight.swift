//
//  ChatCellRight.swift
//  learing
//
//  Created by Niray on 2017/7/3.
//  Copyright © 2017年 Niray. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class ChatCellRight: UITableViewCell {
    
    static var reuseId = "chatR"
    
    var screenW = UIScreen.main.bounds.width
    
    lazy var ivAvatar : UIImageView = {
        let mIv = UIImageView()
        mIv.contentMode = .scaleAspectFit
        mIv.kf.setImage(with: URL(string:"https://avatars1.githubusercontent.com/u/19701994?v=3&s=70"))
        return mIv
    }()
    
    lazy var lblNickname : UILabel = {
        let mLbl = UILabel()
        mLbl.textColor = UIColor.lightGray
        mLbl.textAlignment = .right
        mLbl.font = UIFont.systemFont(ofSize: 13)
        return mLbl
    }()
    
    lazy var lblContent:UILabel = {
        let mLbl = UILabel()
        mLbl.textColor = UIColor.black
        mLbl.font = UIFont.systemFont(ofSize: 16)
        mLbl.preferredMaxLayoutWidth = self.screenW - 170
        return mLbl
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(ivAvatar)
        
        ivAvatar.snp.makeConstraints { (m) in
            m.width.equalTo(30)
            m.height.equalTo(30)
            m.right.equalToSuperview().offset(-15)
            m.top.equalToSuperview().offset(15)
        }
        self.contentView.addSubview(lblNickname)
        
        lblNickname.snp.makeConstraints { (m) in
            m.right.equalToSuperview().offset(-65)
            m.top.equalToSuperview().offset(15)
        }
        self.contentView.addSubview(lblContent)
        
        lblContent.snp.makeConstraints { (m) in
            m.right.equalToSuperview().offset(-65)
            m.top.equalTo(self.lblNickname.snp.bottom).offset(15)
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateChatContent(bean:ChatBean){
        if !bean.avatar.isEmpty {
            self.ivAvatar.kf.setImage(with:URL(string: bean.avatar))
        }
        
        self.lblNickname.text = "\(bean.nickName) \(bean.date)"
        self.lblContent.text = bean.content
    }
    
    
    func getCellHeight(content:String) -> CGFloat {
        lblContent.text = content
        return lblContent.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + 50
    }
    
    
    
}

