//
//  ImageCell.swift
//  learing
//
//  Created by Niray on 2017/7/3.
//  Copyright © 2017年 Niray. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SwiftyJSON
import SnapKit

class ImageCell: UICollectionViewCell {
    
    
    lazy var imageV : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(imageV)
        
        self.imageV.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateCellDate(_ json:JSON){
        if let u = json["url"].string{
            self.imageV.kf.setImage(with:URL(string: u))
        }
      
    }
    
}
