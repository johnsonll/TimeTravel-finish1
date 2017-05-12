//
//  JsonParse.swift
//  TimeTravel
//
//  Created by s17 on 2017/4/14.
//  Copyright © 2017年 TimeTravel. All rights reserved.
//

import UIKit

class JsonParse: NSObject {

    func parse( strURL: String) -> [[String:String]] {
        let strEscString = strURL.addingPercentEncoding(withAllowedCharacters:
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
                    let results: [[String: String]] = try JSONSerialization.jsonObject(
                        with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                        as! [[String: String]]
                    
                    
                    //                    for resultDict: [String: String] in results {
                    //                        for myKey: String in resultDict.keys {
                    //                            print("key:\(myKey), value:\(resultDict[myKey]!)")
                    //                        }
                    //                        print("---------------------------------")
                    //                    }
                    
                    // waitUntilDone: true 等到這件事情做完再往下
                    
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
    
    func showDataUI(_ myResults: [[String:String]]) {
        
        var i = 0
        
        for resultsDict: [String: String] in myResults {
            
            if i > 15 { break }
            
            var strLabel: String = ""
            var strImageURL: String = ""
            
            for myKey: String in resultsDict.keys {
                
                if myKey == "Picture1" {
                    strImageURL = resultsDict[myKey]!
                }
                
                print("key:\(myKey) value:\(resultsDict[myKey]!)")
                strLabel += "key:\(myKey) value:\(resultsDict[myKey]!)\n"
            }
        
            i += 1
        }
        
        self.myScrollView.contentSize = CGSize(
            width: Double(self.myScrollView.contentSize.width),
            height: Double(i*92))
    }

}
