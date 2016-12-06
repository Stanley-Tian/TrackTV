//
//  TrackTVTableViewController.swift
//  TrackTV
//
//  Created by 史丹利复合田 on 2016/10/18.
//  Copyright © 2016年 史丹利复合田. All rights reserved.
//

import UIKit

class TrackTVTableViewController: UITableViewController {
    
    var TVs:[TV]!
    var userEditing = false
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    @IBAction func startEditing(_ sender: UIBarButtonItem) {       
        if self.tableView.isEditing == true {// 点击了完成按钮
            editBarButtonItem.title = "编辑"
            self.tableView.setEditing(false, animated: true)
            userEditing = false
        }else {// 点击了编辑按钮
            editBarButtonItem.title = "完成"
            self.tableView.setEditing(true, animated: true)
            userEditing = true
        }
    }
    
    private func updateTVOrders(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.tableView.allowsSelectionDuringEditing = true
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        getTVs()
        //TVs = TVTable.instance.getTVs()
        //print(TVs)
        
        }
    private func getTVs(){
        TVs = TVTable.instance.getTVs()
    }
    private func refreshTVs(){
        getTVs()
    }
    override func viewWillAppear(_ animated: Bool) {
        TVs = TVTable.instance.getTVs()
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TVs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TrackTVTableViewCell
        cell.coverImageView.image = TVs[indexPath.row].cover
        cell.nameLabel.text = TVs[indexPath.row].name
        cell.seasonLabel.text = "第\(TVs[indexPath.row].season!)季"
        cell.episodeToWatchLabel.text = "第\(TVs[indexPath.row].episodeToWatch!)集"
        if TVs[indexPath.row].showTime == nil{
            cell.showTimeLabel.text = "未知"
        }else{
            cell.showTimeLabel.text = "\(TVs[indexPath.row].showTime!)"
            
        }
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if userEditing == true {
            performSegue(withIdentifier: "editSegue", sender:TVs[indexPath.row])
        }else{
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        print("self editing: \(self.isEditing)")
        if self.userEditing == true {
            let deleteTVAction = UITableViewRowAction(style: .destructive, title: "删除", handler: {(action,indexPath) -> Void in
                let currentTV = self.TVs[indexPath.row]
                _ = TVTable.instance.deleteAnTV(byId: currentTV.id!)
                self.TVs.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            })
            return [deleteTVAction]
        }else{
            let addOneEpisodeAction = UITableViewRowAction(style: .default, title: "该看+1", handler: {(action,indexPath) -> Void in
                let currentTV = self.TVs[indexPath.row]
                currentTV.episodeToWatch! += 1
                _ = TVTable.instance.updateAnEpisode(updatedTV: currentTV)// update the database
                self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.left)
            })
            let minusOneEpisodeAction = UITableViewRowAction(style: .default, title: "该看-1", handler: {(action,indexPath) -> Void in
                let currentTV = self.TVs[indexPath.row]
                currentTV.episodeToWatch! -= 1
                _ = TVTable.instance.updateAnEpisode(updatedTV: currentTV)// update the database
                self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.left)
                
            })
            
            addOneEpisodeAction.backgroundColor = .green
            minusOneEpisodeAction.backgroundColor = .blue
            return [addOneEpisodeAction,minusOneEpisodeAction]
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = TVs[sourceIndexPath.row]
        TVs.remove(at: sourceIndexPath.row)
        TVs.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "editSegue" {
           let destinationController =  segue.destination as! AddTVViewController
            destinationController.segueSource = "editSegue"
            destinationController.newTV = sender as! TV
        }
    }
    
    @IBAction func unwindFromSave(segue:UIStoryboardSegue){}
    @IBAction func unwindFromCancel(segue:UIStoryboardSegue){}
}
