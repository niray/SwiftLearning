//
//  WebDetailVC.swift
//  learing
//
//  Created by Niray on 2017/6/30.
//  Copyright © 2017年 Niray. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class WebDetailVC: UIViewController {
    
    var url :String = ""

    var webView:UIWebView = UIWebView()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
    }
    
    func loadUrl(_ urlStr:String){
        if let url = URL(string:urlStr) {
            webView.loadRequest(URLRequest(url: url))
        }
    }
    
    
}
