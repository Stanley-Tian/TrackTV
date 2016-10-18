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
    var name = ""
    var season = 0
    var episodeToWatch = 0
    
    init(name:String, season:Int, episodeToWatch:Int) {
        self.name = name
        self.season = season
        self.episodeToWatch = episodeToWatch
    }
}
