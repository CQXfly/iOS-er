//
//  DetailModel.swift
//  iOSnier
//
//  Created by fox on 2018/3/22.
//  Copyright © 2018年 fox. All rights reserved.
//

import Foundation

struct DetailModel:Codable {
    var post_stream:Post_stream
}

struct Post_stream : Codable {
    var posts:[Post]
    var stream:[Int]?
}

struct Post: Codable {
    var id : Int
    var name:String?
    var username:String
    var avatar_template:String
    var created_at:String
    var cooked:String
    var post_number:Int
    var post_type:Int
    var updated_at:String
    var incoming_link_count:Int
    var reply_count:Int
    var reply_to_post_number:Int?
    var quote_count:Int
    var avg_time:Int?
    var reads:Int
    var score:Float
    var yours:Bool
    var topic_id:Int
    var topic_slug:String
    var display_username:String?
    var primary_group_name:String?
    var primary_group_flair_url:String?
    var primary_group_flair_bg_color:String?
    var primary_group_flair_color:String?
    var version:Int
    var can_edit:Bool
    var can_delete:Bool
    var can_recover:Bool
    var can_wiki:Bool
}

//link_counts: [],
//read: true,
//user_title: null,
//actions_summary: [],
//moderator: true,
//admin: false,
//staff: true,
//user_id: 2518,
//hidden: false,
//hidden_reason_id: null,
//trust_level: 3,
//deleted_at: null,
//user_deleted: false,
//edit_reason: null,
//can_view_edit_history: false,
//wiki: false,
//can_accept_answer: false,
//can_unaccept_answer: false,
//accepted_answer: false
