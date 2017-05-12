//
//  TravleViewController.swift
//  TimeTravel
//
//  Created by s17 on 2017/3/20.
//  Copyright © 2017年 TimeTravel. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation

class TravelViewController: UIViewController , MKMapViewDelegate ,CLLocationManagerDelegate{
    
    @IBOutlet weak var map: MKMapView!
   
    @IBOutlet weak var btnBack: UIButton!
    var locationManager: CLLocationManager = CLLocationManager() //座標管理元件
    
    var checkdById: Array<Int> = Array<Int>()
    
    var myLocation: CLLocation!
    var 記憶碎片 : Int!
    let myUserPref: UserDefaults = UserDefaults.standard
    
    class CustomPointAnnotation: MKPointAnnotation {
        var imageName: String!
    }

    
    @IBAction func btnback_click(_ sender: Any) {
        ViewController.sound.playBackground(music: "ButtonPressed")
    }
    
    @IBAction func btnBack_Click(_ sender: Any) {
        
        self.dismiss(animated: false)
    }
    
    func btnBackDelay(){
        btnBack.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        perform(#selector(btnBackDelay), with: nil, afterDelay: 5)
        
        if (myUserPref.array(forKey: Dictionary.已取得記憶碎片補給站ID) != nil){
            checkdById = myUserPref.array(forKey: Dictionary.已取得記憶碎片補給站ID) as! Array<Int>
        }
        
        //if(self.myUserPref.integer(forKey: Dictionary.記憶碎片Key) != nil){
        記憶碎片 = self.myUserPref.integer(forKey: Dictionary.記憶碎片Key)
        //}
        //locationManager = CLLocationManager();
        ViewController.sound.playBackground(music: "popin")
        self.map.delegate = self
        self.map.showsUserLocation = true
        self.map.userLocation.title = "我的位置"
        map.userTrackingMode = .followWithHeading
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()//詢問使用者是否同意給APP定位功能
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation() //開始接收目前位置資訊
        locationManager.distanceFilter = CLLocationDistance(10)
        
        perform(#selector(加入地標), with: nil, afterDelay: 2)
    
    }
    
    func 加入地標 (){
        
        var arbokPin = CustomPointAnnotation()
        var arbokCoordinates: CLLocationCoordinate2D!
        let count: Int = HomeViewController.pf.getAllPointArray().count
        
        for i in 1...count {
            arbokPin = CustomPointAnnotation()
            arbokCoordinates = CLLocationCoordinate2DMake(HomeViewController.pf.getById(id: i).lati, HomeViewController.pf.getById(id: i).longita)
            arbokPin.coordinate = arbokCoordinates
            arbokPin.title = (HomeViewController.pf.getById(id: i)).title
            arbokPin.imageName = (HomeViewController.pf.getById(id: i)).imagename
            map.addAnnotation(arbokPin)
        }
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if !(annotation is MKPointAnnotation) {
            print("NOT REGISTERED AS MKPOINTANNOTATION")
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "myAnnot")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "myAnnot")
            annotationView!.canShowCallout = true
        }
            
        else {
            annotationView!.annotation = annotation
        }
        
            
        let cpa = annotation as! CustomPointAnnotation
        let	button1 = UIButton()
        button1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let image = UIImage(named: "scrap.png")        
        button1.setImage(image, for: .normal)
        button1.tag = HomeViewController.pf.getBtnTagByName(name: annotation.title!!)
        annotationView?.tag = HomeViewController.pf.getBtnTagByName(name: annotation.title!!)
        
        //點選過補給站消失
        if(checkdById.index(of: (annotationView?.tag)!) == nil){
            annotationView!.image = UIImage(named: cpa.imageName)
        }
        annotationView?.rightCalloutAccessoryView = button1
        
        
        if(HomeViewController.pf.getPoincCheckedById(id: HomeViewController.pf.getBtnTagByName(name: annotation.title!!) ) == 1 ){
            
            return annotationView
            
        }
        return nil
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        
        if( HomeViewController.pf.GetDistance(pointAlongtia: myLocation.coordinate.longitude, pointAlati: myLocation.coordinate.latitude, pointBlongtia: HomeViewController.pf.getlongtia(tag: control.tag), pointBlati: HomeViewController.pf.getlati(tag: control.tag)) < 10 )
        {
         
            let alertController = UIAlertController(title: "YA", message: "您獲取了記憶碎片", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            記憶碎片 = 記憶碎片 + 1
            self.myUserPref.set(記憶碎片, forKey: Dictionary.記憶碎片Key)
            
            let coin = HomeViewController.pf.getCoin(tag: control.tag)
            var 總金幣: Int!
            總金幣 = self.myUserPref.integer(forKey: Dictionary.金幣) + coin
            self.myUserPref.set(總金幣 , forKey: Dictionary.金幣)

            
            checkdById.append(control.tag)
            self.myUserPref.set(checkdById , forKey: Dictionary.已取得記憶碎片補給站ID)
            
            self.JsonParse(strURL: "http://tomcattimetravel.azurewebsites.net/jspProject/timeTravel/webAPI/gamescheduleWebAPI.jsp?member_id="+self.myUserPref.string(forKey: Dictionary.登入ID)!+"&timeshard_num="+self.myUserPref.string(forKey: Dictionary.記憶碎片Key)!)
            
            view.isHidden = true
            
        } else{
            
            
            let alertController = UIAlertController(title: "嗚嗚", message: "您的距離太遠了", preferredStyle: UIAlertControllerStyle.alert)
            
            
            let okAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
               
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
      
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = locations.last!
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myLocation.coordinate, 300, 300)
        self.map.setRegion(region, animated: false)

    }
    
    
    
    func JsonParse(strURL: String) {
        
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
        
        for resultsDict: [String: AnyObject] in myResults {
            
            for myKey: String in resultsDict.keys {
                
                if myKey == "timeshard_num" {
                    myUserPref.set(resultsDict[myKey]!, forKey: Dictionary.記憶碎片Key)
                }
                
            }
            
        }
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        locationManager.stopUpdatingLocation(); //背景執行時關閉定位功能
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        ViewController.sound.stopBackground()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
 
}

