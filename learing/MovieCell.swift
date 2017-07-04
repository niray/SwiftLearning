//
//  MovieCell.swift
//  learing
//
//  Created by Niray on 2017/6/30.
//  Copyright © 2017年 Niray. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SwiftyJSON
import SnapKit

class MovieCell: UITableViewCell {
    
    var leftMargin = 15
    
    lazy var ivPoster:UIImageView = {
        let mIv = UIImageView()
        return mIv
    }()
    
    lazy var tfName : UILabel = {
        let mTf = UILabel()
        mTf.textColor = UIColor.colorWithHexString(hex: "#333333")
        mTf.font = UIFont.systemFont(ofSize: 18.0)
        return mTf
    }()
    
    lazy var tfYear :UILabel = {
        let mTf = UILabel()
        mTf.textColor = UIColor.colorWithHexString(hex: "#999999")
        mTf.font = UIFont.systemFont(ofSize: 13.0)
        return mTf
    }()
    
    lazy var tfDirectors : UILabel = {
        let mTf = UILabel()
        mTf.textColor = UIColor.colorWithHexString(hex: "#666666")
        mTf.font = UIFont.systemFont(ofSize: 14.0)
        return mTf
    }()
    
    lazy var tfCasts :UILabel = {
        let mTf = UILabel()
        mTf.textColor = UIColor.colorWithHexString(hex: "#666666")
        mTf.font = UIFont.systemFont(ofSize: 14.0)
        return mTf
    }()
    
    lazy var tfRating :UILabel = {
        let mTf = UILabel()
        mTf.textColor = UIColor.colorWithHexString(hex: "#666666")
        mTf.font = UIFont.systemFont(ofSize: 14.0)
        return mTf
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        
        self.contentView.addSubview(ivPoster)
        self.contentView.addSubview(tfName)
        self.contentView.addSubview(tfYear)
        self.contentView.addSubview(tfDirectors)
        self.contentView.addSubview(tfCasts)
        self.contentView.addSubview(tfRating)
        
        ivPoster.snp.makeConstraints { (m) in
            m.width.equalTo(100)
            m.height.equalTo(150)
            m.left.equalToSuperview().offset(15)
            m.top.equalToSuperview().offset(15)
            m.bottom.equalToSuperview().offset(-15)
        }
        
        tfName.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(35)
            m.left.equalTo(ivPoster.snp.right).offset(leftMargin)
            m.right.equalTo(tfYear.snp.left).offset(-leftMargin)
        }
        
        tfYear.snp.makeConstraints { (m) in
            m.left.equalTo(tfName.snp.right).offset(20)
            m.top.equalToSuperview().offset(38)
        }
        
        tfDirectors.snp.makeConstraints { (m) in
            m.left.equalTo(ivPoster.snp.right).offset(leftMargin)
            m.top.equalTo(tfName.snp.bottom).offset(10)
            m.right.equalToSuperview().offset(-leftMargin)
        }
        
        tfCasts.snp.makeConstraints { (m) in
            m.left.equalTo(ivPoster.snp.right).offset(leftMargin)
            m.top.equalTo(tfDirectors.snp.bottom).offset(10)
            m.right.equalToSuperview().offset(-leftMargin)
        }
        
        tfRating.snp.makeConstraints { (m) in
            m.left.equalTo(ivPoster.snp.right).offset(leftMargin)
            m.top.equalTo(tfCasts.snp.bottom).offset(10)
            m.right.equalToSuperview().offset(-leftMargin)
        }
    }
    
    func updateCellData(_ data: JSON){
        
        if let imgUri = data["images"]["medium"].string{
            let imgURL = URL(string: imgUri)
            self.ivPoster.kf.setImage(with:imgURL)
        }
        
        if let title = data["title"].string{
            self.tfName.text = title
        }
        
        if let year = data["year"].string{
            self.tfYear.text = "(\(year)年)"
        }
        
        if let dires = data["directors"].array{
            var directors = ""
            dires.forEach({ (dir) in
                   directors.append("\(dir["name"]) ")
            })
            self.tfDirectors.text = "导演：\(directors)"
        }
        
        if let casts = data["casts"].array{
            var castName = ""
            casts.forEach({ (c) in
                castName.append("\(c["name"]) ")
            })
            self.tfCasts.text = "主演：\(castName)"
        }
        
        if let rating = data["rating"]["average"].int{
            self.tfRating.text = "评分：\(rating)分"
        }
        
    }
    
}
