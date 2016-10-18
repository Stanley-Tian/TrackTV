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

    @IBOutlet weak var TVCoverImageView: UIImageView!
    @IBOutlet weak var TVNameTextField: UITextField!
    @IBOutlet weak var TVSeasonTextField: UITextField!
    @IBOutlet weak var TVEpisodeToWatchTextField: UITextField!
    
    @IBAction func TVNameEditDidEnd(_ sender: UITextField) {
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

extension AddTVViewController{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            // 将图片显示给UIImageView
            self.TVCoverImageView.image = image
        }else{
            print("pick image wrong")
        }
        // 收回图库选择界面
        self.dismiss(animated: true, completion: nil)
    }
}
