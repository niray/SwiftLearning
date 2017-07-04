//
//  HomeVC.swift
//  learing
//
//  Created by Niray on 2017/6/28.
//  Copyright © 2017年 Niray. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import MJRefresh

class HomeVC : UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
    
    
    var API_MEIZHI = "http://gank.io/api/search/query/listview/category/%E7%A6%8F%E5%88%A9/count/10/page/"
    
    var API_RACES = "http://api.huway.com/lequ/race/list"
    
    var page = 1
    
    var raceListArr : Array = Array<JSON>()
    
    lazy var tableV:UITableView = {
        let a = UITableView(frame: UIScreen.main.bounds)
        a.register(HomeEventCell.self, forCellReuseIdentifier: "eventId")
        a.delegate = self
        a.dataSource = self
        return a
    }()
    
    lazy var titleView : UIButton = {
       let tv = UIButton(frame: CGRect(x: 0, y: 310, width: 200, height: 35))
        tv.setTitle("首页 ⇩", for: [])
        tv.setTitleColor(UIColor.gray, for: .normal)
        
        tv.addTarget(self, action: #selector(self.showPopWindow),for:.touchUpInside)
        return tv
    }()
    
    lazy var popWindow :HomePopupWindow = HomePopupWindow()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        self.navigationItem.titleView = titleView
        
        self.getRaceList()
        
        tableV.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.getRaceList()
        })
        tableV.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.getRaceList()
        })
        
        self.view.addSubview(tableV)
        
    }
    
    func showPopWindow(){
        if  popWindow.isHidden {
                popWindow.showInView(view,self)
        }
    }
    
    func initHeader(){
        tableV.tableHeaderView = getViewPager()
    }
    
    func getViewPager() -> UIScrollView {
        let bounds = UIScreen.main.bounds
        let width = bounds.width
        let height = bounds.height / 3.0
        let svFrame = CGRect(x: 0, y: 0, width: width, height: height)
        let vp = UIScrollView(frame: svFrame)
        vp.backgroundColor = UIColor.lightGray
        vp.isPagingEnabled = true
        vp.bounces = false
        vp.showsHorizontalScrollIndicator = false
        vp.delegate = self
        
        self.raceListArr.reversed().enumerated().forEach { (idx,json) in
            let ivFrame = CGRect(x: bounds.width * CGFloat(idx), y: 0, width: width, height: height)
            let iv = UIImageView(frame: ivFrame)
            iv.isUserInteractionEnabled = true
            iv.tag = idx
            let tap = UITapGestureRecognizer(target: self, action: #selector(onClickTopImageAt))
            iv.addGestureRecognizer(tap)
            
            let data = self.raceListArr[idx]
            let urlStr = data["coverImage"].string ?? ""
            urlStr.intoIV(uiv: iv)
            iv.contentMode = .scaleToFill
            
            vp.addSubview(iv)
        }
        vp.contentSize = CGSize(width: CGFloat(self.raceListArr.count) *  bounds.width , height:height)
        
        return vp
    }
    
    @objc func onClickTopImageAt(_ tap:UITapGestureRecognizer){
        if let v = tap.view {
            debugPrint(v.tag)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        debugPrint(scrollView.contentOffset)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return raceListArr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let a = tableView.dequeueReusableCell(withIdentifier: "eventId")
        
        if let b = a as? HomeEventCell{
            let jsonData = self.raceListArr[indexPath.row]
            b.updateCellDate(jsonData)
        }        
        return a!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       return indexPath.row < raceListArr.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        raceListArr.remove(at: indexPath.row)
        tableV.deleteRows(at: [indexPath], with: .right)
    }
    
    func getRaceList(){
        SVProgressHUD.show()
        
        var url = "\(API_MEIZHI)\(self.page - 1)"
        
        if(self.page<2){
            url = API_RACES
        }
        
        debugPrint("\(self.page) \(url)")

        Alamofire.request(url).responseData {
            response in
            SVProgressHUD.dismiss()
            
            self.tableV.mj_header.endRefreshing()
            self.tableV.mj_footer.endRefreshing()
            
            switch response.result{
            case .success(let data):
                
                let jo = JSON(data:data)
                
                if(self.page<2){
                    self.raceListArr.removeAll()
                    if let arr = jo["data"].array{
                        self.raceListArr.append(contentsOf: arr)
                    }
                    self.initHeader()
                }else{
                    if let arr = jo["results"].array{
                        self.raceListArr.append(contentsOf: arr)
                    }
                }
                
                self.tableV.reloadData()
                
                self.page += 1
                break
            case .failure(let error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                break
            default:
                break
            }
        }
    }
    
}
