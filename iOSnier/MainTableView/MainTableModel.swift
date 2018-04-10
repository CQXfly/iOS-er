//
//  MainTableModel.swift
//  iOSnier
//
//  Created by fox on 2018/3/21.
//  Copyright © 2018年 fox. All rights reserved.
//

import Foundation
struct MainTableModel:Codable {
    var users : [User]?
//    var age : String
//    var date : String
    var topic_list:Topic_list

}

struct User:Codable {
    var id : Int
    var username:String
    var avatar_template:String  
}

struct Topic_list: Codable {
    
    var can_create_topic:Bool
    var more_topics_url: String?
    var draft: String?
    
    var draft_key:String
    var draft_sequence:String?
    
    var per_page:Int
    
    var topics:[Topic]
    
}


struct Topic:Codable {
    var id : Int
    var title:String
    var fancy_title:String
    var slug:String
    var posts_count:Int
    var reply_count:Int
    var highest_post_number:Int
    var image_url:String?
    
    var created_at:String
    var last_posted_at:String?
    var bumped:Bool
    var bumped_at:String
    var unseen:Bool
    var pinned:Bool
    var unpinned:String?
    var visible:Bool
    var closed:Bool
    var archived:Bool
    var bookmarked:String?
    var liked:String?
    
    var views:Int
    var like_count:Int
    var has_summary:Bool
    
    var category_id:Int
    var pinned_globally:Bool
    
    
    var archetype:String
    var last_poster_username:String
    
    var featured_link:String?
    var has_accepted_answer:Bool
    var posters:[Poster]
    
}

struct Poster:Codable {
    var extras:String?
    var description:String
    var user_id:Int
    var primary_group_id:String?
    
}

