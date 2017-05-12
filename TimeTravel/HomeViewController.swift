//
//  HomeViewController.swift
//  TimeTravel
//
//  Created by Karen on 2017/3/19.
//  Copyright © 2017年 TimeTravel. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController , UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var btn旅遊: UIButton!
    @IBOutlet weak var btn造型: UIButton!
    @IBOutlet weak var btn對話: UIButton!
    @IBOutlet weak var btn商店: UIButton!
    
    var storyImageView = UIImageView(frame: CGRect(x:0, y:0, width:375, height:667))
    var story7ImageView = UIImageView(frame: CGRect(x:0, y:0, width:375, height:667))
    var bodyImageView = UIImageView(frame: CGRect(x:-4, y:255, width:388, height:357))
    var emojiImageView = UIImageView(frame: CGRect(x: -4, y: 255, width: 388, height: 357))
    var faceImageView = UIImageView(frame: CGRect(x: -4, y: 255, width: 388, height: 357))
    var storyImage: UIImage!
    var story7Image: UIImage!
    var faceImage: UIImage!
    var bodyImage: UIImage!
    var emojiImage: UIImage!
    var count換圖: Int = 0
    
    var imageTag: Int! = 0
    var count: Int = 1
    static var 記憶碎片: Int!
    var btnSound : SoundManager = SoundManager()
    
    @IBOutlet weak var lbl記憶碎片: UILabel!
    @IBOutlet weak var imgTalk: UIImageView!
    @IBOutlet weak var lblTalk: UILabel!
    let myUserPref: UserDefaults = UserDefaults.standard
    
    static var pf: pointFactory!
    static var itemFac: itemFactory!
    static var shopFac: shopFactory!
    
    @IBAction func btnSetting_Click(_ sender: Any) {
        
        btnSound.playBackground(music: "ButtonPressed")
    }
    
    @IBAction func btnTalk_Click(_ sender: Any) {
        
        btnSound.playBackground(music: "ButtonPressed")
        var index : UInt32 = 0
        var talkIndex : String = ""
        
        if(Int(lbl記憶碎片.text!)! < 5){
            index = arc4random_uniform(UInt32(ConversationClass.talk0.count))
            talkIndex = ConversationClass.talk0[Int(index)]
        } else if Int(lbl記憶碎片.text!)! >= 5 && Int(lbl記憶碎片.text!)! < 10 {
            index = arc4random_uniform(UInt32(ConversationClass.talk1.count))
            talkIndex = ConversationClass.talk1[Int(index)]
        } else if Int(lbl記憶碎片.text!)! >= 10 && Int(lbl記憶碎片.text!)! < 15 {
            index = arc4random_uniform(UInt32(ConversationClass.talk2.count))
            talkIndex = ConversationClass.talk2[Int(index)]
        } else if Int(lbl記憶碎片.text!)! >= 15 && Int(lbl記憶碎片.text!)! < 20 {
            index = arc4random_uniform(UInt32(ConversationClass.talk3.count))
            talkIndex = ConversationClass.talk3[Int(index)]
        } else if Int(lbl記憶碎片.text!)! >= 20 && Int(lbl記憶碎片.text!)! < 25 {
            index = arc4random_uniform(UInt32(ConversationClass.talk4.count))
            talkIndex = ConversationClass.talk4[Int(index)]
        } else if Int(lbl記憶碎片.text!)! >= 25 && Int(lbl記憶碎片.text!)! < 30 {
            index = arc4random_uniform(UInt32(ConversationClass.talk5.count))
            talkIndex = ConversationClass.talk5[Int(index)]
        } else if Int(lbl記憶碎片.text!)! >= 30 && Int(lbl記憶碎片.text!)! < 35 {
            index = arc4random_uniform(UInt32(ConversationClass.talk6.count))
            talkIndex = ConversationClass.talk6[Int(index)]
        } else if Int(lbl記憶碎片.text!)! >= 35 {
            index = arc4random_uniform(UInt32(ConversationClass.talk7.count))
            talkIndex = ConversationClass.talk7[Int(index)]
        }
        
        imgTalk.isHidden = false
        lblTalk.isHidden = false
        
        self.lblTalk.text = talkIndex
        
        if( index == 0 ){
            emojiImage = UIImage(named: "a")
            emojiImageView.image = emojiImage
        } else if index == 1 {
            emojiImage = UIImage(named: "b")
            emojiImageView.image = emojiImage
        } else if index == 2 {
            emojiImage = UIImage(named: "c")
            emojiImageView.image = emojiImage
        } else if index == 3 {
            emojiImage = UIImage(named: "d")
            emojiImageView.image = emojiImage
        } else if index == 4 {
            emojiImage = UIImage(named: "e")
            emojiImageView.image = emojiImage
        } else if index == 5 {
            emojiImage = UIImage(named: "f")
            emojiImageView.image = emojiImage
        } else if index == 6 {
            emojiImage = UIImage(named: "g")
            emojiImageView.image = emojiImage
        } else if index == 7 {
            emojiImage = UIImage(named: "h")
            emojiImageView.image = emojiImage
        } else if index == 8 {
            emojiImage = UIImage(named: "i")
            emojiImageView.image = emojiImage
        }
        
        /*
        let task1 = DispatchGroup()
        task1.enter()
        DispatchQueue.global().async {
            self.count = 1
            for _ in 1...4 {
                
                Thread.sleep(forTimeInterval: 0.5)
                self.count += 1
            }
            task1.leave()
        }
        
        task1.notify(queue: DispatchQueue.main){
            print(self.count)
            if self.count == 5{
                self.過幾秒隱藏()
                self.view.addGestureRecognizer(self.tapSingle)
            }
        }
        */
    }
    
    
   
    
    func 過幾秒隱藏(){

        self.imgTalk.isHidden = true
        self.lblTalk.isHidden = true
        self.emojiImage = UIImage(named: "h")
        self.emojiImageView.image = self.emojiImage
        
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
                
                if myKey == "timeshard_num" {
                    myUserPref.set(resultsDict[myKey]!, forKey: Dictionary.記憶碎片Key)
                    print(String(self.myUserPref.integer(forKey: Dictionary.記憶碎片Key)))
                }
                
            }
            
        }
        
    }
    @IBAction func btn記憶碎片5(_ sender: Any) {
        print("點")
        let 碎片: Int = self.myUserPref.integer(forKey: Dictionary.記憶碎片Key)
        myUserPref.set(碎片 + 5, forKey: Dictionary.記憶碎片Key)
        lbl記憶碎片.text = self.myUserPref.string(forKey: Dictionary.記憶碎片Key)
        記憶碎片觸發劇情()
        
    }
    
    func 延遲記憶碎片執行(){
        lbl記憶碎片.isHidden = false
        lbl記憶碎片.text = String(self.myUserPref.integer(forKey: Dictionary.記憶碎片Key))
        //self.myUserPref.set(lbl記憶碎片.text, forKey: Dictionary.記憶碎片Key)
    }
    
    func 記憶碎片觸發劇情(){
        
        let Int記憶碎片 = Int(self.lbl記憶碎片.text!)
        let tapSingle=UITapGestureRecognizer(target:self,action:#selector(劇情圖片消失))
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1

        let tapSingle1=UITapGestureRecognizer(target:self,action:#selector(story7換圖))
        tapSingle1.numberOfTapsRequired = 1
        tapSingle1.numberOfTouchesRequired = 1
       
        
        
        if( Int記憶碎片 == 5){
            if( myUserPref.string(forKey: Dictionary.已顯示過劇情1) == nil){
                storyImage = UIImage(named: "story1")
                myUserPref.set(1, forKey: Dictionary.已顯示過劇情1)
                storyImageView.isHidden = false
                按鈕隱藏()
                storyImageView.image = storyImage
                storyImageView.contentMode = .scaleAspectFill
                view.addSubview(storyImageView)
            }
        } else if ( Int記憶碎片! == 10) {
            if( myUserPref.string(forKey: Dictionary.已顯示過劇情2) == nil){
                storyImage = UIImage(named: "story2")
                myUserPref.set(1, forKey: Dictionary.已顯示過劇情2)
                storyImageView.isHidden = false
                按鈕隱藏()
                storyImageView.image = storyImage
                storyImageView.contentMode = .scaleAspectFill
                view.addSubview(storyImageView)
            }
        } else if ( Int記憶碎片! == 15) {
            if( myUserPref.string(forKey: Dictionary.已顯示過劇情3) == nil){
                storyImage = UIImage(named: "story3")
                myUserPref.set(1, forKey: Dictionary.已顯示過劇情3)
                storyImageView.isHidden = false
                按鈕隱藏()
                storyImageView.image = storyImage
                storyImageView.contentMode = .scaleAspectFill
                view.addSubview(storyImageView)
            }
        } else if ( Int記憶碎片! == 20) {
            if( myUserPref.string(forKey: Dictionary.已顯示過劇情4) == nil){
                storyImage = UIImage(named: "story4")
                myUserPref.set(1, forKey: Dictionary.已顯示過劇情4)
                storyImageView.isHidden = false
                按鈕隱藏()
                storyImageView.image = storyImage
                storyImageView.contentMode = .scaleAspectFill
                view.addSubview(storyImageView)
            }
        } else if ( Int記憶碎片! == 25) {
            if( myUserPref.string(forKey: Dictionary.已顯示過劇情5) == nil){
                storyImage = UIImage(named: "story5")
                myUserPref.set(1, forKey: Dictionary.已顯示過劇情5)
                storyImageView.isHidden = false
                按鈕隱藏()
                storyImageView.image = storyImage
                storyImageView.contentMode = .scaleAspectFill
                view.addSubview(storyImageView)
            }
        } else if ( Int記憶碎片! == 30) {
            if( myUserPref.string(forKey: Dictionary.已顯示過劇情6) == nil){
                storyImage = UIImage(named: "story6")
                myUserPref.set(1, forKey: Dictionary.已顯示過劇情6)
                storyImageView.isHidden = false
                按鈕隱藏()
                storyImageView.image = storyImage
                storyImageView.contentMode = .scaleAspectFill
                view.addSubview(storyImageView)
            }
        }
        
        if ( Int記憶碎片! == 35) {
            story7Image = UIImage(named: "story7-1")
            if( myUserPref.string(forKey: Dictionary.已顯示過劇情7) == nil){
                myUserPref.set(1, forKey: Dictionary.已顯示過劇情7)
                story7ImageView.isHidden = false
                按鈕隱藏()
                story7ImageView.image = story7Image
                story7ImageView.contentMode = .scaleAspectFill
                view.addSubview(story7ImageView)
            }
            
        }
        storyImageView.isUserInteractionEnabled = true
        story7ImageView.isUserInteractionEnabled = true
        
        if(storyImageView.isHidden == false){
            self.storyImageView.addGestureRecognizer(tapSingle)
        } else if(story7ImageView.isHidden == false){
            print("test!!!!!!")
            self.story7ImageView.addGestureRecognizer(tapSingle1)
        }
        
    }
    
    func 按鈕隱藏(){
        btn旅遊.isHidden = true
        btn造型.isHidden = true
        btn對話.isHidden = true
        btn商店.isHidden = true
    }
    
    func 按鈕顯示(){
        btn旅遊.isHidden = false
        btn造型.isHidden = false
        btn對話.isHidden = false
        btn商店.isHidden = false
    }
    
    func 劇情圖片消失(){
        storyImageView.isHidden = true
        按鈕顯示()
    }
    
    func story7換圖(){
        count換圖 += 1
        print("\(count換圖)")
        if(count換圖 == 1){
            story7Image = UIImage(named: "story7-2")
            story7ImageView.image = story7Image
            view.addSubview(story7ImageView)
            
        } else if (count換圖 == 2){
            story7Image = UIImage(named: "family")
            story7ImageView.image = story7Image
            view.addSubview(story7ImageView)
        } else {
            story7ImageView.isHidden = true
            按鈕顯示()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        HomeViewController.pf = pointFactory()
        HomeViewController.itemFac = itemFactory()
        HomeViewController.shopFac = shopFactory()
        
        lblTalk.text = ""
        imgTalk.isHidden = true
        
        ViewController.sound.playBackground(music: "rains")
        self.JsonParse(strURL: "http://tomcattimetravel.azurewebsites.net/jspProject/timeTravel/webAPI/gamescheduleWebAPI.jsp?member_id=" + myUserPref.string(forKey: Dictionary.登入ID)!)
        lbl記憶碎片.isHidden = true
        perform(#selector(延遲記憶碎片執行), with: nil, afterDelay: 0.5)
        perform(#selector(記憶碎片觸發劇情), with: nil, afterDelay: 1)
        
        bodyImageView.tag = imageTag
        
        emojiImageView.image = emojiImage
        emojiImageView.contentMode = .scaleAspectFit
        
        faceImage = UIImage(named: "face")
        faceImageView.image = faceImage
        faceImageView.contentMode = .scaleAspectFit
        
        if self.myUserPref.string(forKey: Dictionary.衣服ID) != nil{
            bodyImage = UIImage(named: self.myUserPref.string(forKey: Dictionary.衣服ID)!)
        }else{
            bodyImage = UIImage(named: String(imageTag))
        }
        
        bodyImageView.image = bodyImage
        bodyImageView.contentMode = .scaleAspectFit
        
        
        view.addSubview(bodyImageView)
        view.addSubview(faceImageView)
        view.addSubview(emojiImageView)
        emojiImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.singleTap))
        emojiImageView.addGestureRecognizer(gesture)
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emojiImage = UIImage(named: "h")
        myUserPref.set(1, forKey: Dictionary.已登入過)
        
        imgTalk.isHidden = true
        lblTalk.isHidden = true
        
    }
    
    func singleTap(){
        過幾秒隱藏()
        
    }
    
    @IBAction func goToFittingRoom(_ sender: Any) {
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
    
    @IBAction func btnTravel_Click(_ sender: Any) {
        btnSound.playBackground(music: "ButtonPressed")
    }
    
    @IBAction func btnFittingRoom_Click(_ sender: Any) {
        btnSound.playBackground(music: "ButtonPressed")
    }
    
    @IBAction func btnShop_Click(_ sender: Any) {
        btnSound.playBackground(music: "ButtonPressed")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    
}
