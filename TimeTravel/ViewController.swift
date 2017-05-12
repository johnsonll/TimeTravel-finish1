//
//  ViewController.swift
//  TimeTravel
//
//  Created by Karen on 2017/3/16.
//  Copyright © 2017年 TimeTravel. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    let storyVC: StoryViewController = StoryViewController()
    let loginVC: LoginViewController = LoginViewController()
    static var sound: SoundManager = SoundManager()
    let myUserPref: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 單指輕點
         let tapSingle=UITapGestureRecognizer(target:self,action:#selector(singleTap))
        // 點幾下才觸發 設置 2 時 則是要點兩下才會觸發 依此類推
        tapSingle.numberOfTapsRequired = 1
        // 幾根指頭觸發
        tapSingle.numberOfTouchesRequired = 1
        
        self.view.addGestureRecognizer(tapSingle)
    
    }
    
    // 觸發單指輕點兩下手勢後 執行的動作
    func singleTap(){
        if (myUserPref.string(forKey: Dictionary.登入ID) != nil) {
            myUserPref.integer(forKey: Dictionary.金幣)
            //已登入
            if(myUserPref.integer(forKey: Dictionary.已登入過) == 1){
                self.performSegue(withIdentifier: "已登入過", sender: nil)
            } else {
                storyVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                self.performSegue(withIdentifier: "isLogin", sender: nil)
            }
        } else {
            //未登入跳轉登入頁面
            myUserPref.set(1000, forKey: Dictionary.金幣)
            loginVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            self.performSegue(withIdentifier: "isNotLogin", sender: nil)
        }
        
        
    }
    
    
      override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

