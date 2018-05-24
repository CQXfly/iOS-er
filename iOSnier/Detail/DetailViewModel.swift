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


//http://iosre.com/posts 回复  post
/**
 *  Cookie
 
    _ga=GA1.2.749192080.1503456495; OUTFOX_SEARCH_USER_ID_NCOO=599992775.5610898; _gid=GA1.2.1938015665.1523251190; _ga=GA1.2.749192080.1503456495; OUTFOX_SEARCH_USER_ID_NCOO=599992775.5610898; _gid=GA1.2.1938015665.1523251190; _t=eb229715854de6e70e9fdbfba8c1ccc7; ___rl__test__cookies=1523324451147; _forum_session=aklwcW5VV3U2M1NQbkJ5WFprc3l3L2hsNGV3cjduK0Z4R3VCc3RKUlZjbVNaVm83MFo5aUdaOUtaTFk4a0UxWWt5ZVBQMTZKd241MVk0dkpBQi9vY2pnbkFYUVRlRThoVXlLN3ZmbGNsSTFubU94ODk3VmozcDc0Y1NWeFlEb3VJRlc1SG42dnBEaU9yY1JESTBGT2M2Y0ozZTlNa3RCQ2N0ZWtzRTU2N1lqZVVNYmROZFQwR215RFRKYzdkZFU1LS1iN0tTSVdSWEZxanl0YjFHRWRZcEV3PT0%3D--3962fdb7fadc074a963b96ff55956be3f587a678
 
 Referer:
        http://iosre.com/t/hikari/11458/48
 
 params
 raw: 读书人偷书不算偷？还死不承认啊
 unlist_topic: false
 category: 5
 topic_id: 11458
 is_warning: false
 archetype: regular
 typing_duration_msecs: 5800
 composer_open_duration_msecs: 78551
 featured_link:
 nested_post: true
 */

//JCKUPoiVxBWnUnrSkqu9101evpT+cqZJG5BEkoZe/c5z/kfp4jJh6DjzW+MeZhYtYzlR10+p9LtLaxPVIbi3XQ==



//http://iosre.com/t/hikari/11458  可以利用爬虫 爬取 csrf-token 发帖可以使用之

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
