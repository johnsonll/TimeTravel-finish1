//
//  pointFactory.swift
//  TimeTravel
//
//  Created by CR1-01 on 2017/4/11.
//  Copyright © 2017年 TimeTravel. All rights reserved.
//

import UIKit

public class itemFactory: NSObject {
    var itemList: Array<itemManager> = Array()
    let userPref: UserDefaults = UserDefaults.standard
    var idArray: Array<Int> = Array<Int>()

    var item_id: Int!
    override init() {
        super.init()
        self.JsonParse(strURL: "http://tomcattimetravel.azurewebsites.net/jspProject/timeTravel/webAPI/characterWebAPI.jsp?member_id=", memberid: userPref.string(forKey: Dictionary.登入ID)!)
        
    }
    
    func itemAdd(id: Int) -> itemManager{
        let item: itemManager = itemManager()
        item.id = id
        return item
    }
    
    func getAllItemArray() -> Array<itemManager> {
        
        return itemList
    }
    
    func getItemIdArray() -> Array<Int> {
        return idArray
    }
    
    func JsonParse(strURL: String, memberid: String) {
        let strURL1: String = strURL + memberid
        let strEscString = strURL1.addingPercentEncoding(withAllowedCharacters:
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
                do {
                    let results: [[String: AnyObject]] = try JSONSerialization.jsonObject(
                        with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                        as! [[String: AnyObject]]
                    
                    self.performSelector(onMainThread: #selector(self.showDataUI(_:)),
                                         with: results,
                                         waitUntilDone: true)
                }
                catch {
                    print("解析錯誤\(error)")
                }
            } else {
                //失敗
                print("失敗:\(String(describing: error?.localizedDescription))")
            }
        }
        myDataTask.resume()
        
    }
    
    func showDataUI(_ myResults: [[String: AnyObject]]) {
        
        
        //var supplystation_id: Int!
        //var supplystation_name: String!
        //var supplystation_longitude: Double!
        //var supplystation_latitude: Double!
        
        for resultsDict: [String: AnyObject] in myResults {
            
            for myKey: String in resultsDict.keys {
                if myKey == "item_id" {
                    item_id = resultsDict[myKey]! as! Int
                }
            }
            itemList.append(itemAdd(id: item_id))
            idArray.append(item_id)
        }
        
    }
    
}
