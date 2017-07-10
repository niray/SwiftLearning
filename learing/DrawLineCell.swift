//
//  DrawLineCell.swift
//  learing
//
//  Created by Niray on 2017/7/6.
//  Copyright © 2017年 Niray. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SwiftyJSON
import SnapKit

class DrawLineCell: UITableViewCell {
    
    lazy var drawV:DrawLineView = {
        return DrawLineView.init(frame: CGRect.zero)
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.contentView.addSubview(drawV)
        
        self.drawV.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
