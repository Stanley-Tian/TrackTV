//
//  AddTVViewController.swift
//  TrackTV
//
//  Created by 史丹利复合田 on 2016/10/18.
//  Copyright © 2016年 史丹利复合田. All rights reserved.
//

import UIKit

class AddTVViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    var newTV:TV!

    @IBOutlet weak var TVCoverImageView: UIImageView!
    @IBOutlet weak var TVNameTextField: UITextField!
    @IBOutlet weak var TVSeasonTextField: UITextField!
    @IBOutlet weak var TVEpisodeToWatchTextField: UITextField!
    
    @IBAction func TVNameEditDidEnd(_ sender: UITextField) {
        self.newTV.name = sender.text
    }
    
    @IBAction func TVSeasonEditDidEnd(_ sender: UITextField) {
        self.newTV.season = Int(sender.text ?? "0")
    }
    @IBAction func TVEpisodeToWatchEditDidEnd(_ sender: UITextField) {
        self.newTV.episodeToWatch = Int(sender.text ?? "0")
    }

    @IBAction func TVCoverTapped(_ sender: UITapGestureRecognizer) {
        //print("tapped")
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            // 这一句，开始调用图库
            self.present(imagePicker,animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newTV = TV(id: UUID().uuidString, name: "", season: 0, episodeToWatch: 0, cover: nil);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("entering shouldPerformSegue")
        if identifier == "unwindSave" {
            if validation() == true {
                return true
            }else{
                return false
            }
        }
        return true
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "unwindSave" {
            _ = TVTable.instance.addAnTV(tv: newTV)
            print("unwindFromSave------")
        }
        
        if segue.identifier == "unwindCancel"{
            print("unwindFromCancel")
        }
    }
    private func validation() -> Bool{
        if self.newTV.name == nil || self.newTV.name == "" {
            
            let alert = UIAlertController(title: nil, message: "请输入剧名", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "好的", style: .default, handler: nil)
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        if self.newTV.season == nil || self.newTV.season! <= 0 {
            let alert = UIAlertController(title: nil, message: "请输入第几季", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "好的", style: .default, handler: nil)
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        if self.newTV.episodeToWatch == nil || self.newTV.episodeToWatch <= 0 {
            
            let alert = UIAlertController(title: nil, message: "请输入该看第几集", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "好的", style: .default, handler: nil)
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        
        return true
    }

}

extension AddTVViewController{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            // 将图片显示给UIImageView
            self.TVCoverImageView.image = image
            self.newTV.cover = image
        }else{
            print("pick image wrong")
        }
        // 收回图库选择界面
        self.dismiss(animated: true, completion: nil)
    }
}
