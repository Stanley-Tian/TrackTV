//
//  TV.swift
//  TrackTV
//
//  Created by 史丹利复合田 on 2016/10/18.
//  Copyright © 2016年 史丹利复合田. All rights reserved.
//

import Foundation
import SQLite

class TV {
    var name:String!
    var season:Int?
    var episodeToWatch:Int!
    let id:String?
    var cover:UIImage?
    var showTime:String?
    var order:Int?
    
    init(id:String?, name:String, season:Int, episodeToWatch:Int, cover:UIImage?, showTime:String?) {
        self.name = name
        self.season = season
        self.episodeToWatch = episodeToWatch
        self.cover = cover
        self.id = id // 生成uuid的位置应唯一，不然容易混乱
        self.showTime = showTime
    }
}

class TVTable:MainDatabase {
    static let instance = TVTable()
    
    private let tableTV = Table("TV")
    
    private var id = Expression<String>("id")
    private var name = Expression<String>("name")
    private var season = Expression<Int64>("season")
    private var episodeToWatch = Expression<Int64>("episodeToWatch")
    private var cover = Expression<UIImage>("cover")
    private var showTime = Expression<String?>("showTime")
    private var order = Expression<Int64?>("order")
    
    override func createTable() {
        do {
            try super.db!.run(tableTV.create(ifNotExists: true){ table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(season)
                table.column(episodeToWatch)
                table.column(cover)
            })
            print("创建table成功")
        } catch {
            print("创建table失败")
        }
    }
    // 升级表
    func updateTable(){
        do{
            // add at 1.4 version
            try super.db!.run(tableTV.addColumn(showTime))
            // add at 
            try super.db!.run(tableTV.addColumn(order))
            //try super.db!.run(tableTV.addColumn(showTime))
            print("增加列数据成功")
        } catch {
            print("增加列数据失败")
        }
    }
    // - MARK:CRUD -

    // MARK:CREATE
//    func addAnTV(name:String, season:Int64, episodeToWatch:Int64, cover:UIImage) -> Int64?{
//        do {
//            let insert = tableTV.insert(self.id <- UUID().uuidString,
//                                        self.name <- name,
//                                        self.season <- season,
//                                        self.episodeToWatch <- episodeToWatch,
//                                        self.cover <- cover)
//            let rowid = try db!.run(insert)
//            
//            return rowid
//        } catch {
//            print("Insert failed")
//            return nil
//        }
//    }
    func addAnTV(tv:TV) -> Int64?{
        do {
            let insert = tableTV.insert(self.id <- UUID().uuidString,
                                        self.name <- tv.name,
                                        self.season <- Int64(tv.season!),
                                        self.episodeToWatch <- Int64(tv.episodeToWatch!),
                                        self.cover <- tv.cover!,
                                        self.showTime <- tv.showTime)
            let rowid = try db!.run(insert)
            
            return rowid
        } catch {
            print("Insert failed")
            return nil
        }
    }

    // MARK:READ
    func getTVs() -> [TV] {
        var TVs = [TV]()
        
        do {
            for row in try db!.prepare(self.tableTV.order(order)){

                TVs.append(TV(id: row[id], name: row[name], season: Int(row[season]), episodeToWatch: Int(row[episodeToWatch]), cover: row.get(cover), showTime: row[showTime] ))

            }
        }catch{
            print("获取数据失败")
        }
        return TVs
    }
    // MARK:UPDATE
    func updateAnEpisode(updatedTV:TV) -> Bool{
        let TVToUpdate = tableTV.filter(id == updatedTV.id!)
        
        do {
            let update = TVToUpdate.update(episodeToWatch <- Int64(updatedTV.episodeToWatch!))
            if try db!.run(update) > 0 {
                return true
            }else{
                return false
            }
            
        } catch {
            print("更新数据失败")
            return false
        }
    }
    func updateAnTV(updatedTV:TV) -> Bool{
        let TVToUpdate = tableTV.filter(id == updatedTV.id!)
        
        do {
            let update = TVToUpdate.update([name <- updatedTV.name,
                                            season <- Int64(updatedTV.season!),
                                            episodeToWatch <- Int64(updatedTV.episodeToWatch!),
                                            cover <- updatedTV.cover!,
                                            showTime <- updatedTV.showTime
                                            ])
            if try db!.run(update) > 0 {
                return true
            }else{
                return false
            }
            
        } catch {
            print("更新数据失败")
            return false
        }
    }
    
    
    /*
    func updateAnTV(byId TVId:String, newName:String, newBrief:String, newPortrait:UIImage, newImage:UIImage) -> Bool{
        let TVToUpdate = tableTV.filter(id == TVId)
        
        do {
            let update = TVToUpdate.update([
                name <- newName,
                brief <- newBrief,
                portrait <- newPortrait,
                image <- newImage,
                ])
            if try db!.run(update) > 0 {
                return true
            }else{
                return false
            }
            
        } catch {
            print("更新员工数据失败")
            return false
        }
    }
 */
    // MARK:DELETE
    func deleteAnTV(byId TVId:String) -> Bool {
        do {
            let TVToDelete = tableTV.filter(id == TVId)
            if try db!.run(TVToDelete.delete()) > 0 {
                return true
            } else {
                return false
            }
        } catch {
            print("删除uuju失败！")
            return false
        }
    }
    
}
