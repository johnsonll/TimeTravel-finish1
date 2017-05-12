//
//  LoginJsonParse.swift
//  TimeTravel
//
//  Created by 楊宗翰 on 2017/4/21.
//  Copyright © 2017年 TimeTravel. All rights reserved.
//

import UIKit

class LoginJsonParse: NSObject {
    
    var member_id: String!
    let userPref: UserDefaults = UserDefaults.standard
    func JsonParse(strURL: String , userEmail: String , userPwd: String) {
        
        
        let url = strURL + "emailLogin=" + userEmail + "&passwordLogin=" + userPwd
        let strEscString = url.addingPercentEncoding(withAllowedCharacters:
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
                    print("test \(results.count)")
                    
                    
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
        
        for resultsDict: [String: AnyObject] in myResults {
            
            for myKey: String in resultsDict.keys {
                if myKey == "member_id" {
                    userPref.set(resultsDict[myKey]!, forKey: Dictionary.登入ID)
                }
                
            }
            
        }
        
    }
    
}
