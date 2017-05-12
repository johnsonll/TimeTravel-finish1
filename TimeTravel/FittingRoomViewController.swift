//
//  FittingRoomViewController.swift
//  TimeTravel
//
//  Created by s17 on 2017/3/20.
//  Copyright © 2017年 TimeTravel. All rights reserved.
//

import UIKit

protocol DataSentDelegate {
    func userDidClickImage(data: UIImageView)
}

class FittingRoomViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    
    var imageTag: Int!
    
    @IBOutlet weak var MyCollectionView: UICollectionView!
    let myUserPref: UserDefaults = UserDefaults.standard
    var images = HomeViewController.itemFac.getAllItemArray()
    var imageView = UIImageView(frame: CGRect(x:30, y:60, width:289, height:277))
    var emojiImageView = UIImageView(frame: CGRect(x:30, y:60, width:289, height:277))
    var faceImageView = UIImageView(frame: CGRect(x:30, y:60, width:289, height:277))
    var faceImage: UIImage!
    var emojiImage: UIImage!
    var btnSound : SoundManager = SoundManager()
  
    
    @IBAction func btnBack_TouchDown(_ sender: Any) {
        ViewController.sound.playBackground(music: "ButtonPressed")
    }
    
    @IBAction func btnBack_Click(_ sender: Any) {
      
        self.dismiss(animated: false, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewController.sound.playBackground(music: "clearsky")
        
        self.MyCollectionView.delegate = self
        self.MyCollectionView.dataSource = self
    
        //let fullScreenSize = UIScreen.main.bounds.size
        
        emojiImage = UIImage(named: "h")
        emojiImageView.image = emojiImage
        emojiImageView.contentMode = .scaleAspectFit
        
        faceImage = UIImage(named: "face")
        faceImageView.image = faceImage
        faceImageView.contentMode = .scaleAspectFit

        imageView.tag = self.myUserPref.integer(forKey: Dictionary.衣服ID)
        let image1 = UIImage(named: String(imageView.tag) )
        imageView.image = image1
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        view.addSubview(faceImageView)
        view.addSubview(emojiImageView)
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! MyCollectionViewCell
        
        cell.layer.cornerRadius = 5
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 1
        cell.myImageView.image = UIImage(named: String(images[indexPath.row].id))
        let imageView = cell.viewWithTag(87) as! UIImageView
        imageView.image = UIImage(named: "h")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    
        btnSound.playBackground(music: "ButtonPressed")
        //print("selected row is", indexPath.item )
        for i in 0...collectionView.visibleCells.count - 1 {
            collectionView.visibleCells[i].layer.borderColor = UIColor.clear.cgColor
        }
        collectionView.cellForItem(at: indexPath)?.layer.borderColor = UIColor.red.cgColor
        
        imageView.image = UIImage(named: String(images[indexPath.item].id))
        imageView.tag = images[indexPath.item].id!
        
        //self.performSegue(withIdentifier: "ChangeClothes", sender: self)
        
    }
    
    @IBAction func 換衣服按鍵音(_ sender: Any) {
        btnSound.playBackground(music: "ButtonPressed")
    }
    
    
    @IBAction func AfterChangeClothes(_ sender: Any) {
        
        
        
        let imageTag = imageView.tag

        performSegue(withIdentifier: "ChangeClothes", sender: imageTag)
        
        //performSegue(withIdentifier: "ChangeClothes", sender: imageTag)

        //_ = self.navigationController?.HomeViewController(animated: true)
    }
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "ChangeClothes" {
            if let destination = segue.destination as? HomeViewController {
                destination.imageTag = sender as? Int
                self.myUserPref.set(imageView.tag, forKey: Dictionary.衣服ID)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        ViewController.sound.stopBackground()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

}
