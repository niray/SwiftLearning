//
//  NewsVC.swift
//  learing
//
//  Created by Niray on 2017/6/28.
//  Copyright © 2017年 Niray. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SVProgressHUD
import MJRefresh
import SwiftyJSON

class NewsVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var API_GITHUB = "http://gank.io/api/search/query/listview/category/all/count/10/page/"
    
    //豆瓣电影API
    var API_MOVIE = "http://api.douban.com/v2/movie/top250?"
    
    //图片
    var API_MEIZHI = "http://gank.io/api/search/query/listview/category/%E7%A6%8F%E5%88%A9/count/10/page/"
    
    var dataArr:Array = Array<JSON>()
    
    var page = 0
    
    lazy var measureCell:AutoFitHCell = {
        let mCell = AutoFitHCell(style: .default, reuseIdentifier: "measure")
        return mCell
    }()
    
    lazy var segement : UISegmentedControl = {
        let mSC = UISegmentedControl(items: ["电影","文章","妹子"])
        mSC.frame  = CGRect(x: 0, y: 0, width: 175, height: 26)
        mSC.selectedSegmentIndex = 0
        mSC.addTarget(self, action: #selector(self.onSegementChanged), for: .valueChanged)
        return mSC
    }()
    
    lazy var tableV : UITableView = {
        let mTv = UITableView(frame: UIScreen.main.bounds)
        mTv.delegate = self
        mTv.dataSource = self
        mTv.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.onSegementChanged()
        })
        mTv.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.requestData()
        })
        mTv.register(MovieCell.self, forCellReuseIdentifier: "movie")
        mTv.register(AutoFitHCell.self, forCellReuseIdentifier: "txt")
        mTv.register(ImageListCell.self, forCellReuseIdentifier: "mzPic")
        
        return mTv
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor.white
        navigationItem.titleView = segement
        
        self.view.addSubview(tableV)
        requestMovieList()
    }
    
    func onSegementChanged(){
        self.page = 1
        self.dataArr.removeAll()
        self.tableV.reloadData()
        self.requestData()
    }
    
    func requestData(){
        switch self.segement.selectedSegmentIndex {
        case 0:
            self.requestMovieList()
        case 1,2:
            self.requestDataList()
        default:
            break
        }
    }
    
    //TableView点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = self.dataArr[indexPath.row]
        switch segement.selectedSegmentIndex {
        case 0:
            let webDetail = WebDetailVC()
            let url = data["alt"].string ?? ""
            webDetail.loadUrl(url)
            webDetail.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(webDetail, animated: true)
        case 1:
            let wv = WebDetailVC()
            wv.loadUrl(data["url"].string ?? "")
            wv.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(wv, animated: true)

        case 2:
            let displayVC = ImageDisplayVC()
            displayVC.dataArr = self.dataArr
            displayVC.currentIndex = indexPath.item
            displayVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(displayVC, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch segement.selectedSegmentIndex {
        case 0:
            return 200
        case 1:
            let data = self.dataArr[indexPath.row]
            measureCell.lbl.text = data["desc"].string
            let size = measureCell.lbl.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            return size.height + 20
        case 2:
            return 720
        default:
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.dataArr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        
        let data = self.dataArr[indexPath.row]
        
        switch segement.selectedSegmentIndex {
        case 0:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "movie") as? MovieCell{
                cell.updateCellData(data)
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "txt") as? AutoFitHCell{
                cell.lbl.text = data["desc"].string
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "mzPic") as? ImageListCell{
                cell.updateCellDate(data)
                return cell
            }
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    //获取豆瓣电影列表
    func requestMovieList(){
        SVProgressHUD.show()
        let requestUrl = "\(API_MOVIE)start=\(self.page*10)&count=\(self.page*10+10)"
        Alamofire.request(requestUrl).responseData {
            (resp) in
            self.tableV.mj_header.endRefreshing()
            self.tableV.mj_footer.endRefreshing()
            SVProgressHUD.dismiss()
            
            switch resp.result{
                case .success(let data):
                    if(self.page == 1){
                        self.dataArr.removeAll()
                    }
                    let json = JSON(data:data)
                    if let arr = json["subjects"].array{
                        self.dataArr.append(contentsOf: arr)
                    }
                    
                    self.tableV.reloadData()
                    self.page += 1
                    
                break
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                break
          }
        }
    }
    
    func requestDataList(){
        SVProgressHUD.show()
        var url = "\(API_GITHUB)\(self.page)"
        
        if(self.segement.selectedSegmentIndex == 2){
             url = "\(API_MEIZHI)\(self.page)"
        }
        
        Alamofire.request(url).responseData { (resp) in
          
            self.tableV.mj_header.endRefreshing()
            self.tableV.mj_footer.endRefreshing()
            SVProgressHUD.dismiss()
            
            switch resp.result{
            case .success(let data):
                
                if(self.page == 1){
                    self.dataArr.removeAll()
                }
                let json = JSON(data)
                
                if let arr = json["results"].array{
                    self.dataArr.append(contentsOf: arr)
                }
        
                self.tableV.reloadData()
                self.page += 1
                
                break
            case . failure(let error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                break
            }
        }
        
        
    }
    
    
    
    
}
