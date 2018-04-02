//
//  DetailViewModel.swift
//  iOSnier
//
//  Created by fox on 2018/3/22.
//  Copyright © 2018年 fox. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//http://iosre.com/t/11433/5.json?track_visit=true&forceLoad=true&_=1522480495738

class DetailViewModel {
    var data = BehaviorRelay(value: [Post]())
    private var url : String!
    init(_ url:String) {
      self.url = url
    }
    
    func getDetailArtical(){
        HTTPNetCoreKit.sharedInstance.get(url: url, success: { (model:DetailModel) in
            self.data.accept(model.post_stream.posts)
        }) { (err) in
            print(err)
        }
    }
    
    
}