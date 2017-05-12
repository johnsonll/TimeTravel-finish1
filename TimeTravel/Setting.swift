//
//  Setting.swift
//  TimeTravel
//
//  Created by Karen on 2017/3/19.
//  Copyright © 2017年 TimeTravel. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class Setting: UIViewController,FBSDKLoginButtonDelegate {

    var sound: SoundManager = SoundManager()
    
    @IBOutlet weak var switchBGM: UISwitch!
    @IBOutlet weak var faceBookLogIn: FBSDKLoginButton!
    @IBOutlet weak var popupView: UIView!
    
    @IBAction func bgm_ValueChanged(_ sender: Any) {
       /*
        if (switchBGM.isOn == true)
        {
            sound.playBackground(music: "rains")
            
        } else{
            
            sound.stopBackground()
            
        }
        */
 
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
     
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        
        
        
        if (FBSDKAccessToken.current() != nil)
        {
            
            print("User Logged In")
            
        }
        else
        {
            let loginButton : FBSDKLoginButton = FBSDKLoginButton()
            
            loginButton.center = self.view.center
            
            loginButton.readPermissions = ["public_profile", "email"]
            
            loginButton.delegate = self
            
            self.view.addSubview(loginButton)
        }
        
    }

    @IBAction func btnSettingClose_Click(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil
        {
            
            print(error)
            
        }
        else if result.isCancelled {
            
            print("User cancelled login")
            
        }
        else {
            
            
            if result.grantedPermissions.contains("email")
            {
                
                if let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"]) {
                    
                    graphRequest.start(completionHandler: { (connection, result, error) in
                        
                        if error != nil {
                            
                            print(error)
                            
                        } else {
                            
                            if let userDetails = result as? [String: String] {
                                
                                print(userDetails["email"])
                                
                            }
                            
                        }
                        
                        
                    })
                    
                    
                }
                
                
                
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        print("Logged out")
        
    }
    

}
