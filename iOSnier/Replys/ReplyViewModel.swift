//
//  ReplyViewModel.swift
//  iOSnier
//
//  Created by fox on 2018/3/26.
//  Copyright © 2018年 fox. All rights reserved.
//

import Foundation
import MarkdownView
class ReplyViewModel {
    
    var stream:[Int] = []
    var cooks:[Post] = [] {
        didSet {
            self.viewmodels = self.cooks.map({ (post) -> ReplyCellViewModel in
                return ReplyCellViewModel(model: post)
            })

        }
    }
    
    var viewmodels:[ReplyCellViewModel] = []
}
