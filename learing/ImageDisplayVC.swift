//
//  lImageDisplayVC.swift
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

class ImageDisplayVC : UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    var currentIndex:Int = 0
    
    var screenW : CGFloat = UIScreen.main.bounds.width
    var screenH : CGFloat = UIScreen.main.bounds.height
    
    var dataArr = Array<JSON>()
    

    lazy var clcItemV : UICollectionViewFlowLayout = {
        let mFl = UICollectionViewFlowLayout()
        mFl.itemSize = CGSize(width: self.screenW, height: self.screenH)
        mFl.minimumLineSpacing = 0
        mFl.minimumInteritemSpacing = 0
        mFl.scrollDirection = .horizontal
        return mFl
    }()
    
    lazy var clcV:UICollectionView = {
        let mCV = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.clcItemV)
        
        mCV.delegate = self
        mCV.dataSource = self
        mCV.isPrefetchingEnabled = true
        mCV.isPagingEnabled = true
        
        return mCV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //全屏
        self.automaticallyAdjustsScrollViewInsets = false
        
        let naviItem = UIBarButtonItem(title: "聊天", style: .done, target: self, action: #selector(self.onChatClick))
       
        self.navigationItem.rightBarButtonItem = naviItem
        
        clcV.register(ImageCell.self, forCellWithReuseIdentifier: "cellId")
        
        self.view.addSubview(clcV)
        self.clcV.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        
        self.clcV.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenW = Int(UIScreen.main.bounds.width)
        let offset = screenW * currentIndex
        self.clcV.setContentOffset(CGPoint(x:offset , y: 0), animated: true)
    }
    
    func onChatClick(){
        let chatVC = ChatVC()
        chatVC.hidesBottomBarWhenPushed = true
        let currIndex = self.clcV.indexPathsForVisibleItems.first?.row ?? 0
        let avatar = self.dataArr[currIndex]["url"].string ?? ""
        chatVC.otherAvatar = avatar
        navigationController?.pushViewController(chatVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? ImageCell{
            cell.updateCellDate(dataArr[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
}
