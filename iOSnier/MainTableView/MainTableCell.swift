//
//  MainTableCell.swift
//  iOSnier
//
//  Created by fox on 2018/3/21.
//  Copyright © 2018年 fox. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class MainTableCell : UITableViewCell {
    
    @IBOutlet weak var header: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var lastPostLabel: UILabel!
    
    @IBOutlet weak var createTimeLabel: UILabel!
    
    @IBOutlet weak var postCountLabel: UILabel!
    
    @IBOutlet weak var replyCountLabel: UILabel!
    
    var user:User?{
        didSet{
            header.kf.setImage(with:URL(string: user!.avatar_template) , placeholder:  nil, options: nil, progressBlock: nil) { (image,_,_,_) in
                self.header.image = image
            }
            
            nameLabel.text = user!.username
        }
    }
    
    var topic:Topic? {
        didSet{
            
            topicLabel.text = topic!.title
            categoryLabel.text = String(topic!.category_id)
            createTimeLabel.text = "发布于" + topic!.created_at.transformBTDateString().getDateDescription1(type: .None)
            
            postCountLabel.text = String(topic!.posts_count)
            lastPostLabel.text = "最后更新于" + (topic!.last_posted_at ?? "").transformBTDateString().getDateDescription1(type: .None)  
            replyCountLabel.text = String(topic!.reply_count)
            
            
        }
    }
    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        categoryLabel.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-16)
            maker.top.equalToSuperview()
        }
        
        header.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(categoryLabel.snp.bottom).offset(0)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(header.snp.trailing).offset(8)
            make.centerY.equalTo(header.snp.centerY)
        }
        
        topicLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(16)
            maker.trailing.equalToSuperview().offset(-16)
            maker.top.equalTo(header.snp.bottom).offset(4)
        }
        
        createTimeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(topicLabel.snp.leading)
            make.top.equalTo(topicLabel.snp.bottom).offset(16)
        }
        
        lastPostLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(createTimeLabel)
        }
        
        postCountLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(topicLabel.snp.leading)
            make.top.equalTo(createTimeLabel.snp.bottom ).offset(16)
        }
        
        replyCountLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(lastPostLabel)
            make.top.equalTo(postCountLabel)
        }
        
        
    }
}
