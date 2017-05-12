//
//  LoginViewController.swift
//  TimeTravel
//
//  Created by s17 on 2017/4/20.
//  Copyright © 2017年 TimeTravel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtUserEmail: UITextField!
    @IBOutlet weak var txtUserPassword: UITextField!
    
    let loginJson : LoginJsonParse = LoginJsonParse()
    let myUserPref: UserDefaults = UserDefaults.standard
    
    
    @IBAction func btnLogin_Click(_ sender: Any) {
        
        if(txtUserEmail.text != "" && txtUserPassword.text != ""){
        self.loginJson.JsonParse(strURL: "http://tomcattimetravel.azurewebsites.net/jspProject/timeTravel/webAPI/memberWebAPI.jsp?", userEmail: txtUserEmail.text!, userPwd: txtUserPassword.text!)         
            
            perform(#selector(self.selector), with: nil, afterDelay: 1)
            //登入成功跳轉
            
        } else {
            let alertController = UIAlertController(title: "錯誤", message: "請輸入帳號密碼", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                print("OK1")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }

    }
    
    @IBAction func btnBack_Click(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func selector(){
        
        if ( myUserPref.string(forKey: Dictionary.登入ID) != nil) {
            print("1" + myUserPref.string(forKey: Dictionary.登入ID)!)
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        else {
            let alertController = UIAlertController(title: "錯誤", message: "帳號密碼錯誤", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                print("OK2")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    
    }


}
