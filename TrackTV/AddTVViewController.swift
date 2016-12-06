//
//  AddTVViewController.swift
//  TrackTV
//
//  Created by 史丹利复合田 on 2016/10/18.
//  Copyright © 2016年 史丹利复合田. All rights reserved.
//

import UIKit

class AddTVViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate {
    
    var segueSource:String?
    var newTV:TV!
    var pickOption = ["未知","周一","周二","周三","周四","周五","周六","周日"]
    var pickerView = UIPickerView()

    @IBOutlet weak var topNavigationItem: UINavigationItem!

    @IBOutlet weak var TVCoverImageView: UIImageView!
    @IBOutlet weak var TVNameTextField: UITextField!
    @IBOutlet weak var TVSeasonTextField: UITextField!
    @IBOutlet weak var TVEpisodeToWatchTextField: UITextField!
    @IBOutlet weak var TVshowTimeTextField: UITextField!
    
    @IBAction func TVNameEditDidEnd(_ sender: UITextField) {
        self.newTV.name = sender.text
    }
    
    @IBAction func TVSeasonEditDidEnd(_ sender: UITextField) {
        self.newTV.season = Int(sender.text ?? "0")
    }
    @IBAction func TVEpisodeToWatchEditDidEnd(_ sender: UITextField) {
        self.newTV.episodeToWatch = Int(sender.text ?? "0")
    }

    @IBAction func TVshowTimeEditDitEnd(_ sender: UITextField) {
        self.newTV.showTime = sender.text
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
        
        if segueSource == "editSegue"{
            // newTV is already set
            //self.navigationItem.title = "修改"
            self.topNavigationItem.title = "修改"
            //self.navigation
            //title = "修改"
            TVCoverImageView.image = newTV.cover
            TVNameTextField.text = newTV.name
            TVSeasonTextField.text = String(newTV.season!)
            TVshowTimeTextField.text = newTV.showTime
            TVEpisodeToWatchTextField.text = String(newTV.episodeToWatch!)
        }else{
        
        newTV = TV(id:nil, name: "", season: 0, episodeToWatch: 0, cover: nil, showTime: nil)
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddTVViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        //let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddTVViewController.donePicker))
        
        toolBar.setItems([spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        TVshowTimeTextField.inputView = pickerView
        TVshowTimeTextField.inputAccessoryView = toolBar
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func donePicker() {
        
        TVshowTimeTextField.resignFirstResponder()
        
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
            if segueSource == "editSegue" {
                _ = TVTable.instance.updateAnTV(updatedTV: newTV)
            }else{
            _ = TVTable.instance.addAnTV(tv: newTV)
            }
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
        
        if self.newTV.cover == nil {
            self.newTV.cover = self.TVCoverImageView.image
        }
        
        
        return true
    }

}
// MARK: - imagePicker
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

// MARK: - Pickerview

extension AddTVViewController{
    
    @objc(numberOfComponentsInPickerView:) func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        TVshowTimeTextField.text = pickOption[row]
    }
}
