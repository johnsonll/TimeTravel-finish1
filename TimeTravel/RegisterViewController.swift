//
//  RegisterViewController.swift
//  TimeTravel
//
//  Created by s17 on 2017/4/20.
//  Copyright © 2017年 TimeTravel. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController ,UITextFieldDelegate{

    
    @IBOutlet weak var txtuserName: UITextField!
    @IBOutlet weak var txtuserPhone: UITextField!
    @IBOutlet weak var txtuserPasswordCheck: UITextField!
    @IBOutlet weak var txtuserPassword: UITextField!
    @IBOutlet weak var txtuserEmail: UITextField!
    let homeVC : HomeViewController = HomeViewController()
    let myUserPref: UserDefaults = UserDefaults.standard
    
    var loginJson: LoginJsonParse = LoginJsonParse()
    
    @IBAction func btnRegister_Click(_ sender: Any) {
        
        let userName: String = txtuserName.text!
        let userEmail: String = txtuserEmail.text!
        let userPassword: String = txtuserPassword.text!
        let userPasswordCheck: String = txtuserPasswordCheck.text!
        let userPhone: String = txtuserPhone.text!
        
        if userName != "" || userEmail != "" || txtuserPhone.text != "" || userPassword != "" || userPasswordCheck != "" || userPhone != ""{
           
            if userPassword == userPasswordCheck {
                //全欄位皆有值，並且密碼欄位與密碼確認欄位相符
                self.JsonParse(strURL: "http://tomcattimetravel.azurewebsites.net/jspProject/timeTravel/webAPI/memberWebAPI.jsp?userEmail="+userEmail+"&userPwd="+userPassword+"&userName="+userName+"&userPhone="+userPhone)
                
                let alertController = UIAlertController(title: "YA", message: "註冊成功", preferredStyle: UIAlertControllerStyle.alert)
                
                
                let okAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                    
                    //註冊跟登入後跳轉
                    self.performSegue(withIdentifier: "registerLogin", sender: nil)
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true) {
                    self.loginJson.JsonParse(strURL: "http://tomcattimetravel.azurewebsites.net/jspProject/timeTravel/webAPI/memberWebAPI.jsp?", userEmail: userEmail, userPwd: userPassword)
                }
                
                
            } else{
                //密碼欄位與密碼確認欄位不符
                let alertController = UIAlertController(title: "錯誤", message: "密碼欄位與密碼確認欄位不符", preferredStyle: UIAlertControllerStyle.alert)
                
                
                let okAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }else{
            //欄位有空值
            let alertController = UIAlertController(title: "錯誤", message: "請輸入資料", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                print("OK")
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)

        }
        
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        txtuserName.resignFirstResponder()
        
        return true

    }
  

    @IBAction func btnLogin_Click(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtuserEmail.keyboardType = UIKeyboardType.emailAddress
        txtuserPhone.keyboardType = UIKeyboardType.phonePad
        txtuserName.becomeFirstResponder()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }
    
}
