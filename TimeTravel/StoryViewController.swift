//
//  StoryViewController.swift
//  TimeTravel
//
//  Created by Karen on 2017/3/19.
//  Copyright © 2017年 TimeTravel. All rights reserved.
//

import UIKit
import AVFoundation

class StoryViewController: UIViewController {
    
    @IBOutlet weak var btnSkip: UIButton!
    var Player : AVPlayer!
    var PlayerLayer: AVPlayerLayer!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let  URL = Bundle.main.url(forResource: "video", withExtension: "mp4")
        
        Player = AVPlayer.init(url: URL!)
        
        PlayerLayer = AVPlayerLayer(player: Player)
        PlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        PlayerLayer.frame = view.layer.frame
        
        Player.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        
        Player.play()
        
        view.layer.insertSublayer(PlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemReachEnd(notification:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:Player.currentItem)
    }
    
    func playerItemReachEnd(notification: NSNotification) {
        Player.seek(to: kCMTimeZero)
    }
    
    
    @IBAction func btnSkip_Click(_ sender: Any) {
        Player.pause()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
