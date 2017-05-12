//
//  pointFactory.swift
//  TimeTravel
//
//  Created by CR1-01 on 2017/4/11.
//  Copyright © 2017年 TimeTravel. All rights reserved.
//

import UIKit
import CoreLocation
public class pointFactory: NSObject {
    
    var point: Array<pointManager> = Array()
    
    var supplystation_id: Int!
    var supplystation_name: String!
    var supplystation_longitude: Double!
    var supplystation_latitude: Double!
    var coin: Int!
    
    override init() {
        super.init()
        self.JsonParse(strURL: "http://tomcattimetravel.azurewebsites.net/jspProject/timeTravel/webAPI/supplystationWebAPI.jsp")
    
    }
    
    func location(id: Int, title: String , imagename: String,
                  longtia: Double , lati: Double, coin: Int) -> pointManager{
        let point1 = pointManager()
        point1.id = id
        point1.title = title
        point1.imagename = imagename
        point1.longita = longtia
        point1.lati = lati
        point1.coin = coin
        point1.pointChecked = 1
        return point1
    }
    
    func getPoincCheckedById(id : Int) -> Int {
        
        let pm1: pointManager = pointManager()
        for pm: pointManager in point{
            if (pm.id == id){
                return pm.pointChecked
            }
        }
        return pm1.pointChecked
    }
    
    func getAllPointArray() -> Array<pointManager> {
        
        return point
    }
    
    func getById(id: Int) -> pointManager{
        let pm1: pointManager = pointManager()
        for pm: pointManager in point{
            if (pm.id == id){
                return pm
            }
        }
        return pm1
    }
    
    func getBtnTagByName(name :String) -> Int{
        
        let pm1: pointManager = pointManager()
        for pm: pointManager in point{
            if (pm.title == name){
                return pm.id
            }
        }
        return pm1.id
    }
    
    
    func getCoin(tag :Int) -> Int {
        let pm1: pointManager = pointManager()
        for pm: pointManager in point{
            if (pm.id == tag){
                return pm.coin
            }
        }
        return pm1.coin
        
    }
    
    func getlongtia(tag :Int) -> Double {
        let pm1: pointManager = pointManager()
        for pm: pointManager in point{
            if (pm.id == tag){
                return pm.longita
            }
        }
        return pm1.longita

    }
    
    func getlati(tag :Int) -> Double {
        let pm1: pointManager = pointManager()
        for pm: pointManager in point{
            if (pm.id == tag){
                return pm.lati
            }
        }
        return pm1.lati

    }
    
    func ConvertDegreeToRadians(_ degrees: Double ) -> Double
    {
        return (Double.pi / 180) * degrees
    }
    
    func GetDistance(pointAlongtia: Double, pointAlati: Double,pointBlongtia: Double, pointBlati: Double ) -> Double
    {
        
        let EARTH_RADIUS:Double = 6378.137;
        let radlng1:Double = pointAlongtia * Double.pi / 180.0;
        let radlng2:Double = pointBlongtia * Double.pi / 180.0;
        
        let a:Double = radlng1 - radlng2;
        let b:Double = (pointAlati - pointBlati) * Double.pi / 180;
        var s:Double = 2 * asin(sqrt(pow(sin(a/2), 2) + cos(radlng1) * cos(radlng2) * pow(sin(b/2), 2)));
        
        s = s * EARTH_RADIUS;
        s = (round(s * 10000) / 10000);
        return s;
    }
    
    func JsonParse( strURL: String) {
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
        

        //var supplystation_id: Int!
        //var supplystation_name: String!
        //var supplystation_longitude: Double!
        //var supplystation_latitude: Double!
        
        for resultsDict: [String: String] in myResults {
            
            for myKey: String in resultsDict.keys {
                if myKey == "supplystation_id" {
                    supplystation_id = Int(resultsDict[myKey]!)
                }
                if myKey == "supplystation_name"{
                    supplystation_name = resultsDict[myKey]!
                }
                if myKey == "supplystation_longitude"{
                    supplystation_longitude = Double(resultsDict[myKey]!)
                }
                if myKey == "supplystation_latitude"{
                    supplystation_latitude = Double(resultsDict[myKey]!)
                }
                if myKey == "coin" {
                    coin = Int(resultsDict[myKey]!)
                }
            }
            point.append(location(id: supplystation_id, title: supplystation_name, imagename: "scrap.png", longtia: supplystation_longitude, lati:supplystation_latitude, coin: coin ))
        }
        
    }
    
}
