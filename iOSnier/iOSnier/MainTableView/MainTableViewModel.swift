//
//  MainTableViewModel.swift
//  iOSnier
//
//  Created by fox on 2018/3/21.
//  Copyright © 2018年 fox. All rights reserved.
//

import Foundation
import RxSwift
import QXKit
public class MainTableViewModel {
    var topics : Variable<[Topic]>
    var users : [User]
    public init() {
        topics = Variable([])
        users = [User]()
    }
//    http://iosre.com/u/zoumadeng.json?stats=false&_=1521687164901
//    http://7xibfi.com1.z0.glb.clouddn.com/user_avatar/bbs.iosre.com/zhang/50/4875_1.png
    
//    http://iosre.com/latest?exclude_category_ids%5B%5D=12&no_definitions=true&no_subcategories=false&page=1&slow_platform=20&_=1522480495737  
    /// getdatafromServer
    func fetchData() {
        let url = "http://iosre.com/latest.json?order=default&_=\(Date.currentTimeStamp(.Long))"
        print(url)
        HTTPNetCoreKit.sharedInstance.get(url: url, success: { (movie:MainTableModel) in
            self.topics.value = movie.topic_list.topics
            self.users = movie.users
        }) { (e) in
        
        }
    }
    
    /// getUserInfo
    /// - parameters:
    ///     - userID: 用户id
    ///     return User 用户模型
    func getUserDetail(_ userID:Int)->User?{
        
        return users.filter { (user) -> Bool in
            return user.id == userID
            }.map({ ( user) in
                let avatar = user.avatar_template.replacingOccurrences(of: "{size}", with: "6464")
                let user1 = User(id: user.id, username: user.username, avatar_template: "http://7xibfi.com1.z0.glb.clouddn.com/"+avatar)
                return user1
            }).first
    }
    
}
