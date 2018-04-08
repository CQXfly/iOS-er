//
//  ReplyCellViewModel.swift
//  iOSnier
//
//  Created by fox on 2018/4/4.
//  Copyright © 2018年 fox. All rights reserved.
//

import UIKit
class ReplyCellViewModel {
    let markDownV:MarkDownView
    let height:CGFloat
    let username:String
    let avatar:String
    init(model:Post) {
        
        
        if model.name != "" {
            self.username = model.name
        } else {
            self.username = model.username
        }
        
        self.avatar = "http://7xibfi.com1.z0.glb.clouddn.com/" + model.avatar_template.replacingOccurrences(of: "{size}", with: "64")
        
        self.markDownV = MarkDownView()
        self.markDownV.url = model.cooked
        self.height = self.markDownV.mdHeight + 48
        
    }
}
