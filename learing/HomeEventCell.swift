//
//  HomeEventCell.swift
//  learing
//
//  Created by Niray on 2017/6/29.
//  Copyright © 2017年 Niray. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SwiftyJSON

class HomeEventCell: UITableViewCell {
    
    lazy var cellW : CGFloat = {
        return UIScreen.main.bounds.width
        }()
    
    lazy var ivTop : UIImageView = {
        let mIV = UIImageView()
        mIV.frame = CGRect(x: 10, y: 10, width: self.cellW - CGFloat(20), height: 250)
        mIV.contentMode = .scaleAspectFill
        mIV.clipsToBounds = true
        return mIV
    }()
    
    lazy var tfTitle : UITextField = {
        let mTF = UITextField()
        mTF.frame = CGRect(x: 10, y: 250, width: self.cellW - CGFloat(20), height: 50)
        return mTF
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func updateCellDate(_ data:JSON){
        
        let imgUrl = data["coverImage"].string?.toHuwayImgURL
        
        let imgMZ =  data["url"].string ?? ""
        
        let title = data["title"].string ?? ""
        
        let titleMZ = "\(data["who"].string ?? "")  \(data["desc"].string ?? "")  \(data["type"].string ?? "")"
        
        if imgMZ.isEmpty == true{
            ivTop.kf.setImage(with:imgUrl)
        }else{
            ivTop.kf.setImage(with:URL(string: imgMZ))
        }
        
        if title.isEmpty == true {
            tfTitle.text = titleMZ
        }else{
            tfTitle.text = title
        }
        
        self.contentView.addSubview(ivTop)
        self.contentView.addSubview(tfTitle)
    }
    
    
    
}
