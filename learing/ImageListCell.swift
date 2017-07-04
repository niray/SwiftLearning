//
//  ImageListCell.swift
//  learing
//
//  Created by Niray on 2017/7/3.
//  Copyright © 2017年 Niray. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SwiftyJSON
import Kingfisher

class ImageListCell :UITableViewCell{
    
    lazy var iv_avatar :UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var lbl_content : UILabel = {
        let a = UILabel()
        a.numberOfLines = 0
        return a
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.clipsToBounds = true
        
        self.contentView.addSubview(iv_avatar)
        self.contentView.addSubview(lbl_content)
        
        self.iv_avatar.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.top.equalTo(self.contentView).offset(10)
            make.bottom.equalTo(self.contentView).offset(-70)
        }
        
        self.lbl_content.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(10)
            make.top.equalTo(self.iv_avatar.snp_bottom).offset(10)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCellDate(_ data:JSON){
        if let u = data["url"].string{
            iv_avatar.kf.setImage(with:URL(string: u))
        }
        lbl_content.text="\(data["who"].string ?? "")  \(data["desc"].string ?? "")  \(data["type"].string ?? "")"
    }
}
