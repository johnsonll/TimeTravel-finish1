//
//  SoundManager.swift
//  TimeTravel
//
//  Created by Karen on 2017/3/28.
//  Copyright © 2017年 TimeTravel. All rights reserved.
//

import UIKit
import AVFoundation

class SoundManager: NSObject {
    
    var audioPlayer = AVAudioPlayer()
    
    func playBackground( music: String ){
        
        do
        {
            audioPlayer = try AVAudioPlayer (contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: music, ofType: "mp3")!))
            
            if(music == "rains"){
                 audioPlayer.numberOfLoops = -1
            }
            
            audioPlayer.prepareToPlay()
            
            let audioSession = AVAudioSession.sharedInstance()
            
            do{
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            }
            catch
            {
                
            }
        }
            
        catch
        {
            print(error)
        }
        
        audioPlayer.play()
    }
    
    
    
    func stopBackground(){
        
        if audioPlayer.isPlaying{
            audioPlayer.stop()
            //audioPlayer.currentTime = 0.0
        } else {
            audioPlayer.play()
        }
    }
    
}
