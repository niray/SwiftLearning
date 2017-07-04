//
//  AutoFitHCell.swift
//  Gank
//
//  Created by Huway Mac on 16/9/28.
//  Copyright © 2016年 Android Developer. All rights reserved.
//

import Foundation
import UIKit

class AutoFitHCell : UITableViewCell {
    
    let edgeValue :Int = 10
    
    lazy var lbl :UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.preferredMaxLayoutWidth = UIScreen.main.bounds.width -  20
        return l
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(lbl)
        lbl.snp_makeConstraints { (make) in
            make.edges.equalTo(self).inset(edgeValue)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fitHeight(){
        let lb = UILabel()
        
        lb.numberOfLines = 0
        lb.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 20
        lb.text = ""
        let size = lb.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
}
