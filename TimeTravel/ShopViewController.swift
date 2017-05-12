//
//  ShopViewController.swift
//  TimeTravel
//
//  Created by s17 on 2017/3/20.
//  Copyright © 2017年 TimeTravel. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var MyCollectionView: UICollectionView!
    
    
    var priceArray : Array<Int> = HomeViewController.shopFac.getPrice()
    var itemIdArray: Array<Int> = HomeViewController.itemFac.getItemIdArray()
    var count: Int!
    
    let myUserPref: UserDefaults = UserDefaults.standard
    var images = HomeViewController.shopFac.getAllShopArray()
    var 總金幣 = 100
    
    var btnSound: SoundManager = SoundManager()
    @IBOutlet weak var lblCoin: UILabel!
    
    
    func UpdateJsonParse(strURL: String,登入ID: String,stringCount: String, money: Int) {
        let strUrl1 = strURL + 登入ID+"&item_id="+stringCount+"&total="+String(money)
        let strEscString = strUrl1.addingPercentEncoding(withAllowedCharacters:
            CharacterSet.urlQueryAllowed)!
        let myURL: URL = URL(string: strEscString)!
        
        let mySeesionConfig: URLSessionConfiguration = URLSessionConfiguration.default
        let mySession: URLSession = URLSession(configuration: mySeesionConfig, delegate: nil, delegateQueue: nil)
        var myRequest: URLRequest = URLRequest(url: myURL)
        myRequest.httpMethod = "GET"
        
        
        // data : 從伺服器回傳的資料暫時存在這(緩衝區)
        // 所有從網路存取的物件都是這種形式
        let myDataTask = mySession.dataTask(with: myRequest) {
            (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error == nil {
                
                //成功
                //statusCode: HTTP伺服器回傳的狀態碼
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("StatusCode: \(statusCode)")
                print("連線成功：共下載\(data!.count) bytes") //緩衝區的count值
                //parse JSON String
                
            } else {
                //失敗
                print("失敗:\(String(describing: error?.localizedDescription))")
            }
        }
        myDataTask.resume()
        
    }
    
   
    
    @IBAction func btnBack_TouchDown(_ sender: Any) {
        ViewController.sound.playBackground(music: "ButtonPressed")
    }
    @IBAction func btnBack_Click(_ sender: Any) {
        ViewController.sound.playBackground(music: "ButtonPressed")
        self.dismiss(animated: false, completion: nil)
        
    }    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.sound.playBackground(music: "clearsky")
        
        self.MyCollectionView.delegate = self
        self.MyCollectionView.dataSource =  self
        
        
        lblCoin.text = String(myUserPref.integer(forKey: Dictionary.金幣))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! MyCollectionViewCell
        
        cell.layer.cornerRadius = 5
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 1
        cell.myShopImageView.image = UIImage(named: String(images[indexPath.row].id))
        let imageView = cell.viewWithTag(87) as! UIImageView
        imageView.image = UIImage(named: "h")
        let price = cell.viewWithTag(9487) as! UILabel
        price.text = String(HomeViewController.shopFac.getPrice()[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        btnSound.playBackground(music: "ButtonPressed")
        
        for i in 0...collectionView.visibleCells.count - 1 {
            collectionView.visibleCells[i].layer.borderColor = UIColor.clear.cgColor
        }
        collectionView.cellForItem(at: indexPath)?.layer.borderColor = UIColor.red.cgColor
        
        self.count = indexPath.row
        
    }

    @IBAction func btnBuy_Click(_ sender: Any) {
        
        if( count != nil){
        var 總金幣 = self.myUserPref.integer(forKey: Dictionary.金幣)
        let 登入ID = self.myUserPref.string(forKey: Dictionary.登入ID)
        let stringCount = String(count+1)
        
        btnSound.playBackground(music: "ButtonPressed")
        //如果沒有這件衣服才能購買
        if(itemIdArray.index(of: count+1) == nil){
        
            if( count != nil ){
            
                //如果總金幣小於衣服價錢
                if( 總金幣 < priceArray[count] ){
                    
                    let alertController = UIAlertController(title: "嗚嗚", message: "你的金幣不夠，趕快去旅遊賺金幣～", preferredStyle: UIAlertControllerStyle.alert)
                    
                    
                    let okAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    }
                    
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "YA", message: "確定要購買嗎？", preferredStyle: UIAlertControllerStyle.alert)
                    
                    
                    let okAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        //買一件衣服
                        self.UpdateJsonParse(strURL: "http://tomcattimetravel.azurewebsites.net/jspProject/timeTravel/webAPI/shoppingrecordWebAPI.jsp?member_id=",登入ID: 登入ID!,stringCount: stringCount,money: self.priceArray[self.count])
                        
                        
                        總金幣 = 總金幣 - self.priceArray[self.count]
                        self.lblCoin.text = String(總金幣)
                        self.myUserPref.set(總金幣, forKey: Dictionary.金幣)
                    }
                    
                    let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                        
                    }

                    alertController.addAction(okAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)

                    }
                }
                
            } else {
                
                let alertController = UIAlertController(title: "哇呼", message: "你已經有這件衣服了～", preferredStyle: UIAlertControllerStyle.alert)
                
                
                let okAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            }           
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ViewController.sound.stopBackground()
    }
}
